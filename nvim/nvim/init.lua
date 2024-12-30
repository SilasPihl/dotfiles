-- Set leader key
vim.g.mapleader = ","

-- Set up the path for lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Latest stable branch
    lazypath,
  })
end

-- Prepend lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "LazyVim/LazyVim",
    },
    { import = "custom/plugins" },
    { import = "custom/plugins/ai" },
  },
  checker = {
    enabled = true, -- Automatically check for plugin updates
  },
  change_detection = {
    enabled = true,
    notify = false, -- Disable notifications for change detection
  },
})
