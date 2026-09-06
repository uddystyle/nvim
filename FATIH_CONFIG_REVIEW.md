# fatih/dotfiles Neovim 設定の確認

確認日: 2026-09-06
正本: `https://github.com/fatih/dotfiles`
確認した commit: `5c72b56`

## 構成

- Neovim 設定は repository root の単一 `init.lua`。Makefile の sync target がこれを `~/.config/nvim/init.lua` に symlink する。
  - 出典: `init.lua`, `AGENTS.md`
- Neovim 0.12 の native package manager `vim.pack.add()` を使い、lazy.nvim / packer.nvim は使わない。
  - 出典: `AGENTS.md`, `init.lua`
- 起動直後に `vim.loader.enable()` を呼び Lua module cache を有効化する。
  - 出典: `init.lua`
- lockfile はない。`vim.pack` が package の install/update state を Neovim の data directory で扱う。
  - 出典: `init.lua`（`vim.pack.add` のみで lockfile 設定なし）

## plugin と機能の選択

- explorer は nvim-tree、picker は fzf-lua + frecency、Git 操作は git.nvim、statusline は lualine。
  - 出典: `init.lua` の `vim.pack.add` と各 `require(...).setup()`
- 補完は nvim-cmp + LuaSnip。現在の設定が採用する blink.cmp とは異なる系統。
  - 出典: `init.lua` の `cmp.setup()`
- LSP は Neovim 0.12 APIで `gopls` と `lua_ls` を直接設定・有効化する。Mason は使わず、各 server は OS / language toolchain で導入する前提。
  - 出典: `init.lua` の `vim.lsp.config()` / `vim.lsp.enable()`
- Treesitter は `nvim-treesitter.configs` を使わず、`FileType` autocmd から `vim.treesitter.start()` を呼ぶ。100KB超のファイルを skip する。
  - 出典: `init.lua` の `treesitter_start` augroup

## 実装上の特徴

- `PackChanged` autocmd で nvim-treesitter の install/update 後に `:TSUpdate` を実行する。
- `LspAttach` で buffer-local な LSP keymap を設定する。
- Go の保存時は organize imports を実行後、LSP format する。
- diagnostics は virtual text、sign、underline をすべて無効化する。
- Ghostty 向けに OSC 7 で cwd を通知する。
  - 出典: いずれも `init.lua`

## この設定との関係

- 共通点は Neovim 0.12 API、fzf-lua、LspAttach による keymap、lockfileをrepositoryに置かない方針。
- 相違点は管理方式と対象範囲。fatih 設定は単一ファイル・native `vim.pack`・Go/Lua中心であり、この設定は `lua/plugins/` に分割した lazy.nvim・Mason・多言語 LSP 構成である。
- `vim.loader.enable()`、大きな file の Treesitter skip、`PackChanged` 後の `TSUpdate` は参考にできる。nvim-cmp、nvim-tree、手動 LSP 導入への置換は現在の設定と役割が重複するため、そのまま採用しない。
