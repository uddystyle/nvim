vim.api.nvim_create_user_command("Theme", function(args)
  require("config.themes").apply(args.args)
end, {
  nargs = 1,
  complete = function()
    return require("config.themes").names()
  end,
  desc = "Load and apply a configured theme",
})

local transparent_groups = {
  "Normal",
  "NormalNC",
  "SignColumn",
  "EndOfBuffer",
  "FoldColumn",
}

local function set_background(group, source)
  local highlight = vim.api.nvim_get_hl(0, { name = source or group, link = false })
  highlight.bg = 0x232a2e
  highlight.ctermbg = nil
  vim.api.nvim_set_hl(0, group, highlight)
end

local function apply_theme_overrides()
  for _, group in ipairs(transparent_groups) do
    vim.cmd(("highlight %s guibg=NONE ctermbg=NONE"):format(group))
  end

  for _, group in ipairs({ "NormalFloat", "FloatBorder", "FloatTitle", "Pmenu", "PmenuSbar" }) do
    set_background(group)
  end
  set_background("WhichKeyNormal", "NormalFloat")
  set_background("WhichKeyBorder", "FloatBorder")
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = {
      flavour = "macchiato",
      no_italic = true,
      term_colors = true,
      transparent_background = false,
      integrations = {
        fidget = true,
        gitsigns = true,
        harpoon = true,
        mason = true,
        render_markdown = true,
        which_key = true,
      },
    },
  },
  { "morhetz/gruvbox", lazy = true, priority = 1000 },
  {
    "navarasu/onedark.nvim",
    lazy = true,
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
    lazy = true,
    priority = 1000,
    opts = {
      commentStyle = { italic = true },
      keywordStyle = { italic = false },
      statementStyle = { bold = true },
      colors = { palette = { oldWhite = "#c5c9c5" }, theme = { all = { ui = { bg_gutter = "none", bg = "#000000" } } } },
      overrides = function(colors)
        local theme = colors.theme
        return {
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
          LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },
        }
      end,
    },
  },
  {
    "metalelf0/kintsugi-nvim",
    lazy = true,
    priority = 1000,
    config = function()
      require("kintsugi").setup({
        variant = "flared",
        transparent = false,
        terminal_colors = true,
        bold_keywords = true,
        italic_comments = false,
      })
    end,
  },
  {
    "sainnhe/everforest",
    lazy = vim.env.NVIM_STANDALONE_TEST == "1",
    priority = 1000,
    init = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_colors_override = { bg0 = { "#1e2326", "233" } }
      vim.g.everforest_disable_italic_comment = 1
      vim.g.everforest_enable_italic = 0
      vim.g.everforest_better_performance = 1
    end,
    config = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("transparent_background", { clear = true }),
        callback = apply_theme_overrides,
      })
      vim.cmd.colorscheme("everforest")
    end,
  },
}
