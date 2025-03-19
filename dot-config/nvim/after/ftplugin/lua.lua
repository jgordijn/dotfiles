vim.opt_local.shiftwidth = 2

-- Auto format lua files on save
vim.api.nvim_create_autocmd('BufWrite', {
  desc = 'Auto format on save',
  group = vim.api.nvim_create_augroup('auto-save-lua', { clear = true }),
  callback = function()
    vim.lsp.buf.format()
  end,
})
