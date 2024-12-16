return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-media-files.nvim",
      "mickael-menu/zk-nvim",
      'mrcjkb/telescope-manix',
    },
    opts = {
      extensions = {
        ["telescope-media-files"] = {
          cword = true,
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          file_ignore_patterns = { "%.git/", "^node_modules/", "^.venv/" },
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
      },
    },
    keys = {
      { "<leader>/", "<cmd>Telescope live_grep<CR>", desc = "Grep" },
      { "<leader>p", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>b", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>k", "<cmd>Telescope keymaps<CR>", desc = "Telescope Keymaps" },
      { "gd", "<cmd>Telescope lsp_definitions<CR>", desc = "LSP Definitions" },
      { "gr", "<cmd>Telescope lsp_references<CR>", desc = "LSP References" },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      -- Load extensions
      telescope.load_extension("undo")
      telescope.load_extension("media_files")
      telescope.load_extension('manix')
    end,
  },
}
