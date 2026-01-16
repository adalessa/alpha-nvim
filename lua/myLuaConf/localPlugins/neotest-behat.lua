local lib = require("neotest.lib")
local tree = require("neotest.types.tree")
local types = require("neotest.types")

---@class BehatAdapter : neotest.Adapter
local behatAdapter = { name = "neotest-behat" }

---Find the project root directory given a current directory to work from.
---Should no root be found, the adapter can still be used in a non-project context if a test file matches.
---@async
---@param dir string @Directory to treat as cwd
---@return string | nil @Absolute root dir of test suite
function behatAdapter.root(dir)
  local result = nil
  for _, root_file in ipairs({ "behat.yml.dist", ".gitignore" }) do
    result = lib.files.match_root_pattern(root_file)(dir)
    if result then
      break
    end
  end

  return result
end

---@async
---@param file_path string
---@return boolean
function behatAdapter.is_test_file(file_path)
  local dir = vim.uv.cwd()
  return vim.endswith(file_path, ".feature") and (not vim.startswith(file_path, dir .. "/vendor"))
end

---Given a file path, parse all the tests within it.
---@async
---@param path string Absolute file path
---@return neotest.Tree | nil
function behatAdapter.discover_positions(path)
  if not behatAdapter.is_test_file(path) then
    return nil
  end

  local lines = require("neotest.lib").files.read_lines(path)
  local scenarios = {}
  local feature = vim.trim(lines[1]:gsub("Feature:", ""))
  for number, line in ipairs(lines) do
    local name = vim.trim(line:gsub("Scenario:", ""):gsub("Scenario Outline:", ""))
    if vim.startswith(line, "  Scenario") then
      table.insert(scenarios, {
        id = feature .. "::" .. name,
        type = "test",
        name = name,
        path = path,
        range = { number - 1, 0, number, 0 },
      })
    end
  end

  table.insert(scenarios, 1, {
    id = path,
    type = "file",
    name = feature,
    path = path,
    range = { 0, 0, #lines, 0 },
  })

  return tree.from_list(scenarios, function(pos)
    return pos.id
  end)
end

---@param args neotest.RunArgs
---@return nil | neotest.RunSpec | neotest.RunSpec[]
function behatAdapter.build_spec(args)
  local data = args.tree:data()
  local cwd = vim.uv.cwd()
  local path = data.path:gsub(cwd:gsub("%-", "%%-") .. "/", "")

  return {
    command = {
      "make",
      "exec-behat",
      "test=" .. (data.type == "test" and string.format("%s:%s", path, data.range[1] + 1) or path),
    },
  }
end

---@async
---@param spec neotest.RunSpec
---@param result neotest.StrategyResult
---@param tree neotest.Tree
---@return table<string, neotest.Result>
function behatAdapter.results(spec, result, tree)
  if tree:data().type == "test" then
    return {
      [tree:data().id] = {
        status = result.code == 0 and types.ResultStatus.passed or types.ResultStatus.failed,
        output = result.output,
      },
    }
  end

  if tree:data().type == "file" then
    local content = require("neotest.lib").files.read(result.output)
    local pattern = "\n%s+tests/.-%.feature:%d+"

    local failed = {}
    for match in content:gmatch(pattern) do
      table.insert(failed, tonumber(vim.split(match, ":")[2]))
    end

    local results = {}

    for _, pos in ipairs(tree:children()) do
      local status = types.ResultStatus.passed
      if vim.tbl_contains(failed, pos:data().range[1] + 1) then
        status = types.ResultStatus.failed
      end

      results[pos:data().id] = {
        status = status,
        output = result.output,
      }
    end

    return results
  end

  if tree:data().type == "dir" then
    local content = require("neotest.lib").files.read(result.output)
    local pattern = "\n%s+tests/.-%.feature:%d+"

    local failed = {}
    for match in content:gmatch(pattern) do
      local trimmed_match = match:match("^%s*(.-)%s*$")
      local failed_parts = vim.split(trimmed_match, ":")
      if failed[failed_parts[1]] == nil then
        failed[failed_parts[1]] = {}
      end

      table.insert(failed[failed_parts[1]], tonumber(failed_parts[2]))
    end

    local results = {}

    local check_per_test = function(pos)
      local status = types.ResultStatus.passed

      local file_errors = {}
      for file, errors in pairs(failed) do
        if vim.endswith(pos:data().path, file) then
          file_errors = errors
          break
        end
      end

      if vim.tbl_contains(file_errors, pos:data().range[1] + 1) then
        status = types.ResultStatus.failed
      end

      results[pos:data().id] = {
        status = status,
        output = result.output,
      }
    end

    local check_per_file = function(pos)
      for _, child in ipairs(pos:children()) do
        check_per_test(child)
      end
    end

    local check_per_dir = nil

    check_per_dir = function(pos)
      for _, child in ipairs(pos:children()) do
        if child:data().type == "file" then
          check_per_file(child)
        end
        if child:data().type == "dir" then
          check_per_dir(child)
        end
      end
    end

    check_per_dir(tree)

    return results
  end

  return {}
end

return behatAdapter
