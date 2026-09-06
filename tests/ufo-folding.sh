#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT
printf 'local function value()\n  return 42\nend\n' > "$tmpdir/sample.lua"

"$repo_root/scripts/nvim-standalone" --headless "$tmpdir/sample.lua" \
  '+Lazy load nvim-ufo' \
  '+lua assert(pcall(require, "ufo"), "UFO did not load"); assert(vim.o.foldlevel == 99 and vim.o.foldenable, "fold options are not configured"); assert(vim.fn.maparg("zR", "n", false, true).callback, "open-all-folds keymap is missing"); assert(vim.fn.maparg("zM", "n", false, true).callback, "close-all-folds keymap is missing")' \
  '+qa'
