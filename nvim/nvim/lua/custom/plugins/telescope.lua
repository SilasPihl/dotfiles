return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "mickael-menu/zk-nvim",
      "gbprod/yanky.nvim",
    },
    opts = {
      defaults = {
        scroll_strategy = "limit",
        path_display = {
          filename_first = {
            reverse_directories = true,
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
          },
          i = {
            ["<esc>"] = require("telescope.actions").close,
            ["J"] = require("telescope.actions").preview_scrolling_down,
            ["K"] = require("telescope.actions").preview_scrolling_up,
            ["H"] = require("telescope.actions").preview_scrolling_left,
            ["L"] = require("telescope.actions").preview_scrolling_right,
            ["<S-Enter>"] = function(prompt_bufnr)
              require("telescope.actions").file_vsplit(prompt_bufnr)
            end,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          file_ignore_patterns = { "%.git/", "^node_modules/", "^.venv/" },
          theme = "ivy",
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
        buffers = {
          theme = "ivy",
          sort_mru = true,
          sort_last = true,
          initial_mode = "normal",
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
      {
        "<space>gf",
        function()
          require("custom.telescope.multigrep")()
        end,
        desc = "Grep string with file",
      },
      {
        "<space>gg",
        "<cmd>Telescope grep_string sort_mru=true sort_last=true initial_mode=normal theme=ivy<CR>",
        desc = "Grep string",
      },
      { "<space>f", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<space>b", "<cmd>Telescope buffers <CR>", desc = "Buffers" },
      {
        "<space>k",
        "<cmd>Telescope keymaps sort_mru=true sort_last=true initial_mode=normal theme=ivy<CR>",
        desc = "Telescope Keymaps",
      },
      {
        "<space>y",
        "<cmd>Telescope yank_history sort_mru=true sort_last=true initial_mode=normal theme=ivy<CR>",
        desc = "Yank history",
      },
      {
        "<space>u",
        "<cmd>Telescope undo sort_mru=true sort_last=true initial_mode=normal theme=ivy<CR>",
        desc = "Undo history",
      },
      {
        "<space>c",
        "<cmd>Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<CR>",
        desc = "Find config files",
      },
      {
        "<space>t",
        "<cmd>Telescope treesitter sort_mru=true sort_last=true initial_mode=normal theme=ivy<CR>",
        desc = "Treesitter",
      },
      { "gd", "<cmd>Telescope lsp_definitions<CR>", desc = "LSP Definitions" },
      { "gr", "<cmd>Telescope lsp_references<CR>", desc = "LSP References" },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      telescope.load_extension("fzf")
      telescope.load_extension("undo")
      telescope.load_extension("yank_history")
    end,
  },
}