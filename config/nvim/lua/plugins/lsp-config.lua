return {
    "neovim/nvim-lspconfig",
    dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp"},
    config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- This will automatically set up the installed language servers
        require("mason-lspconfig").setup_handlers({function(server_name)
            lspconfig[server_name].setup({
                capabilities = capabilities
            })
        end})
    end
}
