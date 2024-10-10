-- For Go lang
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  command = "setlocal tabstop=4 shiftwidth=4 noexpandtab",
})
