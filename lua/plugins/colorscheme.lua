return {
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     style = "storm",
  --     terminal_colors = true,
  --     transparent = true,
  --     styles = {
  --       sidebars = "transparent",
  --       floats = "transparent",
  --     },
  --   },
  -- },

  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = false,
      no_italic = false,
      no_bold = false,
      no_underline = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        mason = true,
        markdown = true,
        notify = true,
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
    },
    config = function()
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
}
