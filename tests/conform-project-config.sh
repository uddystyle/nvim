#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

mkdir -p "$tmpdir/no-config" "$tmpdir/with-config"
printf 'const value={answer:42}\n' > "$tmpdir/no-config/sample.ts"
printf 'const value={answer:42}\n' > "$tmpdir/with-config/sample.ts"
printf '{}\n' > "$tmpdir/with-config/.prettierrc"

check_prettier() {
  local file=$1 expected=$2
  NVIM_STANDALONE_SKIP_MASON_INSTALL=1 "$repo_root/scripts/nvim-standalone" --headless "$file" \
    '+Lazy load conform.nvim' \
    "+lua local info=require(\"conform\").get_formatter_info(\"prettier\", 0); assert(info.available == $expected, \"unexpected prettier availability: \" .. tostring(info.available))" \
    '+qa'
}

check_prettier "$tmpdir/no-config/sample.ts" false
check_prettier "$tmpdir/with-config/sample.ts" true
