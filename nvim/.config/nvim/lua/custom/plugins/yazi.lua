return {
  'mikavilpas/yazi.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    {
      '<leader>-',
      function()
        -- Open the file manager with default settings
        require('yazi').yazi {
          open_for_directories = true,
        }
      end,
      desc = 'Open the file manager',
    },
    {
      -- Open in the current working directory
      '<leader>cw',
      function()
        -- Open the file manager in the current working directory with custom settings
        require('yazi').yazi({
          open_for_directories = true,
          open_files_in_current_buffer = true,
        }, vim.fn.getcwd())
      end,
      desc = "Open the file manager in nvim's working directory",
    },
  },
}
