return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = {
      defaults = {
        scroll_strategy = "limit",
        path_display = {
          filename_first = {
            reverse_directories = false,
          },
        },
        file_ignore_patterns = { "%.venv" },
        mappings = {
          n = {
            ["d"] = require("telescope.actions").delete_buffer,
            ["q"] = require("telescope.actions").close,
            ["<Enter>"] = require("telescope.actions").select_default,
          },
          i = {
            ["<esc>"] = require("telescope.actions").close,
            ["<CR>"] = require("telescope.actions").select_default,
          },
        },
      },
      pickers = {
        current_buffer_fuzzy_find = {
          theme = "ivy",
          sort_mru = true,
          sort_lastused = true,
          initial_mode = "insert",
          prompt_title = "Buffer grep",
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    },
    keys = {
      -- { "<space>g", "<cmd>Telescope live_grep<CR>", desc = "Grep (without file extension)" },
      -- { "<space>f", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      -- { "<space>b", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      -- { "<space>k", "<cmd>Telescope keymaps<CR>", desc = "Telescope keymaps" },
      -- { "<space>d", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      -- { "<space>Y", "<cmd>Telescope yank_history prompt_title=Yank_Tracker<CR>", desc = "Yank history" },
      -- {
      --   "<space>c",
      --   "<cmd>Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<CR>",
      --   desc = "Find config files",
      -- },
      -- { "<space>t", "<cmd>Telescope treesitter prompt_title=TreeSymbols<CR>", desc = "Treesitter" },
      -- { "gd", "<cmd>Telescope lsp_definitions<CR>", desc = "LSP definitions" },
      -- { "gr", "<cmd>Telescope lsp_references<CR>", desc = "LSP references" },
      -- { "<space>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer fuzzy" },
      -- {
      --   "<space>c",
      --   function()
      --     require("telescope.builtin").find_files({
      --       cwd = vim.fn.stdpath("config"),
      --       prompt_title = "Config",
      --     })
      --   end,
      --   desc = "Config",
      -- },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      telescope.load_extension("fzf")
      telescope.load_extension("yank_history")
    end,
  },
}
