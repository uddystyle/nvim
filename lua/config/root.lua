local M = {}

local markers = { ".git", "lua", "package.json", "Cargo.toml", "Gemfile", "Makefile" }

function M.get()
  return vim.fs.root(0, markers) or vim.uv.cwd()
end

return M
