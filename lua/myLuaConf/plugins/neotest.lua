local adapters = {}
local function add_adapter(plugin)
  table.insert(adapters, require(plugin.name))
end

return {
  {
    "neotest-pest",
    for_cat = "laravel",
    on_plugin = "neotest",
    after = add_adapter,
  },
  {
    "neotest-phpunit",
    for_cat = "php",
    on_plugin = "neotest",
    after = function(plugin)
      if nixCats("symfony") then
        table.insert(
          adapters,
          require("neotest-phpunit")({
            phpunit_cmd = function()
              return "bin/phpunit"
            end,
          })
        )
      else
        table.insert(adapters, require("neotest-phpunit"))
      end
    end,
  },
  {
    "neotest-plenary",
    on_plugin = "neotest",
    after = add_adapter,
  },
  {
    "neotest-golang",
    for_cat = "go",
    on_plugin = "neotest",
    after = function(plugin)
      table.insert(
        adapters,
        require("neotest-golang")({
          go_test_args = { "-v", "-count=1" },
        })
      )
    end,
  },
  {
    "neotest",
    for_cat = "testing",
    after = function(plugin)
      if nixCats("symfony") then
        table.insert(adapters, require("myLuaConf.localPlugins.neotest-behat"))
      end
      require("neotest").setup({
        adapters = adapters,
      })
    end,
    keys = {
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Run nearest test",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run last test",
      },
      {
        "<leader>tm",
        function()
          require("neotest").summary.run_marked()
        end,
        desc = "Run marked tests",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run tests in current file",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle test summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "Open test output",
      },
      {
        "<leader>ti",
        function()
          require("neotest").output.open({ enter = true, last_run = true })
        end,
        desc = "Open last test output",
      },
      {
        "<leader>tpo",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle output panel",
      },
      {
        "<leader>tpl",
        function()
          require("neotest").output_panel.clear()
        end,
        desc = "Clear output panel",
      },
    },
  },
}
