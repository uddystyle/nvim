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

  -- {
  --   "catppuccin/nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     no_italic = true,
  --     term_colors = true,
  --     transparent_background = false,
  --     integrations = {
  --       cmp = true,
  --       dashboard = true,
  --       gitsigns = true,
  --       indent_blankline = { enabled = true },
  --       lsp_trouble = true,
  --       mason = true,
  --       markdown = true,
  --       mini = true,
  --       native_lsp = {
  --         enabled = true,
  --         underlines = {
  --           errors = { "undercurl" },
  --           hints = { "undercurl" },
  --           warnings = { "undercurl" },
  --           information = { "undercurl" },
  --         },
  --       },
  --       navic = { enabled = true, custom_bg = "lualine" },
  --       neotree = true,
  --       noice = true,
  --       notify = true,
  --       semantic_tokens = true,
  --       telescope = true,
  --       treesitter = true,
  --       treesitter_context = true,
  --       which_key = true,
  --     },
  --   },
  -- },

  -- {
  --   "morhetz/gruvbox",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     vim.cmd([[colorscheme gruvbox]])
  --   end,
  -- },

  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     require("gruvbox").setup({
  --       terminal_colors = true, -- add neovim terminal colors
  --       undercurl = true,
  --       underline = true,
  --       bold = true,
  --       italic = {
  --         strings = true,
  --         emphasis = true,
  --         comments = true,
  --         operators = false,
  --         folds = true,
  --       },
  --       strikethrough = true,
  --       invert_selection = false,
  --       invert_signs = false,
  --       invert_tabline = false,
  --       invert_intend_guides = false,
  --       inverse = false, -- invert background for search, diffs, statuslines and errors
  --       contrast = "hard", -- can be "hard", "soft" or empty string
  --       palette_overrides = {},
  --       overrides = {},
  --       dim_inactive = false,
  --       transparent_mode = false,
  --     })
  --     vim.cmd([[colorscheme gruvbox]])
  --   end,
  -- },

  -- {
  --   "rebelot/kanagawa.nvim",
  --   config = function()
  --     require("kanagawa").setup({
  --       compile = false,
  --       undercurl = true,
  --       commentStyle = { italic = true },
  --       functionStyle = {},
  --       keywordStyle = { italic = true },
  --       statementStyle = { bold = true },
  --       typeStyle = {},
  --       transparent = false,
  --       dimInactive = false, -- dim inactive window `:h hl-NormalNC`
  --       terminalColors = true, -- define vim.g.terminal_color_{0,17}
  --       colors = {
  --         palette = {},
  --         theme = {
  --           wave = {},
  --           lotus = {},
  --           dragon = {},
  --           all = {
  --             ui = {
  --               bg_gutter = "none",
  --             },
  --           },
  --         },
  --       },
  --       overrides = function(colors) -- add/modify highlights
  --         return {}
  --       end,
  --       theme = "dragon",
  --       background = {
  --         dark = "dragon",
  --         light = "lotus",
  --       },
  --     })
  --     vim.cmd([[colorscheme kanagawa-dragon]])
  --   end,
  -- },
}
