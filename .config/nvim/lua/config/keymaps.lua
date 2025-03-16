vim.keymap.set('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>', { noremap = true })

vim.keymap.set('n', '<leader>n', ":bnext<CR>", {noremap = true, silent = true})
vim.keymap.set('n', '<leader>b', ":bprevious<CR>", {noremap = true, silent = true})

-- make clipboard accessible
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }


