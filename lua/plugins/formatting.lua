return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "v" },
        desc = "Format Buffer",
      },
    },
    opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      format_on_save = { timeout_ms = 3000, lsp_format = "fallback" },
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        python = { "black" },
        javascript = { "prettier" },
        html = { "prettier" },
        typescript = { "prettier" },
        css = { "prettier" },
        go = { "goimports", "gofmt" },
        rust = { "rustfmt" },
        swift = { "swift_format" },
        ruby = { "prettier" },
      },
      formatters = { injected = { options = { ignore_errors = true } } },
    },
  },
}
