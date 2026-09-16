#!/usr/bin/env bash
set -euo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

cd "$repo"
nvim --headless \
  '+edit lua/config/options.lua' \
  '+set filetype=' \
  '+lua local plugin = require("lazy.core.config").plugins["fzf-lua"]; local opts = require("lazy.core.plugin").values(plugin, "opts", false); assert(opts.fzf_opts["--gutter"] == " "); opts.actions.files.enter({ "lua/config/options.lua" }, { cwd = vim.uv.cwd(), _cwd = vim.uv.cwd() }); assert(vim.bo.filetype == "lua")' \
  '+qa'
