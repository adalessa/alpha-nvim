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

-- GODOT auto start server
-- paths to check for project.godot file
local paths_to_check = {'/', '/../'}
local is_godot_project = false
local godot_project_path = ''
local cwd = vim.fn.getcwd()

-- iterate over paths and check
for key, value in pairs(paths_to_check) do
    if vim.uv.fs_stat(cwd .. value .. 'project.godot') then
        is_godot_project = true
        godot_project_path = cwd .. value
        break
    end
end

-- check if server is already running in godot project path
local is_server_running = vim.uv.fs_stat(godot_project_path .. '/server.pipe')
-- start server, if not already running
if is_godot_project and not is_server_running then
    vim.fn.serverstart(godot_project_path .. '/server.pipe')
end
