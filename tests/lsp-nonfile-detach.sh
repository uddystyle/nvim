#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT
printf 'local value = 1\n' > "$tmpdir/sample.lua"

NVIM_STANDALONE_SKIP_MASON_INSTALL=1 "$repo_root/scripts/nvim-standalone" --headless "$tmpdir/sample.lua" \
  '+sleep 3000m' \
  '+lua local client=vim.lsp.get_clients({bufnr=0})[1]; assert(client and client.name == "lua_ls", "Lua LSP did not attach"); vim.api.nvim_buf_set_name(0, "diffview://comparison.lua"); vim.api.nvim_exec_autocmds("LspAttach", { buffer=0, data={ client_id=client.id } }); assert(vim.wait(1000, function() return #vim.lsp.get_clients({bufnr=0}) == 0 end), "LSP remained attached to a diffview buffer")' \
  '+qa'
