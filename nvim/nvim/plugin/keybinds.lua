-- Move down 10 lines, or to the bottom if there aren't 10 lines above
vim.keymap.set("n", "<c-d>", function()
  local cur_line = vim.fn.line(".")
  local last_line = vim.fn.line("$")
  local target_line = math.min(cur_line + 10, last_line)
  vim.api.nvim_win_set_cursor(0, { target_line, 0 })
end, { desc = "Move down 10 lines or as far as possible" })

-- Move up 10 lines, or to the top if there aren't 10 lines above
vim.keymap.set("n", "<c-u>", function()
  local cur_line = vim.fn.line(".")
  local target_line = math.max(cur_line - 10, 1)
  vim.api.nvim_win_set_cursor(0, { target_line, 0 }) -- Jump to the target line
end, { desc = "Move up 10 lines or as far as possible" })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Switch to the last used buffer
vim.keymap.set("n", "<leader><Tab>", function()
  vim.cmd("buffer #")
end, { desc = "Switch to the last used buffer", silent = true })
