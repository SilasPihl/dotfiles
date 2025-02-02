return {
  "stevearc/dressing.nvim",
  opts = {
    input = {
      -- Enable the vim.ui.input implementation
      enabled = true,

      -- Default prompt string
      default_prompt = "Input",

      -- Trim trailing `:` from prompt
      trim_prompt = true,

      -- Position of the title ('left', 'right', or 'center')
      title_pos = "left",

      -- Initial mode when the window opens
      start_mode = "insert",

      -- Border style
      border = "rounded",

      -- Window placement relative to 'cursor' or 'editor'
      relative = "cursor",

      -- Window size preferences
      prefer_width = 40,
      width = nil,
      max_width = { 140, 0.9 },
      min_width = { 20, 0.2 },

      -- Buffer and window options
      buf_options = {},
      win_options = {
        wrap = false, -- Disable line wrapping
        list = true, -- Enable listchars for overflow indicators
        listchars = "precedes:…,extends:…",
        sidescrolloff = 0,
      },

      -- Key mappings for input
      mappings = {
        n = {
          ["<Esc>"] = "Close",
          ["<CR>"] = "Confirm",
        },
        i = {
          ["<C-c>"] = "Close",
          ["<CR>"] = "Confirm",
          ["<Up>"] = "HistoryPrev",
          ["<Down>"] = "HistoryNext",
        },
      },

      -- Override configuration for `nvim_open_win`
      override = function(conf)
        return conf
      end,

      -- Custom configuration per input
      get_config = nil,
    },
    select = {
      -- Enable the vim.ui.select implementation
      enabled = true,

      -- Priority list of preferred backends
      backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

      -- Trim trailing `:` from prompt
      trim_prompt = true,

      -- Telescope configuration (optional)
      telescope = nil,

      -- FZF configuration
      fzf = {
        window = {
          width = 0.5,
          height = 0.4,
        },
      },

      -- FZF Lua configuration
      fzf_lua = {},

      -- NUI configuration
      nui = {
        position = "50%",
        relative = "editor",
        border = {
          style = "rounded",
        },
        buf_options = {
          swapfile = false,
          filetype = "DressingSelect",
        },
        win_options = {
          winblend = 0,
        },
        max_width = 80,
        max_height = 40,
        min_width = 40,
        min_height = 10,
      },

      -- Builtin configuration
      builtin = {
        show_numbers = true,
        border = "rounded",
        relative = "editor",

        buf_options = {},
        win_options = {
          cursorline = true,
          cursorlineopt = "both",
          winhighlight = "MatchParen:",
          statuscolumn = " ",
        },

        width = nil,
        max_width = { 140, 0.8 },
        min_width = { 40, 0.2 },
        height = nil,
        max_height = 0.9,
        min_height = { 10, 0.2 },

        mappings = {
          ["<Esc>"] = "Close",
          ["<C-c>"] = "Close",
          ["<CR>"] = "Confirm",
        },

        override = function(conf)
          return conf
        end,
      },

      -- Override for formatting items in the selection
      format_item_override = {},

      -- Custom configuration per select
      get_config = nil,
    },
  },
}
