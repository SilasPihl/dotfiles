return {
  'mikavilpas/yazi.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    {
      '<leader>-',
      function()
        require('yazi').setup {
          open_for_directories = true,
        }
        require('yazi').yazi()
      end,
      desc = 'Open the file manager',
    },
    {
      -- Open in the current working directory
      '<leader>cw',
      function()
        require('yazi').setup {
          open_for_directories = true,
          open_files_in_current_buffer = true,
        }
        require('yazi').yazi(nil, vim.fn.getcwd())
      end,
      desc = "Open the file manager in nvim's working directory",
    },
  },
}
