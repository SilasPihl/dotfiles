return {
  'AckslD/nvim-neoclip.lua',
  dependencies = {
    { 'nvim-telescope/telescope.nvim' },
  },
  keys = {
    { '<leader>sc', '<cmd>Telescope neoclip<cr>', { desc = '[S]earch [C]lipboard' } },
  },
  config = function()
    require('neoclip').setup()
    require('telescope').load_extension 'neoclip'
  end,
}
