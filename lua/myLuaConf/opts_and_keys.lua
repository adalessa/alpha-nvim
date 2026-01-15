vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Set highlight on search
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.opt.inccommand = "split"

vim.o.splitbelow = true
vim.o.splitright = true

vim.opt.scrolloff = 8

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"

vim.o.mouse = ""

vim.o.expandtab = true
vim.opt.cpoptions:append("I")

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.breakindent = true

vim.o.undofile = true
vim.o.clipboard = "unnamedplus"

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.completeopt = "menuone,preview,noselect"

vim.o.termguicolors = true

vim.o.laststatus = 3
vim.o.conceallevel = 1

-- Disable php by filetype mappings
vim.g.no_php_maps = 1

vim.api.nvim_create_autocmd("FileType", {
  desc = "remove formatoptions",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 0
