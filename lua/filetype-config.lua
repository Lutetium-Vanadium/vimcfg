local autocmd = vim.api.nvim_create_autocmd

local filetype_group = vim.api.nvim_create_augroup("FileTypeConfig", {})

autocmd('FileType', {
    group = filetype_group,
    pattern = { "text", "tex", "markdown" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.textwidth = 72
    end
})
