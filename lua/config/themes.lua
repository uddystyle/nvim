local M = {}

local plugins = {
  ["catppuccin-macchiato"] = "catppuccin",
  ["gruvbox"] = "gruvbox",
  ["everforest"] = "everforest",
  ["onedark"] = "onedark.nvim",
  ["kanagawa"] = "kanagawa.nvim",
  ["kintsugi"] = "kintsugi-nvim",
}

function M.names()
  local names = vim.tbl_keys(plugins)
  table.sort(names)
  return names
end

function M.apply(name)
  local plugin = plugins[name]
  if not plugin then
    error("Unknown theme: " .. name)
  end
  require("lazy").load({ plugins = { plugin } })
  vim.cmd.colorscheme(name)
end

return M
