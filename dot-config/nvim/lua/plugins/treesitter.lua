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
    end,
  }
}
