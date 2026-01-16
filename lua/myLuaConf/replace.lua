-- function to replace
vim.cmd([[
    function! AlphaReplace(type)
      let val = getreg('+')
      let commands = #{
        \ line: "'[V']",
        \ char: "`[v`]",
        \ block: "`[\<C-V>`]",
        \ }[a:type]
      execute 'normal! ' .. commands .. 'p'
      call setreg('+', val)
    endfunction
]])

-- Define a new function to paste from the clipboard and restore the clipboard content
local function paste_and_restore_clipboard()
  local val = vim.fn.getreg("+")
  vim.api.nvim_command("normal! p")
  vim.fn.setreg("+", val)
end

-- Keymap for replace action
vim.keymap.set({ "n" }, "<leader>r", ":set opfunc=AlphaReplace<CR>g@", { desc = "allow replace action", silent = true })

-- Keymap for pasting and restoring clipboard
vim.keymap.set({ "n", "v" }, "<leader>p", paste_and_restore_clipboard, { desc = "paste and restore clipboard" })
