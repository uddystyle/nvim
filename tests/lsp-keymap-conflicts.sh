#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT
printf 'local value = 1\n' > "$tmpdir/sample.lua"

NVIM_STANDALONE_SKIP_MASON_INSTALL=1 "$repo_root/scripts/nvim-standalone" \
  --cmd 'lua vim.keymap.set("n", ",ca", function() end, { desc = "Existing map" })' \
  --headless "$tmpdir/sample.lua" \
  '+sleep 3000m' \
  '+lua local map=vim.fn.maparg(",ca", "n", false, true); assert(map.desc == "Existing map" and map.buffer == 0, "LSP keymap overwrote an existing map")' \
  '+qa'
