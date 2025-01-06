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
        mappings = {
          n = {
            ["d"] = require("telescope.actions").delete_buffer,
            ["q"] = require("telescope.actions").close,
            ["J"] = require("telescope.actions").preview_scrolling_down,
            ["K"] = require("telescope.actions").preview_scrolling_up,
            ["H"] = require("telescope.actions").preview_scrolling_left,
            ["L"] = require("telescope.actions").preview_scrolling_right,
            ["<Enter>"] = require("telescope.actions").select_default,
            ["<S-Enter>"] = function(prompt_bufnr)
              require("telescope.actions").file_vsplit(prompt_bufnr)
            end,
          },
          i = {
            ["<esc>"] = require("telescope.actions").close,
            ["J"] = require("telescope.actions").preview_scrolling_down,
            ["K"] = require("telescope.actions").preview_scrolling_up,
            ["H"] = require("telescope.actions").preview_scrolling_left,
            ["L"] = require("telescope.actions").preview_scrolling_right,
            ["<CR>"] = require("telescope.actions").select_default,
            ["<S-Enter>"] = function(prompt_bufnr)
              require("telescope.actions").file_vsplit(prompt_bufnr)
            end,
          },
        },
      },
      pickers = {
        colorscheme = {
          theme = "ivy",
          sort_mru = true,
          sort_lastused = true,
          initial_mode = "normal",
          enable_preview = true,
          prompt_title = "Colorschemes",
        },
        find_files = {
          theme = "ivy",
          sort_mru = true,
          sort_lastused = true,
          initial_mode = "insert",
          prompt_title = "Files",
        },
        buffers = {
          theme = "ivy",
          sort_mru = true,
          sort_lastused = true,
          initial_mode = "normal",
          prompt_title = "Buffers",
        },
        live_grep = {
          theme = "ivy",
          sort_mru = true,
          sort_lastused = true,
          initial_mode = "insert",
          prompt_title = "Grep (without file extension)",
        },
        help_tags = {
          theme = "ivy",
          sort_mru = true,
          sort_lastused = true,
          initial_mode = "normal",
          prompt_title = "Help",
        },
        diagnostics = {
          theme = "ivy",
          sort_mru = true,
          sort_lastused = true,
          initial_mode = "normal",
          prompt_title = "Diagnostics",
        },
        keymaps = {
          theme = "ivy",
          sort_mru = true,
          sort_lastused = true,
          initial_mode = "normal",
          prompt_title = "Keymaps",
        },
        current_buffer_fuzzy_find = {
          theme = "ivy",
          sort_mru = true,
          sort_lastused = true,
          initial_mode = "insert",
          prompt_title = "Buffer fuzzy",
        },
        lsp_references = {
          theme = "ivy",
          sort_mru = true,
          sort_lastused = true,
          initial_mode = "normal",
          prompt_title = "References",
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
      { "<space>gf", "<cmd>Telescope live_grep<CR>", desc = "Grep (without file extension)" },
      {
        "<space>gg",
        function()
          require("custom.telescope.multigrep")()
        end,
        desc = "Grep (with file extension)",
      },
      { "<space>f", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<space>b", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<space>k", "<cmd>Telescope keymaps<CR>", desc = "Telescope keymaps" },
      { "<space>Y", "<cmd>Telescope yank_history prompt_title=Yank_Tracker<CR>", desc = "Yank history" },
      { "<space>t", "<cmd>Telescope treesitter prompt_title=TreeSymbols<CR>", desc = "Treesitter" },
      { "<space>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer fuzzy" },
      { "gd", "<cmd>Telescope lsp_definitions<CR>", desc = "LSP definitions" },
      { "gr", "<cmd>Telescope lsp_references<CR>", desc = "LSP references" },
      { "<space>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer fuzzy" },
      {
        "<space>c",
        function()
          require("telescope.builtin").find_files({
            cwd = vim.fn.stdpath("config"),
            prompt_title = "Config",
          })
        end,
        desc = "Config",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      telescope.load_extension("fzf")
      telescope.load_extension("yank_history")
    end,
  },
}