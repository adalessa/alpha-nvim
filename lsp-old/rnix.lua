---@type vim.lsp.Config
return {
  cmd = { "rnix-lsp" },
  filetypes = { "nix" },
  root_markers = {
    ".git",
  },
}
