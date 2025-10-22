local vaults = {
  {
    name = "personal",
    path = "~/vaults/personal",
  },
  {
    name = "work",
    path = "~/vaults/work",
  },
}

local events = vim
  .iter(vaults)
  :map(function(vault)
    return vim.fn.expand(vault.path)
  end)
  :map(function(vault)
    return {
      string.format("BufReadPre %s/*.md", vault),
      string.format("BufNewFile %s/*.md", vault),
    }
  end)
  :flatten()
  :totable()

return {
  "obsidian-nvim/obsidian.nvim",
  enabled = require("nixCatsUtils").enableForCategory("obsidian"),
  version = "*",
  lazy = true,
  event = events,
  cmd = {
    "ObsidianMenu",
  },
  keys = {
    { "<leader>ob", "<cmd> Obsidian<cr>", desc = "Obsidian" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = vaults,
    legacy_commands = false,
    pickers = { name = "snacks.pick" },
    completion = {
      nvim_cmp = false,
      blink = true,
    },
  },
}
