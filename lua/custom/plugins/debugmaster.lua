return {
  "miroshQa/debugmaster.nvim",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function ()
    local dm = require("debugmaster")

    vim.keymap.set({ "n", "v" }, "<leader>d", dm.mode.toggle, { nowait = true })
  end
}
