vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.fileencoding = "utf-8"
vim.opt.hlsearch = false
vim.opt.showmatch = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.termguicolors = true
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.opt.undodir = os.getenv "HOME" .. "/.cache/vim/undodir"
vim.opt.undofile = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.gp = "git grep -n"
vim.g.netrw_banner = 0
vim.g.mapleader = " "
vim.cmd [[
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
colorscheme murphy
set wildmenu
set wildmode=longest:list,full
set termguicolors
]]
