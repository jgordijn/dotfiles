-------------------------
-- Options
-------------------------
vim.cmd('language en_US.UTF-8')

-- Enable both absolute and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true


-- Use spaces instead of tabs
vim.opt.expandtab = true
-- Set the width of a tab to 4 spaces
vim.opt.tabstop = 4
-- Set the number of spaces for indentation
vim.opt.shiftwidth = 4
-- Set soft tabstop to 4 spaces
vim.opt.softtabstop = 4

-- make clipboard accessible
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }

-------------------------
-- Generic keymaps
-------------------------
vim.keymap.set('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>', { noremap = true })
vim.keymap.set('n', '<leader>n', ":bnext<CR>", {noremap = true, silent = true})
vim.keymap.set('n', '<leader>b', ":bprevious<CR>", {noremap = true, silent = true})


-------------------------
-- Functions
-------------------------
-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc =  'Auto highlight yanked text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})


