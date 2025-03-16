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
          "bash",
          "vim",
          "vimdoc",
	  "kotlin",
	  "java",
	  "hocon",
	  "git_config",
	  "gitignore",
	  "git_rebase",
	  "gitcommit",

          -- Add other languages you use frequently
        },
        auto_install = true,
      })
    end,
  }
}
