return {
  "DreamMaoMao/yazi.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  lazy = false, -- Load immediately for snacks Dashboard
  keys = {
    { "<leader>-", "<cmd>Yazi<CR>", desc = "Open Yazi" },
  },
}
