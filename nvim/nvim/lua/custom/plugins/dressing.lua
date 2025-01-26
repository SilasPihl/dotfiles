return {
  "stevearc/dressing.nvim",
  opts = {
    input = {
      -- Set to false to disable the vim.ui.input implementation
      enabled = true,

      -- Default prompt string
      default_prompt = "Input",

      -- Trim trailing `:` from prompt
      trim_prompt = true,

      -- Can be 'left', 'right', or 'center'
      title_pos = "left",

      -- The initial mode when the window opens (insert|normal|visual|select).
      start_mode = "insert",

      -- These are passed to nvim_open_win
      border = "rounded",
      -- 'editor' and 'win' will default to being centered
      relative = "cursor",

      -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      prefer_width = 40,
      width = nil,
      max_width = { 140, 0.9 },
      min_width = { 20, 0.2 },

      buf_options = {},
      win_options = {
        -- Disable line wrapping
        wrap = false,
        -- Indicator for when text exceeds window
        list = true,
        listchars = "precedes:…,extends:…",
        sidescrolloff = 0,
      },

      -- Set to `false` to disable
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

      override = function(conf)
        -- This is the config that will be passed to nvim_open_win.
        return conf
      end,

      get_config = nil,
    },
    select = {
      -- Set to false to disable the vim.ui.select implementation
      enabled = true,

      -- Priority list of preferred vim.select implementations
      backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

      -- Trim trailing `:` from prompt
      trim_prompt = true,

      telescope = nil,

      fzf = {
        window = {
          width = 0.5,
          height = 0.4,
        },
      },

      fzf_lua = {},

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

      format_item_override = {},

      get_config = nil,
    },
  },
}