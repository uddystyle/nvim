return {

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      terminal_colors = true,
      transparent = false,
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      no_italic = true,
      term_colors = true,
      transparent_background = false,
    },
  },

  {
    "navarasu/onedark.nvim",
    opts = {
      style = "dark",
      transparent = false,
      colors = {
        green = "#98c379",
        yellow = "#e5c07b",
        blue = "#61afef",
        red = "#e06c75",
        cyan = "#56b6c2",
        purple = "#c678dd",
        black = "#282c34",
        white = "#dcdfe4",
      },
    },
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      commentStyle = { italic = true },
      keywordStyle = { italic = false },
      statementStyle = { bold = true },
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
    },
  },
}
