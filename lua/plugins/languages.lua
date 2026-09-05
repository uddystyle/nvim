return {
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function() vim.g.rustfmt_autosave = 1 end,
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
      lsp_cfg = {
        settings = {
          gopls = {
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            analyses = { unusedparams = true, unusedvariable = true },
          },
        },
      },
    },
  },
  { "dmmulroy/ts-error-translator.nvim", event = "VeryLazy" },
}
