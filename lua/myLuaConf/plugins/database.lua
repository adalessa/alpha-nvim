local function urlencode(s)
  return (s:gsub("[^%w%-%.%_%~]", function(c)
    return string.format("%%%02X", c:byte())
  end))
end

local function set_atlas()
  vim.ui.input({ prompt = "Password" }, function(value)
    if not value then
      return
    end

    local password = urlencode(value)
    local con = "mariadb://ariel_dalessandro:" .. password .. "@atlas.int.scayle.cloud"
    vim.g.dbs = {
      atlas = con,
    }
  end)
end

return {
  {
    "vim-dadbod",
    for_cat = "general.database",
    dependency_of = { "vim-dadbod-ui" },
  },
  {
    "vim-dadbod-completion",
    for_cat = "general.database",
    on_plugin = { "vim-dadbod" },
  },
  {
    "vim-dadbod-ui",
    for_cat = "general.database",
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    keys = {
      { "<leader><leader>db", "<cmd>DBUIToggle<cr>" },
      {
        "<leader><leader>da",
        function()
          set_atlas()
          vim.cmd("DBUIToggle")
        end,
      },
    },
    before = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 80
      vim.g.db_ui_table_helpers = {
        mysql = {
          Count = "select count(1) from {optional_schema}{table}",
          Explain = "EXPLAIN {last_query}",
        },
        sqlite = {
          Describe = "PRAGMA table_info({table})",
        },
      }
    end,
  },
}
