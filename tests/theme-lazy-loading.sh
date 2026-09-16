#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

"$repo_root/scripts/nvim-standalone" --headless \
  '+lua local p=require("lazy.core.config").plugins; for _, name in ipairs({ "catppuccin", "tokyonight.nvim", "gruvbox", "kanagawa.nvim", "kintsugi-nvim" }) do assert(not p[name]._.loaded, "theme eagerly loaded: " .. name) end; assert(vim.fn.exists(":Theme") == 2, "Theme command is missing")' \
  '+Theme everforest' \
  '+lua local normal=vim.api.nvim_get_hl(0, { name = "Normal", link = false }); assert(vim.g.colors_name == "everforest", "Theme did not apply everforest"); assert(vim.g.everforest_background == "hard", "Everforest is not using Dark Hard"); assert(normal.bg == nil, "Neovim background is not transparent"); assert(normal.fg == 0xd3c6aa, "Everforest foreground was lost"); assert(require("lazy.core.config").plugins.everforest._.loaded, "Theme did not load everforest")' \
  '+Theme kanagawa' \
  '+lua assert(vim.g.colors_name == "kanagawa", "Theme did not apply kanagawa"); assert(require("lazy.core.config").plugins["kanagawa.nvim"]._.loaded, "Theme did not load kanagawa")' \
  '+qa'
