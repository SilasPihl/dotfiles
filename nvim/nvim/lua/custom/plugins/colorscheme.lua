return {
  "catppuccin/nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  opts = {
    flavour = "macchiato", -- initial flavour
    background = { -- :h background
      light = "frappe",
      dark = "macchiato", -- default dark background to macchiato
    },
    transparent_background = true, -- disables setting the background color
    integrations = {
      cmp = true,
      copilot_vim = true,
      fidget = true,
      gitsigns = true,
      harpoon = true,
      lsp_trouble = true,
      mason = true,
      neotest = true,
      noice = true,
      notify = true,
      octo = true,
      telescope = {
        enabled = true,
      },
      treesitter = true,
      treesitter_context = false,
      symbols_outline = true,
      illuminate = true,
      which_key = true,
      barbecue = {
        dim_dirname = true,
        bold_basename = true,
        dim_context = false,
        alt_background = false,
      },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
      },
    },
  },
  config = function()
    vim.cmd.colorscheme("catppuccin-macchiato")
    vim.o.background = "dark"
  end,
}