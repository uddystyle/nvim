local M = {}

local plugins = {
  ["tokyonight"] = "tokyonight.nvim",
  ["gruvbox"] = "gruvbox",
  ["gruvbox-minimal"] = "gruvbox-minimal.nvim",
  ["everforest"] = "everforest",
  ["miasma"] = "miasma.nvim",
  ["onedark"] = "onedark.nvim",
  ["kanagawa"] = "kanagawa.nvim",
  ["no-clown-fiesta"] = "no-clown-fiesta.nvim",
  ["kintsugi"] = "kintsugi-nvim",
}

function M.names()
  local names = vim.tbl_keys(plugins)
  table.sort(names)
  return names
end

function M.apply(name)
  local plugin = plugins[name]
  if not plugin then error("Unknown theme: " .. name) end
  require("lazy").load({ plugins = { plugin } })
  vim.cmd.colorscheme(name)
end

return M
