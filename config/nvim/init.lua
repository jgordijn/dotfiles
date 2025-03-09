vim.cmd('language en_US.UTF-8')

require("config.lazy")
require("config.keymaps")


vim.cmd.colorscheme "catppuccin"
-- Optional: set the flavor (latte, frappe, macchiato, mocha)
vim.g.catppuccin_flavour = "mocha"


