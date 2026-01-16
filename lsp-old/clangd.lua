return {
  cmd = {
    "clangd",
    "--compile-commands-dir=.",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  filetypes = {
    "cpp",
  },
  root_markers = { "sdkconfig", "CMakeLists.txt", ".git" },
  -- root_dir = function(fname)
  --   if type(fname) == "number" then
  --     fname = vim.api.nvim_buf_get_name(fname)
  --   end
  --   local util = require("lspconfig.util")
  --   local git_root = vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
  --   return util.root_pattern("sdkconfig", "CMakeLists.txt")(fname) or git_root or vim.fn.getcwd()
  -- end,
  capabilities = {
    offsetEncoding = { "utf-16" },
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}
