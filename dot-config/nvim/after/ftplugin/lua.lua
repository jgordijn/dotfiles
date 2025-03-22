vim.opt_local.shiftwidth = 2

-- Auto format lua files on save
vim.api.nvim_create_autocmd('BufWrite', {
  desc = 'Auto format on save',
  group = vim.api.nvim_create_augroup('auto-save-lua', { clear = true }),
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.api.nvim_set_keymap('n', '<leader>x', ':%lua<CR>', { desc = 'E[x]ecute Lua buffer', noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>x', ':lua<CR>', { desc = 'E[x]ecute Lua code', noremap = true, silent = true })
