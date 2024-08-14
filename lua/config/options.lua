-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = ","

vim.cmd([[
  let $LANG = 'en_US.UTF-8'
  let $LC_ALL = 'en_US.UTF-8'
]])

vim.cmd("language messages en_US.utf-8")

-- disable providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = "/opt/homebrew/bin/python3.11"

-- Smoothscroll
vim.o.smoothscroll = true

-- List
vim.o.list = true
vim.o.listchars = "tab:» ,trail:･"

-- Terminals configuration for colorscheme
vim.o.termguicolors = true
vim.o.background = "dark"
