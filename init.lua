require("nixCatsUtils").setup({
  non_nix_value = true,
})

require("core.options")
require("core.replace_action")
require("core.diagnostic")
require("core.autocommands")
require("custom.quickfixmaps")
require("custom.utilitymaps")

-- NOTE: nixCats: You might want to move the lazy-lock.json file
local function getlockfilepath()
  if require("nixCatsUtils").isNixCats and type(require("nixCats").settings.unwrappedCfgPath) == "string" then
    return require("nixCats").settings.unwrappedCfgPath .. "/lazy-lock.json"
  else
    return vim.fn.stdpath("config") .. "/lazy-lock.json"
  end
end

local lazyOptions = {
  lockfile = getlockfilepath(),
}

require("nixCatsUtils.lazyCat").setup(nixCats.pawsible({ "allPlugins", "start", "lazy.nvim" }), {
  require("core.treesitter"),
  require("core.file_manager"),
  require("core.completion"),

  { import = "custom.plugins" },
}, lazyOptions)

require("tools")
