require("custom.graphql.ts_query")
local query = vim.treesitter.query.get("yaml", "GraphQL_endpoints")
local get_node_text = vim.treesitter.get_node_text

local snacks = require("snacks").picker

local M = {}

function M.pick(opts)
  opts = opts or {}
  if not opts.schemas_path or vim.tbl_isempty(opts.schemas_path) then
    vim.notify("No schemas path provided", vim.log.levels.ERROR)
  end

  snacks.pick({
    title = "Graphql Mutation & Queries",
    items = vim
      .iter(opts.schemas_path)
      :map(function(schema)
        local uri = vim.uri_from_fname(schema)
        local bufnr = vim.uri_to_bufnr(uri)

        vim.fn.bufload(bufnr)

        return {
          schema = schema,
          uri = uri,
          bufnr = bufnr,
        }
      end)
      :map(function(item)
        local elements = {}

        local parsers = require("nvim-treesitter.parsers")
        local parser = parsers.get_parser(item.bufnr)
        local tree = parser:parse()[1]

        if not query then
          vim.notify("No query found", vim.log.levels.ERROR)
          return
        end

        for id, node in query:iter_captures(tree:root(), item.bufnr) do
          if query.captures[id] == "mutation" then
            table.insert(elements, {
              value = get_node_text(node, item.bufnr),
              lnum = node:start() + 1,
              buffer = item.bufnr,
            })
          elseif query.captures[id] == "resolver" then
            elements[#elements].resolver = get_node_text(node, item.bufnr)
          end
        end

        return vim
          .iter(elements)
          :map(function(element)
            local type = "mutation"
            local args = string.match(element.resolver, "'@=mutation%((.+)%)'")
            if args == nil then
              args = string.match(element.resolver, "'@=query%((.+)%)'")
              type = "query"
            end
            if args == nil then
              return
            end

            local args_tbl = vim.split(args, ", ")
            local fqn = string.match(args_tbl[1], '"(.+)"')
            fqn = string.gsub(fqn, "\\\\", "\\")

            local search = vim.split(fqn, "::")
            local fqn_class = search[1]
            local method = search[2]

            return {
              file = item.schema,
              basename = vim.fs.basename(item.schema),
              type = type,
              bufnr = item.bufnr,
              uri = item.uri,
              name = element.value,
              line = element.lnum,
              resolver = element.resolver,
              fqn_class = fqn_class,
              method = method,
            }
          end)
          :totable()
      end)
      :flatten(1)
      :map(function(item)
        return {
          value = item,
          file = item.file,
          pos = { item.line, 0 },
          text = vim.iter({ item.type, item.name, item.basename }):join(" "),
        }
      end)
      :totable(),
    format = function(item)
      return {
        { string.format("[%s]", item.value.type), "@string" },
        { " ", "@string" },
        { item.value.name, "@keyword" },
        { " ", "@string" },
        { string.format("<%s>", item.value.basename), "@comment" },
      }
    end,
    actions = {
      open_resolver = function(picker, item)
        picker:close()
        if item then
          vim.system(
            {
              "php",
              "-r",
              'require "vendor/autoload.php";$c=$argv[1];$m=$argv[2];if(!class_exists($c)){exit(2);}$r=new ReflectionClass($c);$f=$r->getFileName();if(!$r->hasMethod($m)){echo $f."\\n";exit(1);}echo $f.":".$r->getMethod($m)->getStartLine()."\\n";',
              item.value.fqn_class,
              item.value.method,
            },
            { text = true },
            vim.schedule_wrap(function(obj)
              if obj.code == 2 then
                vim.notify("Class not found: " .. item.value.fqn_class, vim.log.levels.ERROR)
                return
              end
              if obj.code == 1 then
                -- method not found just open
                vim.cmd.edit(obj.stdout)
                return
              end

              -- replace : by " +"
              local location = vim.split(obj.stdout, ":")
              local file = location[1]
              local line = tonumber(location[2]) or 1
              vim.cmd(string.format("edit +%d %s", line, file))
            end)
          )
        end
      end,
      search_tests = function(picker, item)
        picker:close()
        if item then
          local cwd = vim.uv.cwd()
          Snacks.picker.grep({ search = item.value.name, pattern = ".feature", dirs = { cwd .. "/tests/Functional/features/" } })
        end
      end,
    },
    win = {
      input = {
        keys = {
          ["<c-o>"] = { "open_resolver", mode = { "n", "i" }, desc = "Open Resolver" },
          ["<c-t>"] = { "search_tests", mode = { "n", "i" }, desc = "Search Test for the element" },
        },
      },
    },
  })
end

return M
