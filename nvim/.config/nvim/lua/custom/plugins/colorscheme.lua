return {
  'catppuccin/nvim',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  opts = {
    flavour = 'macchiato',
  },
  config = function()
    -- Load the colorscheme here
    vim.cmd.colorscheme 'catppuccin-macchiato'
  end,
}
