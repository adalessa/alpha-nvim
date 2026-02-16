vim.keymap.set({ "n" }, "<leader>mm", function()
  if vim.fn.filereadable("Makefile") == 0 then
    vim.notify("No Makefile found", vim.log.levels.WARN, {})
    return
  end

  local items =
    vim.fn.systemlist("make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\\/\t=]*:([^=]|$)/ {split($1,A,/ /);print A[1]}'")

  if vim.tbl_isempty(items) then
    vim.notify("No make items", vim.log.levels.WARN, {})
    return
  end

  Snacks.picker.pick({
    title = "Make Commands",
    items = vim
      .iter(vim.fn.uniq(items))
      :map(function(item)
        return {
          text = item,
          value = item,
        }
      end)
      :totable(),
    layout = "vscode",
    format = function(item, _)
      return { { item.text } }
    end,
    confirm = function(picker, item)
      picker:close()
      if item then
        vim.cmd(string.format("Dispatch make %s", item.value))
      end
    end,
  })
end, {})
