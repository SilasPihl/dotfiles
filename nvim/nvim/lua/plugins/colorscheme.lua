-- Plugin configuration
return {
  'catppuccin/nvim',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  opts = {
    flavour = 'macchiato', -- initial flavour
    background = { -- :h background
      light = 'frappe',
      dark = 'macchiato', -- default dark background to macchiato
    },
    transparent_background = true, -- disables setting the background color
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      notify = false,
      mini = true,
      markdown = true,
      treesitter_context = false,
      indent_blankline = {
        enabled = true,
        colored_indent_levels = false,
      },
    },
  },
  config = function()
    -- Define the function to set dark background
    function set_dark_background()
      -- Set the dark flavour and colorscheme
      require('catppuccin').setup { flavour = 'macchiato' }
      vim.o.background = 'dark'
    end

    -- Define the function to set light background
    function set_light_background()
      -- Set the light flavour and colorscheme
      require('catppuccin').setup { flavour = 'frappe' }
      vim.o.background = 'light'
    end

    -- Load the default colorscheme
    vim.cmd.colorscheme 'catppuccin-macchiato'
    vim.o.background = 'dark'

    -- Map the functions to keys (e.g., <leader>bd for dark background and <leader>bl for light background)
    vim.api.nvim_set_keymap('n', '<leader>td', ':lua set_dark_background()<CR>', { noremap = true, silent = true, desc = 'Set dark background' })
    vim.api.nvim_set_keymap('n', '<leader>tl', ':lua set_light_background()<CR>', { noremap = true, silent = true, desc = 'Set light background' })
  end,
}
