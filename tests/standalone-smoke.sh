#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmpdir=$(mktemp -d)
data_dir="${TMPDIR:-/tmp}/nvim-standalone-test-data"
trap 'rm -rf "$tmpdir"' EXIT

mkdir -p "$tmpdir/config" "$data_dir"
ln -s "$repo_root" "$tmpdir/config/nvim-standalone"
XDG_CONFIG_HOME="$tmpdir/config" \
XDG_DATA_HOME="$data_dir" \
NVIM_APPNAME=nvim-standalone \
NVIM_STANDALONE_TEST=1 \
nvim --headless \
  '+lua local p=require("lazy.core.config").plugins; assert(vim.g.standalone_config_loaded, "standalone config was not loaded"); assert(vim.g.mapleader == ",", "mapleader was not migrated"); assert(not vim.o.wrap, "line wrapping must be disabled"); assert(vim.o.foldlevel == 99 and vim.o.foldenable, "UFO fold options are not configured"); assert(vim.fn.maparg("jj", "i") == "<Esc>", "custom keymaps were not migrated"); assert(p["fzf-lua"], "fzf-lua is not managed by standalone"); assert(p["blink.cmp"], "completion is not managed by standalone"); assert(p["nvim-lspconfig"], "LSP is not managed by standalone"); assert(p["fidget.nvim"], "LSP progress UI is not managed by standalone"); assert(p["conform.nvim"], "formatting is not managed by standalone"); assert(p["gitsigns.nvim"], "Git signs are not managed by standalone"); assert(p.catppuccin, "colorscheme is not managed by standalone"); assert(p["tokyonight.nvim"] and p.gruvbox and p["gruvbox-minimal.nvim"] and p.everforest and p["miasma.nvim"] and p["onedark.nvim"] and p["kanagawa.nvim"] and p["no-clown-fiesta.nvim"] and p["kintsugi-nvim"], "custom colorschemes are not managed by standalone"); assert(p["lualine.nvim"], "statusline is not managed by standalone"); assert(p["neo-tree.nvim"], "file explorer is not managed by standalone"); assert(p["crates.nvim"], "Cargo support is not managed by standalone"); assert(p["go.nvim"], "Go support is not managed by standalone"); assert(p["render-markdown.nvim"], "Markdown rendering is not managed by standalone"); assert(p["mini.hipatterns"], "color highlighting is not managed by standalone"); assert(p["nvim-treesitter"], "Treesitter is not managed by standalone"); assert(p["nvim-ufo"], "folding UI is not managed by standalone"); assert(p.harpoon, "Harpoon is not managed by standalone"); assert(vim.fn.maparg(",ff", "n", false, true).callback, "file picker keymap was not migrated"); assert(not p["snacks.nvim"] and not p["trouble.nvim"] and not p["persistence.nvim"] and not p["mini.pairs"] and not p["nvim-lint"] and not p["nvim-dap"] and not p["noice.nvim"] and not p["markdown-preview.nvim"], "excluded plugins must not be retained"); assert(not pcall(require, "lazyvim"), "standalone config must not load LazyVim")' \
  '+qa'

test ! -e "$repo_root/lazy-lock.json"
