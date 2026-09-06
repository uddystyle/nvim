local root = require("config.root")

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = vim.env.NVIM_STANDALONE_TEST == "1",
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
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-macchiato")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then vim.o.statusline = " " else vim.o.laststatus = 0 end
    end,
    opts = {
      options = {
        theme = "auto",
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          {
            "diff",
            symbols = { added = "+", modified = "~", removed = "-" },
            source = function()
              local status = vim.b.gitsigns_status_dict
              if status then return { added = status.added, modified = status.changed, removed = status.removed } end
            end,
          },
          { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
        },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = {
          { function() return vim.fn.fnamemodify(root.get(), ":~") end, cond = function() return root.get() ~= vim.uv.cwd() end },
          { "filetype", icon_only = false, padding = { left = 1, right = 1 } },
        },
        lualine_y = { { "progress", separator = " ", padding = { left = 1, right = 1 } } },
        lualine_z = { "location" },
      },
      extensions = { "neo-tree", "lazy" },
    },
  },
}
