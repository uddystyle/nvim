#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

"$repo_root/scripts/nvim-standalone" --headless \
  '+lua local p=require("lazy.core.config").plugins; for _, name in ipairs({ "tokyonight.nvim", "gruvbox", "kanagawa.nvim", "kintsugi-nvim" }) do assert(not p[name]._.loaded, "theme eagerly loaded: " .. name) end; assert(vim.fn.exists(":Theme") == 2, "Theme command is missing")' \
  '+Theme kanagawa' \
  '+lua assert(vim.g.colors_name == "kanagawa", "Theme did not apply kanagawa"); assert(require("lazy.core.config").plugins["kanagawa.nvim"]._.loaded, "Theme did not load kanagawa")' \
  '+qa'
