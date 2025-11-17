require("copilot").setup {
    cmd = "Copilot",
    panel = { enabled = false },
    suggestion = { auto_trigger = false },
    filetypes = {
        sh = function()
            if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
                -- disable for .env files
                return false
            end
            return true
        end,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
    },
    on_status_update = require("lualine").refresh,
}

function setup_avante()
    require('avante').setup({
        provider = "copilot",
        mode = "agentic",
        behaviour = {
            auto_apply_diff_after_generation = false,
            support_paste_from_clipboard = true,
            auto_add_current_file = false,
            -- TODO: add tools here
            auto_approve_tool_permissions = {
                "rag_search", "git_diff", "glob", "search_keyword", "read_file_toplevel_symbols", "read_file",
                "create_file",
                "copy_path", "create_dir"
            },
        },
        prompt_logger = {                                           -- logs prompts to disk (timestamped, for replay/debugging)
            enabled = true,                                         -- toggle logging entirely
            log_dir = vim.fn.stdpath("cache") .. "/avante_prompts", -- directory where logs are saved
            fortune_cookie_on_success = false,                      -- shows a random fortune after each logged prompt (requires `fortune` installed)
            next_prompt = {
                normal = "<C-n>",                                   -- load the next (newer) prompt log in normal mode
                insert = "<C-n>",
            },
            prev_prompt = {
                normal = "<C-p>", -- load the previous (older) prompt log in normal mode
                insert = "<C-p>",
            },
        },
        mappings = {
            --- @class AvanteConflictMappings
            diff = {
                ours = "co",
                theirs = "ct",
                all_theirs = "ca",
                both = "cb",
                cursor = "cc",
                next = "]x",
                prev = "[x",
            },
            suggestion = {
                accept = "<C-y>",
                next = "<leader>]",
                prev = "<leader>[",
                dismiss = "<C-c>",
            },
            jump = {
                next = "]]",
                prev = "[[",
            },
            submit = {
                normal = "<CR>",
                insert = "<C-s>",
            },
            cancel = {
                normal = { "<C-c>", "<Esc>", "q" },
                insert = { "<C-c>" },
            },
            sidebar = {
                apply_all = "A",
                apply_cursor = "a",
                retry_user_request = "r",
                edit_user_request = "e",
                switch_windows = "<Tab>",
                reverse_switch_windows = "<S-Tab>",
                remove_file = "d",
                add_file = "@",
                close = { "<Esc>", "q" },
                close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
            },
        },
        windows = {
            width = 35, -- default % based on available width
        },
    })
end

vim.defer_fn(setup_avante, 200)

-- Basic chat functions
vim.keymap.set("n", "<leader>cc", ":AvanteToggle<CR>")
vim.keymap.set("n", "<leader>cr", ":AvanteRefresh<CR>")
-- Quick chat with input
vim.keymap.set("n", "<leader>ci", function()
    local input = vim.fn.input("Ask Avante: ")
    if input ~= "" then
        vim.cmd("AvanteAsk " .. input)
    end
end)

-- Predefined prompts
vim.keymap.set("n", "<leader>ce", ":AvanteAsk explain this code<CR>")
vim.keymap.set("n", "<leader>ct", ":AvanteAsk generate tests for this code<CR>")
vim.keymap.set("n", "<leader>co", ":AvanteAsk optimize this code<CR>")
vim.keymap.set("n", "<leader>cd", ":AvanteAsk add documentation to this code<CR>")
