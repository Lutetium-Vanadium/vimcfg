local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    'sumneko_lua',
    'rust_analyzer',
})

-- Fix Undefined global 'vim'
lsp.configure('sumneko_lua', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-j>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-k>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    if client.name == "eslint" then
        vim.cmd.LspStop('eslint')
        return
    end

    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)

    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)

    vim.keymap.set("n", "<leader>g", vim.diagnostic.open_float, opts)

    vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]g", vim.diagnostic.goto_next, opts)

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "gd", builtin.lsp_definitions, opts)
    vim.keymap.set("n", "gi", builtin.lsp_implementations, opts)
    vim.keymap.set("n", "gr", builtin.lsp_references, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})
