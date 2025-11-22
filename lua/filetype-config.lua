local autocmd = vim.api.nvim_create_autocmd

local filetype_group = vim.api.nvim_create_augroup("FileTypeConfig", {})

autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.luc" },
    callback = function()
        vim.opt_local.filetype = "lucid";
        vim.opt_local.syntax = "verilog"
    end
})

autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.uasm" },
    callback = function()
        vim.opt_local.filetype = "asm";
        vim.opt_local.syntax = "asm"
    end
})

autocmd('FileType', {
    group = filetype_group,
    pattern = { "text", "tex", "markdown" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.textwidth = 72
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end
})

autocmd('FileType', {
    group = filetype_group,
    pattern = { "hpp", "cpp", "lucid" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end
})

autocmd('FileType', {
    group = filetype_group,
    pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact",
        "html", "css", "scss", "json" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end
})

autocmd('FileType', {
    group = filetype_group,
    pattern = { "python" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.shiftwidth = 4
    end
})

autocmd('FileType', {
    group = filetype_group,
    pattern = { "Avante*" },
    callback = function()
        -- Disable line bar and auto wrapping
        vim.opt.textwidth = 0
        vim.opt.colorcolumn = ""
    end
})
