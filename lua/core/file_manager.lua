return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  enabled = require("nixCatsUtils").enableForCategory("fileManager"),
  keys = {
    { "-", "<cmd>Oil<cr>" },
  },
  cmd = { "Oil" },
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
