return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- other dependencies
  },
  config = function()
    require("telescope").setup({
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
      },
      pickers = {
        find_files = {
          hidden = true,
          follow = true,
        },
        find_directories = {
          hidden = true,
          follow = true,
        }
      }
    })
  end,
}
