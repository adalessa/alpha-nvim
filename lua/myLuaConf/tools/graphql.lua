vim.keymap.set({ "n" }, "<leader>fm", function()
  -- TODO: replace to read all from directory
  local schemas = vim
    .iter({
      "_mutation.yaml",
      "_mutation_external_anonymous.yaml",
      "_mutation_public_api.yaml",
      "_query.yaml",
      "_query_external_anonymous.yaml",
      "_query_public_api.yaml",
    })
    :map(function(schema)
      return vim.fn.findfile(schema, "config/graphql")
    end)
    :filter(function(path)
      return path ~= ""
    end)
    :map(function(path)
      return vim.fn.getcwd() .. "/" .. path
    end)
    :totable()

  require("myLuaConf.localPlugins.graphql.init").pick({
    schemas_path = schemas,
  })
end, { desc = "Graphql Picker" })

vim.keymap.set({ "n" }, "<leader>ft", function()
  Snacks.picker.files({
    dirs = { "resources/generated/types" },
    confirm = function(picker, item)
      picker:close()
      if item then
        Snacks.picker.grep({
          search = string.format("^%s:", vim.fs.basename(item.file):gsub("Type.php", "")),
          paths = ".yaml",
          dirs = {
            "config/graphql/enums",
            "config/graphql/types",
            "config/graphql/input-types",
          },
        })
      end
    end,
  })
end)
