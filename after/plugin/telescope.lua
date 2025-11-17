require("telescope").load_extension("ui-select")

local builtin = require('telescope.builtin')
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local sorters = require "telescope.sorters"

local function get_relative_buffer_path()
    local full_path = vim.api.nvim_buf_get_name(0)
    -- In case one of the following conditions apply, use the cwd.
    -- - We aren't in a file buffer.
    -- - The filename is empty.
    -- - The path isn't absolute.
    if full_path == nil or
        full_path == '' or
        not starts_with(full_path, '/') then
        return '.'
    end

    -- Return the relative path of the buffer to the current cwd.
    -- That's what proximity sort expects.
    local cwd = vim.fn.getcwd()

    local relative_path = string.gsub(full_path, cwd .. '/', '')

    -- If we are in some nestewd directory inside the cwd, return the relative path
    if starts_with(full_path, cwd) then
        return string.sub(full_path, string.len(cwd) + 2)
    end

    -- Otherwise fallback to cwd
    return '.'
end

local function get_file_score(file_path, base_path)
    if base_path == '.' then
        return 0
    end

    -- Split paths into directory components
    local file_parts = {}
    for part in string.gmatch(file_path, "[^/]+") do
        table.insert(file_parts, part)
    end

    local base_parts = {}
    for part in string.gmatch(base_path, "[^/]+") do
        table.insert(base_parts, part)
    end

    -- Find common prefix length
    local common_length = 0
    for i = 1, math.min(#file_parts - 1, #base_parts - 1) do
        if file_parts[i] == base_parts[i] then
            common_length = i
        else
            break
        end
    end

    -- Distance = directories to go up from base + directories to go down to file
    local distance = (#base_parts - 1 - common_length) + (#file_parts - 1 - common_length)
    return distance
end

-- A file picker that sorts entries based on the proximity of files relative to
-- the file path of the current buffer.
-- Requires the `proximity-sort` and `fd` binaries to be present.
local function get_proximity_sorter(base_path, opts)
    opts = opts or {}
    local fuzzy_sorter = sorters.get_fuzzy_file(opts)
    local fzy = opts.fzy_mod or require "telescope.algos.fzy"

    return sorters.Sorter:new {
        discard = true,

        scoring_function = function(_, prompt, line)
            -- Check for actual matches before running the scoring alogrithm.
            if not fzy.has_match(prompt, line) then
                return -1
            end

            local fuzzy_score = fuzzy_sorter.scoring_function(
                fuzzy_sorter, prompt, line)

            if fuzzy_score == -1 then
                return -1
            end
            local proximity_score = get_file_score(line, base_path) / 100

            return fuzzy_score + proximity_score
        end,

        highlighter = function(_, prompt, display)
            return fzy.positions(prompt, display)
        end,
    }
end

vim.keymap.set('n', '<C-p>', function()
    builtin.find_files({
        sorter = get_proximity_sorter(get_relative_buffer_path())
    })
end)
vim.keymap.set('n', '<leader>p', function()
    builtin.find_files({
        sorter = get_proximity_sorter(get_relative_buffer_path())
    })
end)
vim.keymap.set('n', '<C-n>', function()
    builtin.find_files({
        hidden = true, no_ignore = true, no_ignore_parent = true })
end)
vim.keymap.set('n', '<leader>s', builtin.live_grep)
vim.keymap.set('n', '<leader>;', builtin.buffers)
