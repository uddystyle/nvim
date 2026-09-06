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
- 本設定も lockfile を repository に含めない。lazy.nvim の lockfile は `stdpath("state")` に置く。
  - 出典: `lua/config/lazy.lua`
- 本設定は fzf-lua、Neo-tree、現在利用中の言語・UI設定を保持する。Telescope や TypeScript 専用構成へ寄せる理由はない。
  - 出典: `lua/plugins/fzf.lua`, `lua/plugins/tools.lua`, `lua/plugins/lsp.lua`

## 系統の比較

| 観点 | この設定 | dmmulroy 設定 |
|---|---|---|
| plugin manager | lazy.nvim を直接 bootstrap、root の `lua/plugins/` を import | lazy.nvim を直接 bootstrap、`lua/plugins/` を import |
| revision 管理 | repository に lockfile を置かず runtime state に置く | config directory に lockfile なし |
| plugin の分割粒度 | 10ファイルで機能群ごとに集約 | 35ファイルで概ね 1 plugin ごと |
| file picker / explorer | fzf-lua と Neo-tree | Telescope（jj extension 含む）と Oil |
| LSP 管理 | Mason + mason-lspconfig。明示 server のみ `vim.lsp.enable()` し、formatter を LSP 化しない | Mason、mason-lspconfig、mason-tool-installer。TypeScript は typescript-tools.nvim を使う |
| formatter | Conform で Lua、Shell、Python、JS/TS、Go、Rust、Swift、Ruby を設定 | Conform で config file がある JS/TS 系を `oxfmt` → `biome` → `prettierd`、Lua を Stylua |
| 言語の重点 | 幅広い LSP と Go / Rust / Cargo | TypeScript / JS 中心。TwoSlash、TSC、typescript-tools を追加 |
| UI / workflow | themes を複数保持、lualine、which-key、Harpoon、Gitsigns | Snacks、Oil、Diffview、Outline、Spectre、Undotree、Wilder、UFO、tiny-inline-diagnostic など workflow plugin が多い |

この設定の plugin 一覧は `lua/plugins/`、参照設定の plugin file 一覧は `home/.config/nvim/lua/plugins/` で再確認できる。

## 結論

共通する系統は「LazyVim を介さず lazy.nvim と plugin spec を直接所有する構成」である。一方、この設定は汎用・多言語型、参照設定は TypeScript 中心・workflow 拡張型である。plugin 選択を参照設定へ同一化する理由はない。
