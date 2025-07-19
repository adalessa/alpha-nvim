return {
  "yetone/avante.nvim",
  version = false,
  enabled = require("nixCatsUtils").enableForCategory("avante"),
  build = "make",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>aa", "<cmd>Avante ask", desc = "Avante Ask" },
  },
  opts = vim.tbl_extend("force", {
    provider = "copilot",
    selector = {
      provider = "snacks",
    },
    -- behaviour = {
    --   enable_claude_text_editor_tool_mode = true,
    -- },
    -- custom_tools = require("custom.avante.tools"),
    -- system_prompt as function ensures LLM always has latest MCP server state
    -- This is evaluated for every message, even in existing chats
    system_prompt = function()
      local hub = require("mcphub").get_hub_instance()
      return hub and hub:get_active_servers_prompt() or ""
    end,
    -- Using function prevents requiring mcphub before it's loaded
    custom_tools = function()
      return {
        require("mcphub.extensions.avante").mcp_tool(),
      }
    end,

    disabled_tools = {
        "list_files",    -- Built-in file operations
        "search_files",
        "read_file",
        "create_file",
        "rename_file",
        "delete_file",
        "create_dir",
        "rename_dir",
        "delete_dir",
        "bash",         -- Built-in terminal access
    },
  }, require("nixCatsUtils").getCatOrDefault("avanteOpts", {}) or {}),
  init = function()
    if require("nixCatsUtils").getCatOrDefault("avanteOpts.load_env_keys") then
      local key = vim.trim(vim.system({ "rbw", "get", "delorean" }):wait().stdout)
      vim.fn.setenv("OPENAI_API_KEY", key)
      vim.fn.setenv("ANTHROPIC_API_KEY", key)
    end
  end,
}
