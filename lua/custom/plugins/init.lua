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
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        styles = {
          transparency = true,
        },
      })
      vim.cmd("colorscheme rose-pine-moon")
    end,
  },
  {
    "sindrets/diffview.nvim",
  },
}
