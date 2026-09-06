#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

write_unformatted() {
  printf 'local value={answer=42}\n' > "$1"
}

run_nvim() {
  NVIM_STANDALONE_SKIP_MASON_INSTALL=1 "$repo_root/scripts/nvim-standalone" --headless "$@"
}

assert_formatted() {
  [[ $(<"$1") == 'local value = { answer = 42 }' ]]
}

assert_unformatted() {
  [[ $(<"$1") == 'local value={answer=42}' ]]
}

file="$tmpdir/global-disabled.lua"
write_unformatted "$file"
run_nvim "$file" '+ConformDisable' '+write' '+qa' >/dev/null 2>&1
assert_unformatted "$file"

file="$tmpdir/global-enabled.lua"
write_unformatted "$file"
run_nvim "$file" '+ConformDisable' '+ConformEnable' '+write' '+qa' >/dev/null 2>&1
assert_formatted "$file"

file="$tmpdir/buffer-disabled.lua"
write_unformatted "$file"
run_nvim "$file" '+ConformDisable!' '+write' '+qa' >/dev/null 2>&1
assert_unformatted "$file"

file="$tmpdir/buffer-enabled.lua"
write_unformatted "$file"
run_nvim "$file" '+ConformDisable!' '+ConformEnable' '+write' '+qa' >/dev/null 2>&1
assert_formatted "$file"
