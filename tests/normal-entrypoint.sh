#!/usr/bin/env bash
set -euo pipefail

nvim --headless \
  '+lua local p=require("lazy.core.config").plugins; assert(vim.g.standalone_config_loaded, "normal entrypoint did not load standalone"); assert(p["blink.cmp"], "normal entrypoint did not import standalone plugin specs"); assert(not p["LazyVim"], "normal entrypoint managed LazyVim"); assert(vim.fn.maparg(",ff", "n", false, true).callback, "normal entrypoint did not load standalone keymaps"); assert(not pcall(require, "lazyvim"), "normal entrypoint loaded LazyVim")' \
  '+qa'
