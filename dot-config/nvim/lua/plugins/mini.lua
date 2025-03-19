return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    -- local diff = require('mini.diff')
    -- diff.setup({
    -- })
    -- vim.keymap.set("n", "<leader>p", function ()
    --    diff.toggle_overlay()
    -- end)

    local statusline = require('mini.statusline')
    statusline.setup({
      use_icons = true
    })
  end,
  -- keys = {
  -- { "<leader>p", function() require('mini.diff').toggle_overlay() end }
  -- }
}
