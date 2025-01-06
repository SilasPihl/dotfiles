return {
  {
    "numToStr/Comment.nvim",
    opts = {
      padding = true, -- Add a space between comment and line
      sticky = true, -- Cursor stays in its position
      ignore = nil, -- No lines are ignored by default
      toggler = {
        line = "gcc", -- Line-comment toggle keymap
        block = "gbc", -- Block-comment toggle keymap
      },
      opleader = {
        line = "gc", -- Line-comment operator-pending keymap
        block = "gb", -- Block-comment operator-pending keymap
      },
      extra = {
        above = "gcO", -- Add comment on the line above
        below = "gco", -- Add comment on the line below
        eol = "gcA", -- Add comment at the end of line
      },
      mappings = {
        basic = true, -- Enable basic keybindings (gcc, gbc, gc, gb)
        extra = true, -- Enable extra keybindings (gcO, gco, gcA)
      },
      pre_hook = nil, -- No pre-comment hook by default
      post_hook = nil, -- No post-comment hook by default
    },
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },
}