return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      select_prompts = true,
      diagnostics = {
        enable = true,
        show_on_dirs = false,
      },
      sort_by = 'case_sensitive',
      sync_root_with_cwd = true,
      open_on_tab = false,
      actions = {
        use_system_clipboard = true,
      },
      view = {
        adaptive_size = true,
        side = 'left',
        width = 30,
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
        highlight_diagnostics = true,
        highlight_bookmarks = 'all',
        highlight_clipboard = 'all',
        icons = {
          webdev_colors = true,
          git_placement = 'after',
          modified_placement = 'after',
          glyphs = {
            git = {
              unstaged = 'U',
              staged = 'A',
              unmerged = 'M',
              renamed = 'R',
              untracked = '?',
              deleted = 'D',
              ignored = '!',
            },
          },
        },
      },
      filters = {
        dotfiles = false,
        custom = {},
      },
      git = {
        enable = true,
      },
    }

    -- Key mapping to toggle nvim-tree with <leader>b
    vim.api.nvim_set_keymap('n', '<leader>b', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = 'Toggle NvimTree' })
  end,
}
