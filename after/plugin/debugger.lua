local mason_dap = require("mason-nvim-dap")
local dap = require("dap")
local ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

function starts_with(str, prefix)
    return string.sub(str, 1, string.len(prefix)) == prefix
end

-- Dap Virtual Text
dap_virtual_text.setup()

mason_dap.setup({
    automatic_installation = true,
    handlers = {
        function(config)
            require("mason-nvim-dap").default_setup(config)
        end,
    },
})

require("dap-python").setup("python3")

-- Configurations
table.insert(dap.configurations.python, {
    name = "Python Debugger: API.py",
    type = "python",
    request = "launch",
    program = "${workspaceFolder}/api.py",
    console = "integratedTerminal",
    env = {
        DEV_MODE = "true"
    }
})

local keymap_restore = {}
dap.listeners.after['event_initialized']['me'] = function()
    for _, buf in pairs(vim.api.nvim_list_bufs()) do
        local keymaps = vim.api.nvim_buf_get_keymap(buf, 'n')
        for _, keymap in pairs(keymaps) do
            if keymap.lhs == "K" then
                table.insert(keymap_restore, keymap)
                vim.api.nvim_buf_del_keymap(buf, 'n', 'K')
            end
        end
    end
    vim.api.nvim_set_keymap(
        'n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
end

dap.listeners.after['event_terminated']['me'] = function()
    for _, keymap in pairs(keymap_restore) do
        if keymap.rhs then
            vim.api.nvim_buf_set_keymap(
                keymap.buffer,
                keymap.mode,
                keymap.lhs,
                keymap.rhs,
                { silent = keymap.silent == 1 }
            )
        elseif keymap.callback then
            vim.keymap.set(
                keymap.mode,
                keymap.lhs,
                keymap.callback,
                { buffer = keymap.buffer, silent = keymap.silent == 1 }
            )
        end
    end
    keymap_restore = {}
end

-- Allow 'q' to close floating dap windows
vim.api.nvim_create_autocmd("FileType", {
    pattern = "dap-float",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<esc>", "<cmd>close!<CR>", { noremap = true, silent = true })
    end
})

-- Dap UI

ui.setup()

vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

dap.listeners.before.attach.dapui_config = function()
    ui.open()
end
dap.listeners.before.launch.dapui_config = function()
    ui.open()
end
dap.listeners.before.event_exited.dapui_config = function()
    ui.close()
end

vim.keymap.set("n", "<leader>dl", function() dap.run_last() end, { desc = "Run Last" })
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
vim.keymap.set("n", "<F8>", dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F9>", dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F7>", dap.step_out, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Set Conditional Breakpoint" })
vim.keymap.set("n", "<leader>du", function() ui.toggle() end, { desc = "Toggle UI" })
vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { desc = "Open REPL" })
vim.keymap.set("n", "<leader>dq", function()
    require('dap').terminate()
    require("nvim-dap-virtual-text").toggle()
    require("dap.repl").append("Exiting Debugger...")
end, { desc = "Terminate" })
vim.keymap.set("n", "<leader>db", function() dap.list_breakpoints() end, { desc = "List Breakpoints" })
vim.keymap.set("n", "<leader>de", function() dap.set_exception_breakpoints({ "all" }) end,
    { desc = "Set Exception Breakpoints" })
