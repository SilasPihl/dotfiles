return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "leoluz/nvim-dap-go",
    { "thehamsta/nvim-dap-virtual-text", opts = {} },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
      keys = {
        {
          "<leader>du",
          function()
            require("dapui").toggle({})
          end,
          desc = "DAP UI (Toggle)",
        },
      },
      opts = {},
      config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup(opts)
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end
      end,
    },
  },
  keys = {
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Breakpoint (Toggle)",
    },
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "Debug (Start/Continue/Select)",
    },
    {
      "<leader>dk",
      function()
        require("dap").step_over()
      end,
      desc = "Debug (Step Over)",
    },
    {
      "<leader>dj",
      function()
        require("dap").step_into()
      end,
      desc = "Debug (Step Into)",
    },
    {
      "<leader>dK",
      function()
        require("dap").step_out()
      end,
      desc = "Debug (Step Out)",
    },
    {
      "<leader>dr",
      function()
        require("dap").restart()
      end,
      desc = "Debug (Restart)",
    },
    {
      "<leader>dq",
      function()
        require("dap").terminate()
        require("dapui").close({})
      end,
      desc = "Debug (Quit/Stop)",
    },
  },
  config = function()
    require("dap-go").setup()

    if vim.fn.filereadable(".vscode/launch.json") == 1 then
      require("dap.ext.vscode").load_launchjs(nil, { go = { "go" } })
    end

    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define(
      "DapStopped",
      { text = "", texthl = "DiagnosticInfo", linehl = "CursorLine", numhl = "CursorLine" }
    )
    vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
  end,
}