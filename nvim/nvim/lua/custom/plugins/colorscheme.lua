return {
  "catppuccin/nvim",
  lazy = false, -- ensure it loads during startup
  priority = 1000, -- adjust loading priority as needed
  opts = {
    flavour = "macchiato", -- initial flavour
    background = { -- :h background
      light = "frappe",
      dark = "macchiato", -- default dark background to macchiato
    },
    transparent_background = true, -- disables setting the background color
    integrations = {
      cmp = true,
      copilot_vim = true,
      fidget = true,
      gitsigns = true,
      harpoon = true,
      lsp_trouble = true,
      mason = true,
      neotest = true,
      noice = true,
      notify = true,
      octo = true,
      treesitter = true,
      treesitter_context = false,
      symbols_outline = true,
      illuminate = true,
      which_key = true,
      barbecue = {
        dim_dirname = true,
        bold_basename = true,
        dim_context = false,
        alt_background = false,
      },
      snacks = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
      },
    },
    custom_highlights = function(C)
      return {
        FloatBorder = { bg = C.mantle, fg = C.peach },
        FloatTitle = { fg = C.text, bg = C.mantle },
        NormalFloat = { fg = C.text, bg = C.mantle },

        -- Snacks specific
        SnacksPickerMatch = { fg = C.mauve, style = { "italic" } },
        SnacksPickerInput = { fg = C.text, bg = C.crust },
        SnacksPickerInputTitle = { fg = C.crust, bg = C.mauve },
        SnacksInputField = { bg = C.surface1, fg = C.text },
        SnacksPickerInputBorder = { fg = C.text, bg = C.crust },
        SnacksPickerListTitle = { fg = C.mantle, bg = C.red },
        SnacksPickerListCursorLine = { bg = C.base },
        SnacksInputBorder = { bg = C.base, fg = C.peach },
        SnacksInputTitle = { bg = C.base, fg = C.peach },
        SnacksInputIcon = { bg = C.base, fg = C.peach },
        SnacksInputNormal = { bg = C.base, fg = C.text },

        -- WhichKey
        WhichKeyBorder = { fg = C.peach, bg = C.mantle },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin-macchiato")
    vim.o.background = "dark"
  end,
}