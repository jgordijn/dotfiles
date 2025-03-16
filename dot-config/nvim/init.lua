vim.cmd('language en_US.UTF-8')

-- Enable both absolute and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

require("config.tabstops")
require("config.lazy")
require("config.keymaps")
require("config.oil")


