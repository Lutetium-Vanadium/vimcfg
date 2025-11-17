require('neo-tree').setup({
    close_if_last_window = true,
    filesystem = {
        follow_current_file = {
            enabled = true,
        },
        use_libuv_file_watcher = true,
    },

})

vim.keymap.set("n", "<leader>b", "<Cmd>Neotree<CR>")
