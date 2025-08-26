return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>sa", function() require("harpoon"):list():add() end, desc = "Add to Harpoon" },
    { "<leader>ss", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Toggle Harpoon Menu" },
    { "<leader>1",  function() require("harpoon"):list():select(1) end, desc = "Select Harpoon 1" },
    { "<leader>2",  function() require("harpoon"):list():select(2) end, desc = "Select Harpoon 2" },
    { "<leader>3",  function() require("harpoon"):list():select(3) end, desc = "Select Harpoon 3" },
    { "<leader>4",  function() require("harpoon"):list():select(4) end, desc = "Select Harpoon 4" },
  },
  config = true,
}
