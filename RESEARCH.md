# dmmulroy/.dotfiles の Neovim プラグイン管理調査

調査日: 2026-09-06  
対象: <https://github.com/dmmulroy/.dotfiles/>、取得コミット `fd84f52` (`updates`)

## 結論

参照設定は **LazyVim ディストリビューションを使わず、`lazy.nvim` を直接最小限に初期化し、1プラグイン（または密接な組）を1ファイルで宣言する** 構成である。プラグイン数そのものを極端に少なくする構成ではない（`lua/plugins/` に34ファイル）が、依存関係・ロード契機・設定の責務が各ファイルに分離され、何を削るかを判断しやすい。

## プラグイン管理の仕組み

| 主張 | 一次ソース |
|---|---|
| 起動時に `stdpath("data")/lazy/lazy.nvim` がなければ、`lazy.nvim` の `stable` ブランチを clone する。 | `home/.config/nvim/lua/dmmulroy/lazy.lua` の bootstrap 部 |
| `lazy.setup` の spec は `{ import = "plugins" }` だけで、`lua/plugins/*.lua` を自動収集する。 | 同ファイルの `lazy.setup({ spec = { { import = "plugins" } } })` |
| 変更検知の通知と更新チェックを有効にしている。 | 同ファイルの `change_detection = { enabled = true, notify = true }`、`checker = { enabled = true }` |
| 各プラグインファイルは lazy.nvim spec table を返し、ロード契機は `event`、`ft`、`cmd`、`keys` で宣言する方針。 | `home/.config/nvim/AGENTS.md` の `CONVENTIONS`、各 `lua/plugins/*.lua` |
| lockfile はリポジトリに存在しない（少なくとも対象コミットのツリーに `lazy-lock.json` はない）。従って plugin revision の再現性は固定されない。 | 再現: `git -C /tmp/dmmulroy-dotfiles ls-tree -r --name-only HEAD | grep lazy-lock.json` は出力なし |

## 実例

- 常時ロード: `snacks.nvim` (`lazy = false`) と `nvim-treesitter` (`lazy = false`)。  
  出典: `lua/plugins/snacks.lua`、`lua/plugins/treesitter.lua`。
- ファイル種別でロード: `lazydev.nvim` は Lua、`render-markdown.nvim` は Markdown 等、`typescript-tools.nvim` は TS/JS に限定。  
  出典: `lua/plugins/lsp.lua`、`lua/plugins/render-markdown.lua`、`lua/plugins/typescript-tools.lua`。
- コマンド／キーでロード: `diffview.nvim`、`outline.nvim`、`telescope.nvim`。  
  出典: 各対応ファイル。
- Telescope は `plenary.nvim`、native fzf、JJ 拡張を明示的な dependencies に置く。通常のファイル検索は JJ 拡張を試し、失敗時に `find_files({ hidden = true })` へフォールバックする。  
  出典: `lua/plugins/telescope.lua`。

## 現在の設定への示唆

このリポジトリは LazyVim を利用し、`lazy-lock.json` には56エントリある（調査時）。参照設定へ寄せると、LazyVim が提供するデフォルト／extra／依存プラグインを自分で所有することになる。そのため、最初の改善としては **LazyVim を外すことではなく、現在の各機能について「保持・無効化・代替」の責任表を作る** のが低リスクである。

参照設定から取り入れやすいのは次の2点。

1. `lua/plugins/` を「1プラグインまたは1機能群につき1ファイル」に保ち、spec にロード契機を明記する。
2. 常時ロード（`lazy = false`）を例外扱いにして、理由を各 spec の近くに残す。

参照設定の `AGENTS.md` は「35 files」と記す一方、対象コミットには34個の `lua/plugins/*.lua` がある。生成日時・コミットも対象 HEAD と一致しないため、プラグイン数の根拠としては使わず、実ファイルを正とした。

## 未確認

- 対象作者が lockfile を意図的に除外している理由、および実際の更新運用（`:Lazy update` の頻度）はリポジトリ内では確認できない。
- 起動時間・メモリ使用量の実測は、どちらの設定についても行っていない。
