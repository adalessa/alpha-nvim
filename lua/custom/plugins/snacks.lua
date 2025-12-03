return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = require("custom.dashboard"),
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    image = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    toggle = { enabled = true },
    words = { enabled = false },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- need to improve. The nix config the MYVIMRC is not the same
        -- so everything is reported from this file not the expected.
        Snacks.debug.inspect = function(...)
          local MAX_INSPECT_LINES = 2000
          local len = select("#", ...) ---@type number
          local obj = { ... } ---@type unknown[]
          local caller = debug.getinfo(1, "S")
          for level = 2, 10 do
            local info = debug.getinfo(level, "S")
            if
              info
              and info.source ~= caller.source
              and info.what ~= "C"
              and info.source ~= "lua"
              and info.source ~= "@" .. (require("nixCats").configDir or "")
            then
              caller = info
              break
            end
          end
          vim.schedule(function()
            local title = "Debug: " .. vim.fn.fnamemodify(caller.source:sub(2), ":~:.") .. ":" .. caller.linedefined
            local lines = vim.split(vim.inspect(len == 1 and obj[1] or len > 0 and obj or nil), "\n")
            if #lines > MAX_INSPECT_LINES then
              local c = #lines
              lines = vim.list_slice(lines, 1, MAX_INSPECT_LINES)
              lines[#lines + 1] = ""
              lines[#lines + 1] = (c - MAX_INSPECT_LINES) .. " more lines have been truncated …"
            end
            Snacks.notify.warn(lines, { title = title, ft = "lua" })
          end)
        end

        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd

        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
        Snacks.toggle.zen():map("<leader>uz")

        local map = function(keys, func, desc, modes)
          vim.keymap.set(modes or { "n" }, keys, func, { desc = desc })
        end

        -- Pickers
        map("<leader>ff", function()
          Snacks.picker.smart({ multi = { "buffers", "files" } })
        end, "Find Files")
        map("<leader>fd", function()
          Snacks.picker.treesitter()
        end, "Find Treesitter Nodes")
        map("<leader>fb", function()
          Snacks.picker.buffers()
        end, "Find Buffers")
        map("<leader>fg", function()
          Snacks.picker.grep()
        end, "Find Grep")
        map("<leader>fw", function()
          Snacks.picker.grep({ search = vim.fn.expand("<cword>") })
        end, "Find Grep current word")
        map("<leader>fh", function()
          Snacks.picker.help()
        end, "Find Help")
        map("<leader>fs", function()
          Snacks.picker.git_status()
        end, "Find Modified Files")
        map("<leader>:", function()
          Snacks.picker.command_history()
        end, "Find Command")
        map("<leader>fi", function()
          Snacks.picker.icons()
        end, "Find Icon")
        map("<c-i>", function()
          Snacks.picker.icons()
        end, "Find Icon", { "i" })

        map("<F6>", function()
          Snacks.explorer()
        end, "Explorer", { "n", "i" })

        -- Scratch
        map("<leader>.", function()
          Snacks.scratch()
        end, "Open the scratch buffer")
        map("<leader>S", function()
          Snacks.scratch.select()
        end, "Open the scratch buffer selector")

        -- Misc
        map("<leader>bd", function()
          Snacks.bufdelete()
        end, "Delete buffer")
        map("<leader>cR", function()
          Snacks.rename.rename_file()
        end, "Rename file")
        map("<c-\\>", function()
          Snacks.terminal()
        end, "Toggle terminal", { "n", "t" })
        map("[[", function()
          Snacks.words.jump(vim.v.count1)
        end, "Next Reference")
        map("]]", function()
          Snacks.words.jump(-vim.v.count1)
        end, "Prev Reference")

        -- GIT
        map("<leader>gB", function()
          Snacks.gitbrowse()
        end, "Git Browse", { "n", "v" })
        map("<leader>gb", function()
          Snacks.git.blame_line()
        end, "Git Blame Line", { "n", "v" })
        map("<leader>gf", function()
          Snacks.lazygit.log_file()
        end, "Lazygit Current File History")
        map("<leader>gg", function()
          Snacks.lazygit()
        end, "Lazygit")
        map("<leader>gl", function()
          Snacks.lazygit.log()
        end, "Lazygit Log (cwd)")

        -- Notifications
        map("<leader>nn", function()
          Snacks.notifier.show_history()
        end, "Notification history")
        map("<leader>nh", function()
          Snacks.notifier.hide()
        end, "Notification Dismiss all")
      end,
    })
  end,
}
