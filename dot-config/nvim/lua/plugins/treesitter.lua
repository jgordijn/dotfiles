return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        ensure_installed = {
          'bash',
          'c',
          'diff',
          'git_config',
          'git_rebase',
          'gitcommit',
          'gitignore',
          'hocon',
          'html',
          'java',
          'javascript',
          'kotlin',
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'scala',
          'typescript',
          'query',
          'vim',
          'vimdoc',

          -- Add other languages you use frequently
        },
        auto_install = true,
      })
      vim.api.nvim_create_autocmd({ "FileType" }, {
        callback = function()
          if require("nvim-treesitter.parsers").has_parser() then
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
          else
            vim.opt.foldmethod = "syntax"
          end
        end,
      })
    end,
  }
}
