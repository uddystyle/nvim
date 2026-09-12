return {
  {
    "rust-lang/rust.vim",
    ft = "rust",
  },
  {
    "saecki/crates.nvim",
    ft = { "toml" },
    opts = {},
  },
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod" },
    dependencies = { "ray-x/guihua.lua", "nvim-treesitter/nvim-treesitter" },
    opts = {
      lsp_inlay_hints = { enable = false },
      lsp_cfg = false,
    },
  },
  { "dmmulroy/ts-error-translator.nvim", event = "VeryLazy" },
}
