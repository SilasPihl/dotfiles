return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "leoluz/nvim-dap-go",
    "theHamsta/nvim-dap-virtual-text",
    "jay-babu/mason-nvim-dap.nvim",
    "nvim-telescope/telescope-dap.nvim",
    "nvim-neotest/nvim-nio",
  },
  keys = {
    { "<F1>", ":lua require'dap'.repl.open()<CR>", desc = "Debug: Open REPL", silent = true },
    { "<F11>", ":lua require'dap'.continue()<CR>", desc = "Debug: Continue", silent = true },
    { "<F12>", ":lua require'dap'.terminate()<CR>", desc = "Debug: Terminate", silent = true },
    { "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>", desc = "Debug: Toggle Breakpoint", silent = true },
    {
      "<leader>B",
      ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
      desc = "Debug: Set Conditional Breakpoint",
      silent = true,
    },
    {
      "<leader>lp",
      ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
      desc = "Debug: Set Log Point",
      silent = true,
    },
    { "<leader>dt", ":lua require'dap-go'.debug_test()<CR>", desc = "Debug: Test", silent = true },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        "delve",
      },
    })
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    require("dap-go").setup()
  end,
}
