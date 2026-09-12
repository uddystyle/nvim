# Neovim の最近の候補

確認日: 2026-09-06

「注目」は人気を定量比較した結論ではなく、現在の Neovim 0.12 と、各 plugin の一次 README / release notes を確認して選んだ候補である。

## すでに採用できているもの

- **blink.cmp**: 現在の設定は `saghen/blink.cmp` を採用済み。追加検討は不要。
  - 出典: https://github.com/saghen/blink.cmp
- **render-markdown.nvim**: Markdown の描画用として採用済み。
  - 出典: https://github.com/MeanderingProgrammer/render-markdown.nvim

## 候補

### `stevearc/quicker.nvim`

- built-in quickfix / location list を見やすくし、文脈展開、編集、refresh、toggle を提供する。Neovim 0.10 以上が必要。
- LSP references や compiler の結果を quickfix window で継続的に扱うなら、既存の FzfLua と役割が重複しない。
- 注意: README は context 展開時、同じ file/line を指す重複 quickfix item が最初の1件にまとめられると明記する。
- 判断: quickfix をほとんど開かないなら不要。
- 出典: https://github.com/stevearc/quicker.nvim/blob/master/README.md

### `duemir/sidekick.nvim`

- Copilot LSP の next-edit suggestion と terminal AI CLI を、diff review/apply、hunk 移動、buffer/cursor/diagnostics を含む prompt、session 連携として扱う plugin。
- Copilot LSP の設定・sign-in が必要な機能がある。単なる補完 plugin ではない。
- 判断: Neovim 内で Copilot または AI CLI の変更 diff をレビュー・適用したい場合だけ候補。現在の Pi agent 運用だけでは導入理由にならない。
- 出典: https://github.com/duemir/sidekick.nvim

### `folke/snacks.nvim`

- Picker、Explorer、dashboard、notifier、terminal などを module 単位で提供する suite。使う module を明示的に有効化する設計。
- Explorer は file watch、Git status、diagnostics、hidden/ignored toggle、file 操作を提供する。
- 判断: 現在の FzfLua + Neo-tree + Fidget 構成と大きく役割が重なるため、置換の明確な動機がない限り採用しない。
- 出典: https://github.com/folke/snacks.nvim
- Explorer の出典: https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md

### `rachartier/tiny-inline-diagnostic.nvim`

- built-in virtual text を置き換えて、診断内容を行内に表示する plugin。README は重複表示を避けるため virtual text を無効化すると説明する。
- 判断: 現在の設定は `vim.diagnostic.config({ virtual_text = false })` で控えめな診断表示を選んでいる。常時メッセージを出す UX は方針と逆なので採用しない。
- 出典: https://github.com/rachartier/tiny-inline-diagnostic.nvim

## 設定・基盤の流れ

- Neovim 0.12 は native package manager `vim.pack`、lockfile、package health check、LSP config API を提供する。
- ただし `vim.pack` への移行は必須ではない。現在の設定は lazy.nvim の `event` / `ft` / `cmd` / `keys` を使って読み込み時機を制御できているため、lazy.nvim を維持する。
- 出典: https://github.com/neovim/neovim/releases/tag/v0.12.0
