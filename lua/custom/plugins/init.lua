return {
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
  { "echasnovski/mini.ai", opts = true },
  { "echasnovski/mini.surround", opts = true },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<plug>(EasyAlign)", desc = "Easy Align", mode = { "n", "x" } },
    },
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    priority = 100,
    config = true,
  },
  {
    "tiagovla/tokyodark.nvim",
    opts = {
      -- custom options here
    },
    config = function(_, opts)
      require("tokyodark").setup(opts) -- calling setup is optional
      vim.cmd([[colorscheme tokyodark]])
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen" },
  },
}
