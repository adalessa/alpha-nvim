---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  filetypes = { "lua" },
  settings = {
    Lua = {
      codeLens = { enable = true },
      hint = { enable = true, semicolon = "Disable" },
      completion = {
        callSnippet = "Replace",
      },
      -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      diagnostics = {
        globals = { "nixCats", "dd", "bt" },
        disable = { "missing-fields" },
      },
    },
  },
}
