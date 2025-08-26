return {
  "tpope/vim-surround",
  "tpope/vim-dispatch",
  "tpope/vim-repeat",
  -- Lazy
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
      user_default_options = {
        names = false,
      },
    },
  },
  {
    "direnv/direnv.vim",
    enabled = vim.fn.executable("direnv") == 1,
    init = function()
      vim.g.direnv_silent_load = 1
    end,
  },
  "echasnovski/mini.ai",
  "adalessa/php-lsp-utils",
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  { "nvzone/volt", lazy = true },
  { "nvzone/menu", lazy = true },
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<plug>(EasyAlign)", desc = "Easy Align", mode = { "n", "x" } },
    },
  },
  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
  },
}
