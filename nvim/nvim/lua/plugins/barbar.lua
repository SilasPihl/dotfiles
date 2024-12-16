return {
  {
    "romgrk/barbar.nvim",
    lazy = false,
    opts = {
      animation = true,
      auto_hide = false,
      clickable = true,
      focus_on_close = "left",
      insert_at_end = false,
      insert_at_start = false,
      maximum_length = 30,
      maximum_padding = 2,
      minimum_padding = 1,
      no_name_title = "[No Name]",
    },
    keys = {
      { "<C-c>", "<Cmd>BufferClose<CR>", desc = "Close buffer" },
      { "<S-Tab>", "<Cmd>BufferPrevious<CR>", desc = "Previous buffer" },
      { "<Tab>", "<Cmd>BufferNext<CR>", desc = "Next buffer" },
    },
  },
}
