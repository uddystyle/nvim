return {
  -- "folke/tokyonight.nvim",
  -- lazy = false,
  -- priority = 1000,
  -- opts = {
  --   style = "storm",
  --   terminal_colors = true,
  -- transparent = true,
  -- styles = {
  -- sidebars = "transparent",
  -- floats = "transparent",
  -- },
  -- },
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    opts = {
      cmp = true,
      gitsigns = true,
      mason = true,
      markdown = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      telescope = true,
      treesitter = true,
    },
    config = function()
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
}
