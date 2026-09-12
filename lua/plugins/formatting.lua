vim.api.nvim_create_user_command("ConformDisable", function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable format-on-save",
  bang = true,
})

vim.api.nvim_create_user_command("ConformEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = "Enable format-on-save" })

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
      format_on_save = function(buffer_number)
        if vim.g.disable_autoformat or vim.b[buffer_number].disable_autoformat then
          return
        end
        return { timeout_ms = 3000, lsp_format = "fallback" }
      end,
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
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        prettier = {
          condition = function(_, ctx)
            return vim.fs.find({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.js",
              ".prettierrc.cjs",
              ".prettierrc.mjs",
              "prettier.config.js",
              "prettier.config.cjs",
              "prettier.config.mjs",
            }, {
              path = ctx.filename,
              upward = true,
              stop = vim.uv.os_homedir(),
            })[1] ~= nil
          end,
        },
      },
    },
  },
}
