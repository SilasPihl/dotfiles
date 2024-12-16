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
    { '<leader>e', ':Neotree toggle<CR>', { desc = 'NeoTree toggle' } },
  },
  opts = {
    close_if_last_window = true,
    auto_clean_after_session_restore = true,
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      filtered_items = {
        hide_hidden = false,
        hide_dotfiles = false,
        force_visible_in_empty_folder = true,
        hide_gitignored = false,
      },
    },
    window = {
      position = 'left',
      auto_expand_width = true,
    },
    default_component_configs = {
      diagnostics = {
        symbols = {
          hint = '',
          info = '',
          warn = '',
          error = '',
        },
        highlights = {
          hint = 'DiagnosticSignHint',
          info = 'DiagnosticSignInfo',
          warn = 'DiagnosticSignWarn',
          error = 'DiagnosticSignError',
        },
      },
    },
  },
  config = function(_, opts)
    -- Set up Neo-tree with the given options
    require('neo-tree').setup(opts)

    -- Ensure Neo-tree closes if it's the last window
    vim.api.nvim_create_autocmd('BufEnter', {
      nested = true,
      callback = function()
        if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == 'neo-tree' then
          vim.cmd 'quit'
        end
      end,
    })

    -- Open Neo-tree automatically on startup
    vim.api.nvim_create_autocmd('VimEnter', {
      desc = 'Open Neotree automatically on startup',
      callback = function()
        vim.cmd 'Neotree show'
      end,
    })
  end,
}
