return {
    "williamboman/mason.nvim",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls" -- For Lua
                -- Add other language servers you want automatically installed:
                -- "tsserver",  -- TypeScript/JavaScript
                -- "pyright",   -- Python
            },
            automatic_installation = true
        })
    end
}
