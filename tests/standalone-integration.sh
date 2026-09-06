#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT
printf 'local value = 1\n' > "$tmpdir/sample.lua"
printf 'const value: number = 1\n' > "$tmpdir/sample.ts"
printf 'fn main() {}\n' > "$tmpdir/sample.rs"
printf 'package main\nfunc main() {}\n' > "$tmpdir/sample.go"
printf 'local value={answer=42}\n' > "$tmpdir/unformatted.lua"

NVIM_STANDALONE_SKIP_MASON_INSTALL=1 "$repo_root/scripts/nvim-standalone" --headless "$tmpdir/sample.lua" \
  '+Lazy load fzf-lua' \
  '+Lazy load blink.cmp' \
  '+Lazy load neo-tree.nvim' \
  '+sleep 3000m' \
  '+lua assert(pcall(require, "fidget"), "Fidget did not load with LSP"); local opts=require("fzf-lua.config").setup_opts.files; assert(opts.hidden and opts.no_ignore, "file picker must include hidden and ignored files"); local blink=require("blink.cmp.config"); assert(vim.tbl_contains(blink.sources.default, "lsp"), "Blink LSP source is missing"); local clients={}; for _, client in ipairs(vim.lsp.get_clients()) do clients[client.name]=true end; assert(clients.lua_ls, "Lua LSP did not attach"); assert(not clients.stylua, "Stylua must be used only as a formatter")' \
  '+qa'

NVIM_STANDALONE_SKIP_MASON_INSTALL=1 "$repo_root/scripts/nvim-standalone" --headless "$tmpdir/sample.ts" \
  '+sleep 10000m' \
  '+lua local clients={}; for _, client in ipairs(vim.lsp.get_clients()) do clients[client.name]=true end; assert(clients.vtsls, "VTSLS did not attach"); assert(vim.fn.maparg(",co", "n", false, true).callback, "Organize Imports keymap is missing"); assert(vim.fn.maparg(",cR", "n", false, true).callback, "Rename file keymap is missing")' \
  '+qa'

NVIM_STANDALONE_SKIP_MASON_INSTALL=1 "$repo_root/scripts/nvim-standalone" --headless "$tmpdir/sample.rs" \
  '+sleep 10000m' \
  '+lua local clients={}; for _, client in ipairs(vim.lsp.get_clients()) do clients[client.name]=true end; assert(clients.rust_analyzer, "Rust analyzer did not attach"); assert(vim.fn.maparg(",fo", "n", false, true).callback, "Rust format keymap is missing"); assert(vim.fn.maparg(",re", "n", false, true).callback, "Rust rename keymap is missing")' \
  '+qa'

NVIM_STANDALONE_SKIP_MASON_INSTALL=1 "$repo_root/scripts/nvim-standalone" --headless "$tmpdir/sample.go" \
  '+sleep 10000m' \
  '+lua local count=0; for _, client in ipairs(vim.lsp.get_clients()) do if client.name == "gopls" then count=count+1 end end; assert(count == 1, "expected one gopls client, got " .. count)' \
  '+qa'

NVIM_STANDALONE_SKIP_MASON_INSTALL=1 "$repo_root/scripts/nvim-standalone" --headless "$tmpdir/unformatted.lua" '+write' '+qa' >/dev/null 2>&1
[[ $(<"$tmpdir/unformatted.lua") == 'local value = { answer = 42 }' ]]

NVIM_STANDALONE_SKIP_MASON_INSTALL=1 "$repo_root/scripts/nvim-standalone" --headless \
  '+colorscheme kanagawa' \
  '+lua assert(vim.g.colors_name == "kanagawa", "custom colorscheme did not load")' \
  '+qa'
