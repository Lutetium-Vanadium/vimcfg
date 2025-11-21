-- require("lsp-inlayhints").setup {lsplsp
--     inlay_hints = {
--         parameter_hints = { prefix = " " },
--         type_hints = { prefix = "‣ " },
--         highlight = "Comment"
--     }
-- }

local lsp_zero = require('lsp-zero')

-- lsp_zero.extend_lspconfig()

lsp_zero.on_attach(function(client, bufnr)
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

-- Setup mason for LSP server installation
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls',
        'rust_analyzer',
    },
    handlers = {
        lsp_zero.default_setup,

        -- Custom setup for lua_ls
        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end,

        -- Custom setup for rust_analyzer
        rust_analyzer = function()
            require('lspconfig').rust_analyzer.setup({
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            features = "all",
                        },
                        checkOnSave = {
                            command = "clippy",
                        }
                    }
                }
            })
        end,
    }
})

--   פּ ﯟ   some other good icons
local kind_icons = {
    Text = "󰊄",
    Method = "󰊕",
    Function = "󰊕",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
    Copilot = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    sources = {
        -- Copilot Source
        { name = "copilot", group_index = 2 },
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'nvim_lua' },
        { name = 'buffer',  keyword_length = 3 },
        { name = 'luasnip', keyword_length = 2 },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
                copilot = "[Copilot]",
            })[entry.source.name]
            return vim_item
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
})

-- Diagnostic configuration
vim.diagnostic.config({
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '󰮥',
            [vim.diagnostic.severity.INFO] = 'i'
        }
    }
})


-- Setup emmet_ls separately
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config.emmet_ls = {
    capabilities = capabilities,
    filetypes = {
        "css", "eruby", "html", "javascript", "javascriptreact",
        "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue"
    },
    init_options = {
        html = {
            options = {
                ["bem.enabled"] = true,
            },
        },
    }
}

vim.lsp.enable('emmet_ls')

require("conform").setup({
    log_level = vim.log.levels.DEBUG,
    formatters_by_ft = {
        python = { "black", "isort" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
    },
    format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = true,
    },
})
