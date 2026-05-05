local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 10
opt.sidescrolloff = 10
opt.wrap = false
opt.linebreak = true

opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true
opt.autoindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.splitright = true
opt.splitbelow = true

opt.undofile = true
opt.swapfile = false
opt.backup = false

opt.termguicolors = true
opt.background = "dark"
opt.showmode = false
opt.cmdheight = 1
opt.pumheight = 10
opt.updatetime = 250
opt.timeoutlen = 400

opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.fillchars = {
  eob = " ",
  vert = "│",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
}

if vim.fn.has("win32") == 1 then
  local shell = vim.fn.executable("pwsh") == 1 and "pwsh.exe" or "powershell.exe"
  opt.shell = shell
  opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  opt.shellquote = ""
  opt.shellxquote = ""
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "
