return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  enabled = require("nixCatsUtils").enableForCategory("ai"),
  keys = {
    {
    	"<leader>az",
    	function()
    		require("avante.model_selector").open()
    	end,
    },
  },
  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  opts = vim.tbl_extend("force", {
    provider = "copilot",
    file_selector = {
      provider = "snacks",
    },
  }, require("nixCatsUtils").getCatOrDefault("avanteOpts", {}) or {}),
  config = function(_, o)
    require("avante").setup(o)
    require("custom.avante-recipes")
  end,
}
