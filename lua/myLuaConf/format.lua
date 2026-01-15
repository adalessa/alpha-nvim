require("lze").load({
  {
    "conform.nvim",
    for_cat = "format",
    -- cmd = { "" },
    -- event = "",
    -- ft = "",
    keys = {
      { "<leader>FF", desc = "[F]ormat [F]ile" },
    },
    -- colorscheme = "",
    after = function(plugin)
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          -- NOTE: download some formatters in lspsAndRuntimeDeps
          -- and configure them here
          lua = { "stylua" },
          go = { "gofmt", "goimports" },
          json = { "jq" },
          nix = { "nixfmt" },
          blade = { "blade-formatter" },
          php = function(bufnr)
            -- check if the name contains views use blade formatter
            local fname = vim.uri_from_bufnr(bufnr)
            if fname:match("views") then
              return { "blade-formatter" }
            end

            return { "pint" }
          end,
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>FF", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "[F]ormat [F]ile" })
    end,
  },
})
