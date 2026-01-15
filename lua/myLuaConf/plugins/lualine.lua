return {
  "lualine.nvim",
  lazy = false,
  after = function(plugin)
    require("lualine").setup({
      icons_enabled = true,
      theme = "auto",
    })
  end,
}
