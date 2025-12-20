return {
  {
    "saghen/blink.compat",
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = "*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        name = "luasnip",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      {
        "echasnovski/mini.icons",
        opts = {
          lsp = {
            copilot = { glyph = "", hl = "MiniIconsRed" },
          },
        },
      },
    },

    -- use a release tag to download pre-built binaries
    version = "*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
        preset = "default",
        ["<S-Tab>"] = {},
        ["<Tab>"] = {},
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-j>"] = { "snippet_backward", "fallback" },
      },
      signature = {
        enabled = true,
        trigger = {
          enabled = false,
        },
      },

      snippets = {
        preset = "luasnip",
      },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = function()
          local sources = { "lsp", "path", "snippets" }
          if
            require("nixCatsUtils").enableForCategory("laravel")
            and vim.bo.filetype == "php"
            and vim.fn.filereadable("artisan") == 1
          then
            table.insert(sources, "laravel")
          end

          if require("nixCatsUtils").enableForCategory("copilot") then
            table.insert(sources, "copilot")
          end

          return sources
        end,
        per_filetype = {
          sql = { "dadbod" },
          markdown = { "buffer", "path", "snippets" },
        },
        providers = {
          laravel = {
            name = "laravel",
            module = "blink.compat.source",
            score_offset = 95, -- show at a higher priority than lsp
          },
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
            transform_items = function(_, items)
              local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = "Copilot"
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
          },
        },
      },
      completion = {
        menu = {
          auto_show = function(ctx)
            if vim.tbl_contains({ "markdown" }, vim.bo.filetype) then
              return false
            end

            return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
          end,
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              kind = {
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
      },
    },
    opts_extend = { "sources.default" },
    config = function(_, opts)
      if require("nixCatsUtils").isNixCats then
        opts.fuzzy = { prebuilt_binaries = { download = false } }
      end

      require("blink-cmp").setup(opts)
    end,
  },
}
