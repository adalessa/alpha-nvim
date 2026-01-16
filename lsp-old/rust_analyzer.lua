---@type vim.lsp.Config
return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = {
    "Cargo.toml",
    ".git",
  },
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
      checkOnSave = true,

      inlayHints = {
        typeHints = {
          enable = true,
          hideInsideMacro = true,
        },
        parameterHints = {
          enable = true,
        },
        chainingHints = {
          enable = true,
        },
      },

      cargo = {
        loadOutDirsFromCheck = true,
      },
      procMacro = {
        enable = true,
      },
    },
  },
}
