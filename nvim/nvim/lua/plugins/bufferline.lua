return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      offsets = {
        {
          filetype = "neo-tree",
          text = "File explorer",
          separator = true,
          text_align = "left",
        },
      }
    },
  },
  keys = {
    { "<Tab>",   "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    { "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
    { "<C-c>",   "<cmd>bdelete<CR>",             desc = "Close buffer" },
    { "<C-1>",   "<cmd>BufferLinePick 1<CR>",    desc = "Go to buffer 1" },
    { "<C-2>",   "<cmd>BufferLinePick 2<CR>",    desc = "Go to buffer 2" },
    { "<C-3>",   "<cmd>BufferLinePick 3<CR>",    desc = "Go to buffer 3" },
    { "<C-4>",   "<cmd>BufferLinePick 4<CR>",    desc = "Go to buffer 4" },
    { "<C-5>",   "<cmd>BufferLinePick 5<CR>",    desc = "Go to buffer 5" },
    { "<C-6>",   "<cmd>BufferLinePick 6<CR>",    desc = "Go to buffer 6" },
    { "<C-7>",   "<cmd>BufferLinePick 7<CR>",    desc = "Go to buffer 7" },
    { "<C-8>",   "<cmd>BufferLinePick 8<CR>",    desc = "Go to buffer 8" },
    { "<C-9>",   "<cmd>BufferLinePick 9<CR>",    desc = "Go to buffer 9" },
    { "<C-9>",   "<cmd>BufferLinePick 9<CR>",    desc = "Go to buffer 9" },
  },
}
