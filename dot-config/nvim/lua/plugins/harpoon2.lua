return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>a", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Quick Menu" },
      { "<leader>A", function() require("harpoon"):list():add() end, desc = "Add file" },
      { "<leader>1", function() require("harpoon"):list():select(1) end },
      { "<leader>2", function() require("harpoon"):list():select(2) end },
      { "<leader>3", function() require("harpoon"):list():select(3) end },
      { "<leader>4", function() require("harpoon"):list():select(4) end },
      { "<leader>5", function() require("harpoon"):list():select(5) end },
    },
}
