# LazyVim 離脱計画

## 合意済みの方針

- 現行機能を維持して LazyVim 依存だけを外す。
- 独立設定を `NVIM_APPNAME` で検証してから切り替える。
- `lazy-lock.json` を維持してプラグイン revision を固定する。
- 移植対象は自前 spec と明示的に選んだ extras、およびそれらが必要とする依存関係に限る。LazyVim の標準機能は移植しない。

## 移行前ベースライン

移行前の LazyVim 設定は LazyVim 本体、`lazyvim.plugins`、次の extras を import していた。

- `lang.json`, `lang.rust`, `lang.ruby`, `lang.toml`, `lang.markdown`
- `util.mini-hipatterns`

移行前の lockfile には56プラグインがあり、自前 spec は8ファイルだった。旧設定と rollback 用ファイルは削除済み。

| 領域 | LazyVim 依存の例 | 移行先 |
|---|---|---|
| ファイル／grep picker | `LazyVim.pick` | fzf-lua の直接呼び出しと root/cwd 決定関数 |
| LSP | `LazyVim.config`、LazyVim の lsp defaults | `nvim-lspconfig`、Mason、明示した server spec |
| 補完 | `LazyVim.cmp`、icons | blink.cmp または nvim-cmp を明示 setup し、icons を自前 table にする |
| UI | `LazyVim.lualine`、`LazyVim.ui` | lualine component と highlight helper を自前化 |
| keymap／autocmd／options | LazyVim defaults | 必要な現行の振る舞いを独立 modules に明文化 |

## 実施順

1. root に lazy.nvim だけを bootstrap する独立 config を作る。`LazyVim` を spec に含めない。 **完了**
   - `lua/config/lazy.lua` は root の `lazy-lock.json` を使用する。
   - `tests/standalone-smoke.sh` は独立した config/data directory で headless 起動し、LazyVim を読み込まないことを確認する。
2. 自前 spec・明示 extra・必要な dependency を分類する。 **完了**
   - LazyVim の標準 plugin、標準 keymap、標準 UI は standalone から除外する。
3. options、keymaps、autocmds、root 検出を移す。次に picker、UI、補完、LSP、言語 extras の順で direct spec 化する。 **完了**
   - 自前 spec と明示 extra に含まれる picker、補完、LSP、Treesitter、Harpoon、Conform、Neo-tree、カスタム colorscheme 群、lualine、Go/Rust/Cargo/TypeScript、Markdown、mini.hipatterns を移植する。ファイル picker とファイルツリーは隠しファイルと `.gitignore` 対象を含む。
   - 完了: standalone config の Lua source に `LazyVim` 参照がない。
4. 機能検証を行う。 **進行中**
   - `scripts/nvim-standalone` はこの repo を `NVIM_APPNAME=nvim-standalone` として隔離起動する。`scripts/check-standalone` は smoke、integration、通常 entrypoint test をまとめて実行する。
   - `:Lazy! sync`、headless 起動、主要 plugin の明示 load は成功した。`tests/standalone-integration.sh` は Lua / TypeScript / Rust / Go buffer への LSP attach、Lua 保存時の Stylua format、fzf-lua が隠し・ignore 対象を含むことを確認する。
   - standalone の Mason は LSP と Conform formatter の不足パッケージを通常起動中に導入する。テストは `NVIM_STANDALONE_SKIP_MASON_INSTALL=1` でこの非同期導入を抑止する。
   - `:checkhealth` は必須機能の起動エラーを報告しなかった。Node provider と pynvim は警告された。
   - `markdown-preview.nvim` は依存リスクのため削除し、`render-markdown.nvim` を維持する。
   - 既存 keymap と standalone keymap の差分を確認する。
   - ファイル検索（隠し・gitignore 対象）、LSP attach、補完、format、Git signs、Rust/Ruby/JSON/TOML/Markdown の filetype 起動を確認する。
5. standalone を通常 config として採用する。 **完了**
   - `init.lua` は standalone entrypoint を読み込む。旧 LazyVim 設定は削除した。
   - `tests/normal-entrypoint.sh` は通常起動が standalone を読み、LazyVim を読み込まないことを確認する。

## 切り替え前チェックリスト

- [x] `scripts/check-standalone` が通る。
- [x] standalone の Lua source に `LazyVim` 参照がない。
- [ ] `scripts/nvim-standalone` を日常利用し、補完、picker、Neo-tree、Git signs を対話確認する。
- [x] 通常設定を standalone に切り替え、旧 LazyVim 設定を削除した。

## 判断ルール

- 移行中に出る追加 dependency は、現行 lockfile か現行動作から必要性を確認して追加する。
- 挙動を置き換える場合は、対応する keymap／command／イベントを先に検証項目へ追加する。
- `lazy = false` は起動時に必要なものだけに限定し、各採用理由を spec の近くに残す。
