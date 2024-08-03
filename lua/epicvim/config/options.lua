if vim.fn.isdirectory('/home/app/.venvs/app/bin/python') ~= 0 then
  vim.g.python3_host_prog = "/home/app/.venvs/app/bin/python"
end
vim.o.spelllang = "en_us"
vim.o.spell = true

-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = " "

vim.g.autoformat = true
vim.g.autopairs = true

-- Tab / Indent
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.wrap = false

-- Search
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true

-- Appearance
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
-- vim.g.nightflyTerminalColors = false
vim.g.nightflyTransparent = true
vim.o.colorcolumn = "100"
vim.o.signcolumn = "yes"
vim.o.cmdheight = 1
vim.o.scrolloff = 10
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.cursorline = true
vim.o.background = "dark"

-- Behaviour
vim.o.hidden = true
vim.o.errorbells = false
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.expand("~/.local/share/nvim/undodir")
vim.o.undofile = true
vim.o.backspace = "indent,eol,start"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.autochdir = false
vim.o.modifiable = true
vim.o.guicursor =
"n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
vim.o.encoding = "UTF-8"
vim.opt.iskeyword:append("-")
vim.opt.mouse:append("a")
