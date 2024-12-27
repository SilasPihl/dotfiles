return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "fredrikaverpil/neotest-golang", version = "*" }, -- Installation
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-golang"),
        },
        log_level = vim.log.levels.INFO,
        consumers = {},
        icons = {},
        highlights = {},
        floating = { border = "rounded", max_height = 0.9, max_width = 0.9, options = {} },
        strategies = { integrated = { width = 80 } },
        run = { enabled = true },
        summary = {
          enabled = true,
          animated = true,
          follow = true,
          expand_errors = true,
          mappings = {
            expand = "e",
            expand_all = "E",
            output = "o",
            short = "s",
            attach = "a",
            jumpto = "j",
            stop = "x",
            run = "r",
            debug = "d",
            mark = "m",
            run_marked = "R",
            debug_marked = "D",
            clear_marked = "c",
            target = "t",
            clear_target = "T",
            next_failed = "n",
            prev_failed = "p",
            watch = "w",
          },
          open = true,
          count = 10,
        },
        output = { enabled = true, open_on_run = "short" },
        output_panel = { enabled = true, open = "botright split" },
        quickfix = { enabled = true, open = true },
        status = { enabled = true, virtual_text = true, signs = true },
        state = { enabled = true },
        watch = { enabled = true, symbol_queries = {} },
        diagnostic = { enabled = true, severity = vim.diagnostic.severity.ERROR },
        projects = {},
      })

      vim.api.nvim_set_keymap("n", "<leader>T", "", { noremap = true, silent = true, desc = "Tests" })
      vim.api.nvim_set_keymap(
        "n",
        "<leader>Tf",
        "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
        { noremap = true, silent = true, desc = "Test file" }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>Td",
        "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<CR>",
        { noremap = true, silent = true, desc = "Test file with debugger" }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>Tn",
        "<cmd>lua require('neotest').run.run()<CR>",
        { noremap = true, silent = true, desc = "Test nearest" }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>Tl",
        "<cmd>lua require('neotest').run.run_last()<CR>",
        { noremap = true, silent = true, desc = "Test last" }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>Tw",
        "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<CR>",
        { noremap = true, silent = true, desc = "Watch file" }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>Ts",
        "<cmd>lua require('neotest').summary.toggle()<CR>",
        { noremap = true, silent = true, desc = "Summary toggle" }
      )
    end,
  },
}