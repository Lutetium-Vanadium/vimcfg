return {
    {
        "FabijanZulj/blame.nvim",
        cmd = { "BlameToggle", "ToggleBlame" },
        opts = {},
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = {
            signs              = {
                add       = { text = "▕" },
                change    = { text = "▕" },
                untracked = { text = " " },
            },
            signcolumn         = true, -- just put signs in the signcolumn
            numhl              = false,
            linehl             = false,
            word_diff          = false,
            current_line_blame = false,
            on_attach          = function(bufnr)
                local gs = require("gitsigns")
                vim.keymap.set("n", "gh", gs.preview_hunk, { buffer = bufnr })
            end,
        },
    }

}
