return {
  {
    "nui.nvim",
    dep_of = { "laravel.nvim" },
  },
  {
    "laravel.nvim",
    for_cat = "php.laravel",
    event = {
      "BufEnter composer.json",
    },
    ft = { "php", "vue", "blade" },
    load = function(name)
      -- check if the local path for development exist
      local p = vim.fn.finddir("laravel.nvim", vim.fn.expand("~/code/plugins/"))
      if p == "" then
        vim.g.lze.load(name)
      end
      vim.opt.rtp:append(p)
    end,
    keys = {
      {
        "<leader>ll",
        function()
          Laravel.pickers.laravel()
        end,
        desc = "Laravel: Open Laravel Picker",
      },
      {
        "<leader>lu",
        function()
          Laravel.commands.run("hub")
        end,
        desc = "Laravel Artisan hub",
      },
      {
        "<c-g>",
        function()
          Laravel.commands.run("view:finder")
        end,
        desc = "Laravel: Open View Finder",
      },
      {
        "<leader>la",
        function()
          Laravel.pickers.artisan()
        end,
        desc = "Laravel: Open Artisan Picker",
      },
      {
        "<leader>lt",
        function()
          Laravel.commands.run("actions")
        end,
        desc = "Laravel: Open Actions Picker",
      },
      {
        "<leader>lr",
        function()
          Laravel.pickers.routes()
        end,
        desc = "Laravel: Open Routes Picker",
      },
      {
        "<leader>lh",
        function()
          Laravel.run("artisan docs")
        end,
        desc = "Laravel: Open Documentation",
      },
      {
        "<leader>lm",
        function()
          Laravel.pickers.make()
        end,
        desc = "Laravel: Open Make Picker",
      },
      {
        "<leader>lc",
        function()
          Laravel.pickers.commands()
        end,
        desc = "Laravel: Open Commands Picker",
      },
      {
        "<leader>lo",
        function()
          Laravel.pickers.resources()
        end,
        desc = "Laravel: Open Resources Picker",
      },
      {
        "<leader>lp",
        function()
          Laravel.commands.run("command_center")
        end,
        desc = "Laravel: Open Command Center",
      },
      {
        "gf",
        function()
          local ok, res = pcall(function()
            if Laravel.app("gf").cursorOnResource() then
              return "<cmd>lua Laravel.commands.run('gf')<cr>"
            end
          end)
          if not ok or not res then
            return "gf"
          end
          return res
        end,
        expr = true,
        noremap = true,
      },
    },
    after = function(plugin)
      require("laravel").setup({
        lsp_server = "intelephense",
        features = {
          pickers = {
            provider = "snacks",
          },
        },
        user_commands = {
          composer = {
            quality = {
              cmd = { "quality" },
              desc = "Runs the quality script in composer.json",
            },
          },
        },
      })
    end,
  },
}
