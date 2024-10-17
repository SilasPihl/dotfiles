return {
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false -- Disable automatic setup for barbar
    end,
    opts = {
      animation = true, -- Enable animations for tab movement
      auto_hide = false, -- Ensure the tabline is always visible
      insert_at_start = false, -- Don't insert new buffers at the start of the tabline
      clickable = true, -- Allow clicking to switch between buffers
      icons = {
        filetype = { enabled = true }, -- Show icons for different file types
        buffer_number = false, -- Disable buffer numbers in the tabline
      },
      maximum_length = 30, -- Limit tab width to 30 characters
    },
    config = function()
      -- Setup barbar manually if auto setup is disabled
      require('barbar').setup()

      -- Custom key mappings for barbar
      vim.api.nvim_set_keymap('n', '<C-n>', ':BufferNext<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<C-p>', ':BufferPrevious<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>bc', ':BufferClose<CR>', { noremap = true, silent = true, desc = 'Close buffer' })
      vim.api.nvim_set_keymap('n', '<leader>bp', ':BufferPick<CR>', { noremap = true, silent = true, desc = 'Pick buffer' })
      vim.api.nvim_set_keymap('n', '<leader>bn', ':BufferMoveNext<CR>', { noremap = true, silent = true, desc = 'Move buffer next' })
      vim.api.nvim_set_keymap('n', '<leader>bp', ':BufferMovePrevious<CR>', { noremap = true, silent = true, desc = 'Move buffer previous' })
    end,
  },
}
