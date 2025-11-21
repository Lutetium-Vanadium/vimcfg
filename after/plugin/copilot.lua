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

require('render-markdown').setup({
    file_types = { 'markdown', "md", "Avante" },
})

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
                "create_file", "copy_path", "create_dir", "replace_in_file",

                -- Extracted from http request sent to Copilot
                "dispatch_agent", "ls", "grep", "delete_tool_use_message", "read_todos", "write_todos",
                "str_replace", "view", "write_to_file", "insert", "undo_edit", "think", "get_diagnostics",
                "attempt_completion", "web_search", "fetch", "read_definitions", "add_file_to_context",
                "remove_file_from_context",
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
        providers = {
            copilot = {
                model = "claude-sonnet-4.5"
            },
        }
    })
end

vim.defer_fn(setup_avante, 200)
