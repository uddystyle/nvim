# dmmulroy/.dotfiles Neovim 設定の確認

確認日: 2026-09-06
正本: `https://github.com/dmmulroy/.dotfiles/tree/main/home/.config`
確認した commit: `871ce6f`（`git -C /tmp/dmmulroy-dotfiles checkout origin/main`）

## 構成

- entrypoint は `init.lua` の `require("dmmulroy")` だけ。`lua/dmmulroy/init.lua` が options、lazy bootstrap、keymaps、個別ユーティリティを順に require する。
  - 出典: `home/.config/nvim/init.lua`, `home/.config/nvim/lua/dmmulroy/init.lua`
- `lua/dmmulroy/lazy.lua` は lazy.nvim を bootstrap し、spec を `{ import = "plugins" }` のみで収集する。LazyVim は import しない。
  - 出典: `home/.config/nvim/lua/dmmulroy/lazy.lua`
- 個別プラグインは `lua/plugins/<plugin>.lua` に分割されている。AGENTS.md は 35 plugin files と記載する。
  - 出典: `home/.config/nvim/AGENTS.md`, `home/.config/nvim/lua/plugins/`
- lockfile は当該 config directory に存在しない。参照設定は plugin revision を固定していない。
  - 再現: `find /tmp/dmmulroy-dotfiles/home/.config/nvim -name 'lazy-lock.json'`

## 実装方針

- LSP は Neovim 0.11 の `vim.lsp.config()` / `vim.lsp.enable()` を使い、keymap は `LspAttach` autocmd で設定する。
  - 出典: `home/.config/nvim/lua/plugins/lsp.lua`
- 補完は blink.cmp。LuaSnip と friendly-snippets を依存にし、LSP source の score offset を高くしている。
  - 出典: `home/.config/nvim/lua/plugins/blink-cmp.lua`
- JS/TS formatter は project config の有無を条件に `oxfmt` → `biome` → `prettierd` を選ぶ。Lua は Stylua。
  - 出典: `home/.config/nvim/lua/plugins/conform.lua`
- picker は Telescope と jj extension を使う。fzf-native は CMake があるときだけ build する。
  - 出典: `home/.config/nvim/lua/plugins/telescope.lua`

## この設定との関係

- 本設定も root の `init.lua`、`lua/config/`、`lua/plugins/`、`lazy.nvim` の `{ import = "plugins" }` で構成され、LazyVim は import しない。
  - 出典: `init.lua`, `lua/config/lazy.lua`
- 本設定は lockfile を維持する。これは参照設定との意図的な差分で、再現性を優先する。
  - 出典: `lazy-lock.json`, `lua/config/lazy.lua`
- 本設定は fzf-lua、Neo-tree、現在利用中の言語・UI設定を保持する。Telescope や TypeScript 専用構成へ寄せる理由はない。
  - 出典: `lua/plugins/fzf.lua`, `lua/plugins/tools.lua`, `lua/plugins/lsp.lua`

## 結論

参照設定から採用済みの本質は「LazyVim を介さず lazy.nvim と plugin spec を直接所有する構成」である。plugin 選択・keymap・LSP/formatter 方針は利用目的が異なるため、参照設定への同一化は行わない。
