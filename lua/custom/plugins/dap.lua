return {
  "mfussenegger/nvim-dap",
  lazy = true,
  keys = {
    { "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "Continue" },
    { "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
    { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", desc = "Step Into" },
    { "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", desc = "Step Over" },
    { "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", desc = "Step Out" },
    { "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", desc = "Toggle REPL" },
    { "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", desc = "Run Last" },
    { "<leader>dv", "<cmd>DapViewToggle<cr>", desc = "Open the UI" },
  },
  dependencies = { "igorlfs/nvim-dap-view" },
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
}
