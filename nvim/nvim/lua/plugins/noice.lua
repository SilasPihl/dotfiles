return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- Add any additional options here if needed
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify", -- Optional: For notifications
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- Override markdown rendering to use Treesitter for plugins like cmp
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- Presets for easier configuration
        presets = {
          bottom_search = true, -- Use a classic bottom cmdline for search
          command_palette = true, -- Position cmdline and popupmenu together
          long_message_to_split = true, -- Send long messages to a split
          inc_rename = false, -- Disable input dialog for inc-rename.nvim
          lsp_doc_border = false, -- Disable border for hover docs and signature help
        },
      })
    end,
  },
}
