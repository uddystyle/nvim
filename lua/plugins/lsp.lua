local servers = {
  "bashls",
  "cssls",
  "gopls",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "pyright",
  "ruby_lsp",
  "rust_analyzer",
  "svelte",
  "tailwindcss",
  "taplo",
  "vtsls",
  "yamlls",
  "zls",
}

local mason_packages = {
  "bash-language-server",
  "css-lsp",
  "gopls",
  "html-lsp",
  "json-lsp",
  "lua-language-server",
  "marksman",
  "pyright",
  "ruby-lsp",
  "rust-analyzer",
  "svelte-language-server",
  "tailwindcss-language-server",
  "taplo",
  "vtsls",
  "yaml-language-server",
  "zls",
  "black",
  "goimports",
  "prettier",
  "shfmt",
  "stylua",
}

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      { "folke/lazydev.nvim", ft = "lua", opts = {} },
      { "j-hui/fidget.nvim", opts = {} },
    },
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = false,
      })

      if vim.env.NVIM_STANDALONE_SKIP_MASON_INSTALL ~= "1" then
        local registry = require("mason-registry")
        registry.refresh(function()
          for _, package_name in ipairs(mason_packages) do
            local ok, package = pcall(registry.get_package, package_name)
            if ok and not package:is_installed() and not package:is_installing() then
              package:install()
            end
          end
        end)
      end

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            analyses = { unusedparams = true, unusedvariable = true },
          },
        },
      })

      vim.lsp.config("vtsls", {
        on_attach = function(client, buffer)
          vim.keymap.set("n", "<leader>co", function()
            client:exec_cmd({ command = "typescript.organizeImports", arguments = { vim.api.nvim_buf_get_name(buffer) } })
          end, { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", function()
            local old_name = vim.api.nvim_buf_get_name(buffer)
            vim.ui.input({ prompt = "New file name: ", default = old_name, completion = "file" }, function(new_name)
              if not new_name or new_name == "" or new_name == old_name then return end
              vim.lsp.util.rename(old_name, new_name)
              vim.cmd.edit(vim.fn.fnameescape(new_name))
            end)
          end, { buffer = buffer, desc = "Rename current file" })
        end,
        settings = {
          vtsls = {
            autoUseWorkspaceTsdk = true,
            enableMoveToFileCodeAction = true,
          },
          typescript = { suggest = { completeFunctionCalls = true } },
          javascript = { suggest = { completeFunctionCalls = true } },
        },
      })

      vim.lsp.config("rust_analyzer", {
        on_attach = function(_, buffer)
          vim.keymap.set("n", "<leader>fo", function() vim.lsp.buf.format({ async = true }) end, { buffer = buffer, desc = "Format (rustfmt)" })
          vim.keymap.set("n", "<leader>re", vim.lsp.buf.rename, { buffer = buffer, desc = "Rename Symbol" })
        end,
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true, loadOutDirsFromCheck = true },
            check = { command = "clippy", extraArgs = { "--all", "--all-features" } },
            diagnostics = { enable = true, disabled = { "unresolved-import", "inactive-code" } },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
            inlayHints = {
              typeHints = { enable = true },
              chainingHints = { enable = true },
              parameterHints = { enable = true },
              closingBraceHints = { enable = false },
            },
          },
        },
      })

      local lsp_keymaps = vim.api.nvim_create_augroup("config-lsp-keymaps", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_keymaps,
        callback = function(event)
          local buffer = event.buf
          local map = function(lhs, rhs, desc)
            local existing = vim.fn.maparg(lhs, "n", false, true)
            if existing.lhs and existing.lhs ~= "" then return end
            vim.keymap.set("n", lhs, rhs, { buffer = buffer, desc = desc })
          end

          map("gd", vim.lsp.buf.definition, "LSP: Go to definition")
          map("gD", vim.lsp.buf.declaration, "LSP: Go to declaration")
          map("gr", vim.lsp.buf.references, "LSP: Go to references")
          map("gi", vim.lsp.buf.implementation, "LSP: Go to implementation")
          map("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "LSP: Hover")
          map("<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
          map("<leader>rn", vim.lsp.buf.rename, "LSP: Rename symbol")
        end,
      })

      vim.lsp.enable(servers)
    end,
  },
}
