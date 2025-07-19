return {
  {
    "zbirenbaum/copilot.lua",
    enabled = require("nixCatsUtils").enableForCategory("copilot"),
    opts = {
      panel = { enabled = false },
      suggestion = { enabled = false },
    },
  },
  {
    "giuxtaposition/blink-cmp-copilot",
    enabled = require("nixCatsUtils").enableForCategory("copilot"),
    dependencies = { "zbirenbaum/copilot.lua" },
  },
}
