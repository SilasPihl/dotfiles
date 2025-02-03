return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "gbprod/yanky.nvim",
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
          prompt_title = "Buffer fuzzy",
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        yank_history = {},
      },
    },
    keys = {
      { "<space>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer fuzzy" },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      telescope.load_extension("fzf")
    end,
  },
}
