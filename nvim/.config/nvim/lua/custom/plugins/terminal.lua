-- Your terminal plugin configuration
return {
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup {
        -- Additional configurations can go here
      }
    end,
    keys = {
      { '<leader>tt', '<cmd>ToggleTerm<cr>', desc = 'Toggle Terminal' }, -- Normal mode toggle
    },
  },
}

-- return {
--   {
--     'akinsho/toggleterm.nvim',
--     config = function()
--       require('toggleterm').setup {
--         -- Add any specific configurations here if needed
--       }
--     end,
--     keys = {
--       { '<leader>tt', '<cmd>ToggleTerm size=20 dir=~/git direction=horizontal<cr>', desc = 'Open a horizontal terminal at the git directory' },
--     },
--   },
-- }
