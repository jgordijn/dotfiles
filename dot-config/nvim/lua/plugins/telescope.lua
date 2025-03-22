return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- other dependencies
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
  },
  config = function()
    require("telescope").setup({
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
      defaults = {
        follow = true,
        -- Ignore the specified directories
        file_ignore_patterns = {
          "^.git/",
          "^node_modules/",
          "^target/",
          "^.idea/",
          "^.bsp/",
          "^.metals/",
          "^.bloop/"
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          follow = true,
          find_command = {
            "fd",
            "--type", "f",
            "--hidden",
            "--follow",
            -- Exclude the specified directories in the find command
            "--exclude", ".git",
            "--exclude", "node_modules",
            "--exclude", "target",
            "--exclude", ".idea",
            "--exclude", ".bsp",
            "--exclude", ".metals",
            "--exclude", ".bloop"
          },
        }
      }
    })
    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
  end,
  keys = {
    { "<leader>ff",       require("telescope.builtin").find_files,                                                  desc = "[F]ind [F]iles" },
    { '<leader>fk',       require("telescope.builtin").keymaps,                                                     desc = '[F]ind [K]eymaps' },
    { "<leader>fg",       require("telescope.builtin").live_grep,                                                   desc = "[F]ind [G]rep" },
    { "<leader>fb",       require("telescope.builtin").buffers,                                                     desc = "[F]ind buffer by name" },
    { "<leader>fh",       require("telescope.builtin").help_tags,                                                   desc = "[F]ind [H]elp tags" },
    { '<leader><leader>', require("telescope.builtin").buffers,                                                     desc = '[ ] Find existing buffers' },
    -- Shortcut for searching your Neovim configuration files
    { "<leader>fn",       function() require("telescope.builtin").find_files { cwd = vim.fn.stdpath 'config' } end, desc = "[F]ind [N]eovim files" },
    { "<leader>fc",       function() require("telescope.builtin").find_files { cwd = '~/dotfiles' } end,            desc = "[F]ind [C]onfig dot files" },
  }
}
