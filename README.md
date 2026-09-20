# Neovim configuration (standalone)

A standalone [lazy.nvim](https://github.com/folke/lazy.nvim) configuration.

> This is **not** the LazyVim starter template anymore. It evolved out of one
> into a self-contained config: `init.lua` loads `lua/config/*` itself and the
> plugin spec is `{ import = "plugins" }`. No `LazyVim` dependency is loaded,
> which `tests/normal-entrypoint.sh` verifies.

## Layout

```
init.lua                       entrypoint: loads lua/config/* and lazy.nvim
lua/config/                    options, keymaps, autocmds, lazy setup, root detection, themes
lua/plugins/                   lazy.nvim specs (completion, formatting, fzf, lsp, ...)
after/plugin/herdr-navigation.lua    Ctrl-h/j/k/l cross Vim/Herdr pane navigation
scripts/nvim-standalone        run this config in isolation (temp XDG_CONFIG_HOME)
scripts/check-standalone       run the full test suite
tests/                         headless smoke/integration tests
stylua.toml                    formatting rules for the Lua files
```

## Usage

Run normally:

```sh
nvim
```

Run against this repository in isolation, without touching your real config:

```sh
scripts/nvim-standalone
```

## Testing

```sh
scripts/check-standalone
```

The suite enumerates the standalone tests in `scripts/check-standalone` (smoke,
integration, conform, LSP, folding, theme) and adds `tests/normal-entrypoint.sh`,
which verifies that a plain `nvim` boots this config, applies Everforest Dark
Hard with a transparent background, and never loads LazyVim.

`tests/fzf-filetype.sh`, `tests/herdr-navigation.sh`, and
`tests/terminal-toggle.sh` are not part of the suite: they exercise the real
configuration.

Environment variables honored in tests:

- `NVIM_STANDALONE_TEST=1` — test mode: lazy.nvim locks to the data dir, plugin
  install is disabled, and the default colorscheme loads lazily.
- `NVIM_STANDALONE_SKIP_MASON_INSTALL=1` — skip automatic Mason package install.

## Highlights

- Leader `,`; `jj` escapes insert mode.
- `fzf-lua` for files/grep/buffers, rooted at the project root
  (`vim.fs.root` markers: `.git`, `lua`, `package.json`, `Cargo.toml`,
  `Gemfile`, `Makefile`).
- LSP via `nvim-lspconfig` + Mason: 16 servers with per-language settings
  (gopls, vtsls, rust-analyzer, ...), attach keymaps on non-file buffers
  disabled.
- Format-on-save with `conform.nvim`; toggle with `:ConformDisable`
  (global) and `:ConformDisable!` (buffer), re-enable with `:ConformEnable`.
- `blink.cmp` completion (LSP, path, snippets, buffer).
- Theme switching via `:Theme <name>` (Everforest Dark Hard by default).
- `<C-h/j/k/l>` move between Vim windows and, at the edge, focus the adjacent
  Herdr pane.

## Third-party code

`after/plugin/herdr-navigation.lua` is derived from
[paulbkim-dev/vim-herdr-navigation](https://github.com/paulbkim-dev/vim-herdr-navigation)
(MIT). See `after/plugin/herdr-navigation.SOURCE.md` and
`after/plugin/vim-herdr-navigation.LICENSE`.

## License

Apache-2.0 — see [LICENSE](LICENSE).