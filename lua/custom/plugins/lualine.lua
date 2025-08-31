---@diagnostic disable: param-type-mismatch
local y_section = {}

if require("nixCatsUtils").enableForCategory("laravel") then
  y_section = {
    {
      function()
        local ok, laravel_version = pcall(function()
          return Laravel.app("status"):get("laravel")
        end)
        if ok then
          return laravel_version
        end
      end,
      icon = { " ", color = { fg = "#F55247" } },
      cond = function()
        local ok, has_laravel_versions = pcall(function()
          return Laravel.app("status"):has("laravel")
        end)
        return ok and has_laravel_versions
      end,
    },
    {
      function()
        local ok, php_version = pcall(function()
          return Laravel.app("status"):get("php")
        end)
        if ok then
          return php_version
        end
        return nil
      end,
      icon = { " ", color = { fg = "#AEB2D5" } },
      cond = function()
        local ok, has_php_version = pcall(function()
          return Laravel.app("status"):has("php")
        end)
        return ok and has_php_version
      end,
    },
    {
      function()
        local ok, hostname = pcall(function()
          return Laravel.extensions.composer_dev.hostname()
        end)
        if ok then
          return hostname
        end
        return nil
      end,
      icon = { " ", color = { fg = "#8FBC8F" } },
      cond = function()
        local ok, is_running = pcall(function()
          return Laravel.extensions.composer_dev.isRunning()
        end)
        return ok and is_running
      end,
    },
    {
      function()
        local ok, unseen_records = pcall(function()
          return #(Laravel.extensions.dump_server.unseenRecords())
        end)

        if ok then
          return unseen_records
        end
        return 0
      end,
      icon = { "󰱧 ", color = { fg = "#FFCC66" } },
      cond = function()
        local ok, is_running = pcall(function()
          return Laravel.extensions.dump_server.isRunning()
        end)

        return ok and is_running
      end,
    },
  }
end

local dmode_enabled = false
vim.api.nvim_create_autocmd("User", {
  pattern = "DebugModeChanged",
  callback = function(args)
    dmode_enabled = args.data.enabled
  end,
})

return {
  "nvim-lualine/lualine.nvim",
  opts = {
    icons_enable = true,
    theme = "auto",
    sections = {
      lualine_y = y_section,
      lualine_a = {
        {
          "mode",
          fmt = function(str)
            return dmode_enabled and "DEBUG" or str
          end,
        --   color = function(tb)
        --     return dmode_enabled and "dCursor" or tb
        --   end,
        },
      },
      lualine_b = {
        "branch",
        "diff",
        "diagnostics",
        {
          function()
            return require("pomodoro").getStatus()
          end,
          color = function()
            if require("pomodoro").type == "running" then
              return { fg = "#40E0D0" }
            else
              return { fg = "#FF6347" }
            end
          end,
          cond = function()
            return require("pomodoro").hasTask()
          end,
        },
      },
      lualine_c = {
        "filename",
        {
          function()
            local filetype = vim.bo.filetype

            if filetype ~= "lua" then
              return ""
            end

            local node = vim.treesitter.get_node()
            if not node then
              return ""
            end
            while node:type() ~= "function_declaration" do
              node = node:parent()
              if not node then
                return ""
              end
            end

            local function_name_node = node:named_child(0)
            if not function_name_node then
              return ""
            end

            return vim.treesitter.get_node_text(function_name_node, 0)
          end,
          icon = { "󰊕", color = { fg = "#40E0D0" } },
        },
      },
    },
  },
}
