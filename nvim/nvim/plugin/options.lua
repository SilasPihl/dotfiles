local opt = vim.opt

opt.inccommand = "split"
opt.smartcase = true
opt.ignorecase = true
opt.number = true
opt.relativenumber = false
opt.cursorline = true
opt.clipboard = "unnamedplus"
opt.splitbelow = true
opt.splitright = true
opt.signcolumn = "yes"
opt.shada = { "'10", "<0", "s10", "h" }
opt.scrolloff = 15
opt.swapfile = false
opt.formatoptions:remove("o")
opt.wrap = true
opt.linebreak = true
opt.more = false
opt.undofile = true
