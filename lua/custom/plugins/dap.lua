return {
  "igorlfs/nvim-dap-view",
  cmd = { "DapViewOpen" },
  opts = {},
  dependencies = {
    {
      "mfussenegger/nvim-dap",
      lazy = true,
      config = function()
        local dap = require("dap")

        vim.fn.sign_define("DapBreakpoint", {
          text = " ",
          texthl = "DiagnosticSignError",
        })
        vim.fn.sign_define("DapBreakpointCondition", {
          text = " ",
          texthl = "DiagnosticSignWarn",
        })
        vim.fn.sign_define("DapStopped", {
          text = " ",
          texthl = "DiagnosticSignInfo",
        })
        vim.fn.sign_define("DapLogPoint", {
          text = " ",
          texthl = "DiagnosticSignInfo",
        })

        if require("nixCatsUtils").enableForCategory("symfony") then
          dap.adapters.php = {
            type = "executable",
            command = "php-debug-adapter",
          }

          dap.configurations.php = {
            {
              type = "php",
              request = "launch",
              name = "Symfony",
              port = 9003,
              pathMappings = {
                ["/app"] = "${workspaceFolder}",
              },
            },
          }
        end

        if require("nixCatsUtils").enableForCategory("laravel") then
          dap.adapters.php = {
            type = "executable",
            command = "php-debug-adapter",
          }
          dap.configurations.php = {
            {
              type = "php",
              request = "launch",
              name = "Laravel",
              port = 9003,
            },
            {
              type = "php",
              request = "launch",
              name = "Laravel Sail",
              port = 9003,
              pathMappings = {
                ["/var/www/html"] = "${workspaceFolder}",
              },
            },
          }
        end
      end,
    },
  },
}
