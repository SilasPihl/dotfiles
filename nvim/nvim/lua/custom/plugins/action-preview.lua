return {
  "aznhe21/actions-preview.nvim",
  lazy = false,
  opts = {},
  config = function()
    vim.keymap.set({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions, { desc = "Code Actions" })
  end,
}
