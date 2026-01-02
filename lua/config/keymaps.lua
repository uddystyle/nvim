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

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")

-- Split window
keymap.set("n", "ss", "<Cmd>split<cr>", opts)
keymap.set("n", "sv", "<Cmd>vsplit<cr>", opts)

-- diagnostics
keymap.set("n", "C-j", function()
  vim.diagnostic.goto_next()
end, opts)

keymap.set("n", "<leader>cd", function()
  local _, winnr = vim.diagnostic.open_float({ border = "rounded" })
  if winnr then
    vim.api.nvim_set_current_win(winnr)
    vim.api.nvim_set_option_value("winhighlight", "Normal:NormalFloat,FloatBorder:FloatBorder", { win = winnr })
  end
end, { noremap = true, silent = true, desc = "Line Diagnostics (with focus)" })

-- Move
keymap.set("n", "<C-h>", "^", opts)
keymap.set("n", "<C-l>", "$", opts)

keymap.set("v", "<C-h>", "^", opts)
keymap.set("v", "<C-l>", "$", opts)

-- New lines
keymap.set("n", "O", [[:lua vim.fn.append(vim.fn.line('.'), '')<CR>j]], opts)

-- Fast saving
-- keymap.set("n", "<leader>w", "<Cmd>write<CR>", { noremap = true, silent = true, desc = "Save the file" })

-- Move Right
keymap.set("i", "<C-f>", "<Right>", opts)

-- Buffer line
keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", opts)
keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", opts)

-- Remap for Exit
keymap.set("i", "jj", "<Esc>", opts)

-- Reload init files
keymap.set("n", "<leader>r", ":source $MYVIMRC<CR>", opts)

-- Visually select lines, and move them up/down
vim.keymap.set("v", "J", "<Cmd>m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "K", "<Cmd>m '<-2<CR>gv=gv", opts)

-- Delete buffer
keymap.set("n", "<leader>bd", "<Cmd>bd!<CR>", { noremap = true, silent = true, desc = "Delete the buffer" })

-- Close terminal window, even if we are in insert mode
keymap.set("t", "<leader>q", "<C-\\><C-n><Cmd>q<CR>", opts)
keymap.set("t", "<C-[>", "<C-\\><C-n>", opts)

-- Open terminal in vertical and horizontal split
keymap.set(
  "n",
  "<leader>tv",
  "<Cmd>vnew term://zsh<CR>",
  { noremap = true, silent = true, desc = "Open a terminal in a vertical window" }
)
keymap.set(
  "n",
  "<leader>ts",
  "<Cmd>botright split | terminal zsh<CR>",
  { noremap = true, silent = true, desc = "Open a terminal in a horizontal window" }
)

local term_buf = nil

function ToggleTerm()
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    local term_win = vim.fn.bufwinnr(term_buf)
    if term_win ~= -1 then
      vim.api.nvim_win_close(vim.fn.win_getid(term_win), true)
    else
      vim.cmd("buffer " .. term_buf)
    end
  else
    vim.cmd("terminal zsh")
    term_buf = vim.api.nvim_get_current_buf()
  end
end

keymap.set(
  "n",
  "<leader>tt",
  "<Cmd>lua ToggleTerm()<CR>",
  { noremap = true, silent = true, desc = "Open a terminal in a new buffer" }
)
