#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT
printf 'local value = 1\n' > "$tmpdir/sample.lua"

NVIM_STANDALONE_SKIP_MASON_INSTALL=1 "$repo_root/scripts/nvim-standalone" --headless "$tmpdir/sample.lua" \
  '+sleep 3000m' \
  '+lua for _, lhs in ipairs({ "gd", "gD", "gr", "gi", "K", ",ca", ",rn" }) do local map=vim.fn.maparg(lhs, "n", false, true); assert(map.lhs and map.lhs ~= "", "missing LSP keymap: " .. lhs) end; for _, lhs in ipairs({ ",ca", ",rn" }) do local map=vim.fn.maparg(lhs, "n", false, true); assert(map.callback and map.buffer == 1, "missing buffer-local LSP keymap: " .. lhs) end' \
  '+qa'
