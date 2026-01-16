if require("nixCatsUtils").enableForCategory("symfony") then
  return require('core.lsp.phpactor_symfony')
end

return require('core.lsp.phpactor_laravel')
