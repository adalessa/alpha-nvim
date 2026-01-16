-- NOTE: various, non-plugin config
require("myLuaConf.opts_and_keys")
require("myLuaConf.autocmd")

_G.tap = function(value, fn)
  fn(value)

  return value
end

-- NOTE: register an extra lze handler with the spec_field 'for_cat'
-- that makes enabling an lze spec for a category slightly nicer
require("lze").register_handlers(require("nixCatsUtils.lzUtils").for_cat)

-- NOTE: Register another one from lzextras. This one makes it so that
-- you can set up lsps within lze specs,
-- and trigger lspconfig setup hooks only on the correct filetypes
require("lze").register_handlers(require("lzextras").lsp)

require("myLuaConf.plugins")

require("myLuaConf.LSPs")

require("myLuaConf.diagnostic")
require("myLuaConf.replace")

if nixCats("debug") then
  require("myLuaConf.debug")
end

if nixCats("format") then
  require("myLuaConf.format")
end

-- Symfony and more related

if nixCats("makefile") then
  require("myLuaConf.tools.makefile")
end

if nixCats("php.symfony") then
  vim.opt.path:append("tests/**/httpstubs/**/")
  require("myLuaConf.tools.graphql")
end
