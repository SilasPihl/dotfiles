-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'DaikyXendo/nvim-material-icon',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>b', ':Neotree toggle<CR>', { desc = 'NeoTree toggle' } },
  },
  opts = {
    close_if_last_window = true,
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignore = false,
      },
      window = {
        position = 'left',
        auto_expand_width = true,
        width = 20,
      },
    },
  },
  config = function(_, opts)
    -- Set up Neo-tree with the given options
    require('neo-tree').setup(opts)

    -- Additional logic to ensure Neo-tree closes when it's the last window
    vim.api.nvim_create_autocmd('BufEnter', {
      nested = true,
      callback = function()
        if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == 'neo-tree' then
          vim.cmd 'quit'
        end
      end,
    })
    vim.api.nvim_create_augroup('neotree', {})
    vim.api.nvim_create_autocmd('UiEnter', {
      desc = 'Open Neotree automatically',
      group = 'neotree',
      callback = function()
        if vim.fn.argc() == 0 then
          vim.cmd 'Neotree toggle'
        end
      end,
    })
  end,
}
