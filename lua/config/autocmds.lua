-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Don't auto commenting new lines
local autocmd = vim.api.nvim_create_autocmd
autocmd("BufEnter", { pattern = "*", command = "set fo-=c fo-=r fo-=o" })

-- don't show number
vim.api.nvim_create_autocmd("TermOpen", {
  command = [[setlocal nonumber norelativenumber]],
})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc" },
  callback = function()
    vim.wo.spell = false
    vim.wo.conceallevel = 0
  end,
})

-- automatically switch to insert mode when entering a Term buffer
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
  group = vim.api.nvim_create_augroup("openTermInsert", {}),
  callback = function(args)
    -- we don't use vim.startswith() and look for test:// because of vim-test
    -- vim-test starts tests in a terminal, which we want to keep in normal mode
    if vim.endswith(vim.api.nvim_buf_get_name(args.buf), "zsh") then
      vim.cmd("startinsert")
    end
  end,
})

-- Display diagnostics when cursor hold the underline
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  pattern = "*",
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "always",
      prefix = " ",
      scope = "cursor",
    }
    vim.diagnostic.open_float(nil, opts)
  end,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
})
