return {
  { "folke/tokyonight.nvim", lazy = vim.env.NVIM_STANDALONE_TEST == "1", priority = 1000, opts = { style = "night", terminal_colors = true, transparent = false } },
  { "morhetz/gruvbox", lazy = vim.env.NVIM_STANDALONE_TEST == "1", priority = 1000 },
  {
    "dybdeskarphet/gruvbox-minimal.nvim",
    lazy = vim.env.NVIM_STANDALONE_TEST == "1",
    priority = 1000,
    config = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "gruvbox-minimal",
        callback = function() vim.api.nvim_set_hl(0, "Comment", { fg = "#665c54", italic = false }) end,
      })
    end,
  },
  { "sainnhe/everforest", lazy = vim.env.NVIM_STANDALONE_TEST == "1", priority = 1000, init = function() vim.g.everforest_background = "hard" end },
  { "xero/miasma.nvim", lazy = vim.env.NVIM_STANDALONE_TEST == "1", priority = 1000 },
  {
    "navarasu/onedark.nvim",
    lazy = vim.env.NVIM_STANDALONE_TEST == "1",
    opts = {
      style = "dark",
      transparent = false,
      colors = { green = "#98c379", yellow = "#e5c07b", blue = "#61afef", red = "#e06c75", cyan = "#56b6c2", purple = "#c678dd", black = "#282c34", white = "#dcdfe4" },
    },
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = vim.env.NVIM_STANDALONE_TEST == "1",
    priority = 1000,
    opts = {
      commentStyle = { italic = true },
      keywordStyle = { italic = false },
      statementStyle = { bold = true },
      colors = { palette = { oldWhite = "#c5c9c5" }, theme = { all = { ui = { bg_gutter = "none", bg = "#000000" } } } },
      overrides = function(colors)
        local theme = colors.theme
        return {
          NormalFloat = { bg = "none" }, FloatBorder = { bg = "none" }, FloatTitle = { bg = "none" },
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
          LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim }, MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 }, PmenuThumb = { bg = theme.ui.bg_p2 },
        }
      end,
    },
  },
  {
    "aktersnurra/no-clown-fiesta.nvim",
    priority = 1000,
    lazy = vim.env.NVIM_STANDALONE_TEST == "1",
    opts = { styles = { types = { bold = true }, lsp = { underline = false }, match_paren = { underline = true } } },
  },
  {
    "metalelf0/kintsugi-nvim",
    lazy = vim.env.NVIM_STANDALONE_TEST == "1",
    priority = 1000,
    config = function()
      require("kintsugi").setup({ variant = "flared", transparent = false, terminal_colors = true, bold_keywords = true, italic_comments = false })
    end,
  },
}
