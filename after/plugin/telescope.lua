local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files)
vim.keymap.set('n', '<C-n>', function () builtin.find_files({
    hidden = true, no_ignore = true, no_ignore_parent = true }) end)
vim.keymap.set('n', '<leader>s', builtin.live_grep)
vim.keymap.set('n', '<leader>;', builtin.buffers)
