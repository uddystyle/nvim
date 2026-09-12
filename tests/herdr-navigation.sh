#!/usr/bin/env bash
set -euo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

cat >"$tmp/herdr" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$HERDR_CALL_LOG"
SH
chmod +x "$tmp/herdr"

HERDR_PANE_ID=w-test:p1 \
HERDR_BIN_PATH="$tmp/herdr" \
HERDR_CALL_LOG="$tmp/calls" \
nvim --headless \
  '+lua for _, key in ipairs({"<C-H>", "<C-J>", "<C-K>", "<C-L>"}) do local mapping = vim.fn.maparg(key, "n", false, true); assert(type(mapping.callback) == "function", key .. " navigation mapping is missing") end' \
  '+lua vim.fn.maparg("<C-H>", "n", false, true).callback()' \
  '+qa'

grep -Fxq 'pane focus --direction left --pane w-test:p1' "$tmp/calls"
