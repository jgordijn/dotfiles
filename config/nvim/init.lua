vim.cmd('language en_US.UTF-8')

require("config.lazy")
require("config.keymaps")


vim.cmd.colorscheme "catppuccin"
-- Optional: set the flavor (latte, frappe, macchiato, mocha)
vim.g.catppuccin_flavour = "mocha"

-- Enable both absolute and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

