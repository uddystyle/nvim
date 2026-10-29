#!/usr/bin/env bash
set -euo pipefail

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT
printf '%s\n' '# Tree-sitter Markdown regression' '' '```lua' 'local value = 1' '```' >"$tmpdir/sample.md"

set +e
output=$(nvim --headless "$tmpdir/sample.md" '+lua assert(pcall(vim.treesitter.get_parser, 0), "Markdown parser is unavailable")' '+sleep 1000m' '+qa' 2>&1)
status=$?
set -e
if [ "$status" -ne 0 ] || grep -Fq "attempt to call method 'range'" <<<"$output"; then
	printf '%s\n' "$output" >&2
	exit 1
fi
