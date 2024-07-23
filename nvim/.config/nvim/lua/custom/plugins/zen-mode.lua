return {
  'folke/zen-mode.nvim',

  keys = {
    { '<leader>z', '<cmd>ZenMode<cr>' },
  },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    window = {
      width = 0.85, -- width will be 85% of the editor width
    },
    plugins = {
      tmux = {
        enabled = true,
      },
      alacritty = {
        enabled = true,
      },
    },
  },
}
