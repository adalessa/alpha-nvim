return {
  "jameswolensky/marker-groups.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required
  },
  config = function()
    require("marker-groups").setup({
      -- Your configuration here
    })
  end,
}
