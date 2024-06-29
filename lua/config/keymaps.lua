-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Increment/Declement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwords
keymap.set("n", "dw", "vb_d")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")

-- diagnostics
keymap.set("n", "C-j", function()
  vim.diagnostic.goto_next()
end, opts)

-- Move
keymap.set("n", "<C-h>", "^", opts)
keymap.set("n", "<C-l>", "$", opts)

-- New lines
keymap.set("n", "O", [[:lua vim.fn.append(vim.fn.line('.'), '')<CR>j]], opts)

-- Fast saving
keymap.set("n", "<Leader>w", ":write!<CR>", opts)
keymap.set("n", "<Leader>q", ":q!<CR>", opts)

-- Move Right
keymap.set("i", "<C-f>", "<Right>", opts)

-- Buffer line
keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", opts)
keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", opts)

-- Delete buffer
keymap.set("n", "<leader>bd", ":bd!<CR>", opts)

-- Toggle neotree
keymap.set("n", "<leader>n", ":Neotree toggle left<CR>", opts)

-- Create terminal buffer
keymap.set("n", "<leader>tt", ":terminal<CR>", opts)
