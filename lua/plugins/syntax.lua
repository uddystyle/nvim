return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash", "c", "cpp", "css", "go", "graphql", "html", "javascript", "json", "lua", "markdown",
        "python", "rust", "scss", "sql", "svelte", "toml", "tsx", "typescript", "vim", "vimdoc", "zig",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
      provider_selector = function(_, _, buftype)
        if buftype ~= "" then return "" end
        return { "treesitter", "indent" }
      end,
    },
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
    },
  },
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>w", group = "write" },
        { "<leader>ww", "<Cmd>w<CR>", desc = "Save file" },
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { settings = { save_on_toggle = true } },
    keys = {
      { "<leader>H", function() require("harpoon"):list():add() end, desc = "Harpoon File" },
      { "<leader>h", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon Quick Menu" },
      { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon File 1" },
      { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon File 2" },
      { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon File 3" },
      { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon File 4" },
      { "<leader>5", function() require("harpoon"):list():select(5) end, desc = "Harpoon File 5" },
    },
  },
}
