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

keymap.set("v", "<C-h>", "^", opts)
keymap.set("v", "<C-l>", "$", opts)

-- New lines
keymap.set("n", "O", [[:lua vim.fn.append(vim.fn.line('.'), '')<CR>j]], opts)

-- Fast saving
keymap.set("n", "<leader>w", "<Cmd>write<CR>", opts)
keymap.set("n", "<leader>q", "<Cmd>q!<CR>", opts)

-- Move Right
keymap.set("i", "<C-f>", "<Right>", opts)

-- Buffer line
keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", opts)
keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", opts)

-- Visually select lines, and move them up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Delete buffer
keymap.set("n", "<leader>bd", "<Cmd>bd!<CR>", opts)

-- Close terminal window, even if we are in insert mode
keymap.set("t", "<leader>q", "<C-\\><C-n><Cmd>q<CR>", { noremap = true, silent = true })
keymap.set("t", "<C-[>", "<C-\\><C-n>", { noremap = true, silent = true })

-- Open terminal in vertical and horizontal split
keymap.set("n", "<leader>tv", "<Cmd>vnew term://zsh<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>ts", "<Cmd>botright split | terminal zsh<CR>", { noremap = true, silent = true })

-- Open terminal in vertical and horizontal split, inside the terminal
keymap.set("t", "<leader>tv", "<C-w><Cmd>vnew term://zsh<CR>", { noremap = true, silent = true })
keymap.set("t", "<leader>ts", "<Cmd>botright split | terminal zsh<CR>", { noremap = true, silent = true })

function ToggleTerm()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf):match("term://") then
      vim.api.nvim_buf_delete(buf, { force = true })
      return
    end
  end
  vim.cmd("botright split term://zsh")
end

keymap.set("n", "<leader>tt", "<Cmd>lua ToggleTerm()<CR>", opts)
