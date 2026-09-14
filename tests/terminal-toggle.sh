#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
printf 'original\n' >"$tmp"

nvim --headless "$tmp" \
  '+lua local original = vim.api.nvim_get_current_buf(); local toggle = vim.fn.maparg(",tt", "n", false, true).callback; assert(type(toggle) == "function"); assert(type(vim.fn.maparg(",tt", "t", false, true).callback) == "function"); toggle(); assert(vim.bo.buftype == "terminal"); toggle(); assert(vim.api.nvim_get_current_buf() == original)' \
  '+qa!'
