vim.g.mapleader = ","

vim.cmd([[
  let $LANG = 'en_US.UTF-8'
  let $LC_ALL = 'en_US.UTF-8'
]])

vim.cmd("language messages en_US.utf-8")
vim.cmd("filetype plugin on")

vim.o.guicursor = ""
vim.o.cursorline = false
vim.o.number = true
vim.o.relativenumber = false
vim.o.laststatus = 0

-- disable providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.python3_host_prog = "/opt/homebrew/bin/python3.11"

-- Smoothscroll
vim.o.smoothscroll = true
vim.o.wrap = false
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Basics
vim.o.ttyfast = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.showmode = true
vim.o.cmdheight = 1

vim.opt.shortmess:remove("W")

-- List
vim.o.list = true
vim.o.listchars = "tab:  ,trail:･"
vim.o.clipboard = "unnamedplus"

vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
    mdx = "markdown.mdx",
  },
})

-- Terminals configuration for colorscheme
vim.o.termguicolors = true
vim.o.background = "dark"

-- Diagnostics configuration
vim.diagnostic.config({
  virtual_text = false,
})
