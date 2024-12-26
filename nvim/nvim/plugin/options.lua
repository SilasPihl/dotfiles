local opt = vim.opt

----- interesting options -----

-- you have to turn this one on :)
opt.inccommand = "split"

-- best search settings :)
opt.smartcase = true
opt.ignorecase = true

----- personal preferences -----
opt.number = true
opt.relativenumber = true
opt.clipboard = "unnamedplus"

opt.splitbelow = true
opt.splitright = true

opt.signcolumn = "yes"
opt.shada = { "'10", "<0", "s10", "h" }

opt.swapfile = false

-- don't have `o` add a comment
opt.formatoptions:remove("o")

opt.wrap = true
opt.linebreak = true

opt.tabstop = 4
opt.shiftwidth = 4

opt.more = false

opt.foldmethod = "manual"
