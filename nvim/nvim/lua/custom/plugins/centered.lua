return {
  "arnamak/stay-centered.nvim",
  lazy = false,
  cond = function()
    return vim.bo.filetype ~= "snacks_terminal"
  end,
  opts = {},
}
