return {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
        local diff = require('mini.diff')
        local statusline = require('mini.statusline')
        diff.setup({
        })
        statusline.setup({
            use_icons = true
        })

        vim.keymap.set("n", "<leader>p", function ()
           diff.toggle_overlay()
        end)
    end,
    -- keys = {
        -- { "<leader>p", function() require('mini.diff').toggle_overlay() end }
    -- }

}

