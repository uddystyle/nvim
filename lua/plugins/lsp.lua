return {

  -- Diagnostics configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
      },
    },
  },

  -- For typescript
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
    },
    opts = {
      servers = {
        tsserver = {
          enabled = false,
        },

        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },

          on_attach = function(client, buffer)
            -- typescript.nvim のキーマップ
            vim.keymap.set(
              "n",
              "<leader>co",
              "<cmd>TypescriptOrganizeImports<CR>",
              { buffer = buffer, desc = "Organize Imports" }
            )

            vim.keymap.set(
              "n",
              "<leader>cR",
              "<cmd>TypescriptRenameFile<CR>",
              { buffer = buffer, desc = "Rename File" }
            )

            -- moveToFileRefactoring の上書き
            client.commands["_typescript.moveToFileRefactoring"] = function(command)
              local action, uri, range = unpack(command.arguments)

              local function move(newf)
                client.request("workspace/executeCommand", {
                  command = command.command,
                  arguments = { action, uri, range, newf },
                })
              end

              local fname = vim.uri_to_fname(uri)

              client.request("workspace/executeCommand", {
                command = "typescript.tsserverRequest",
                arguments = {
                  "getMoveToRefactoringFileSuggestions",
                  {
                    file = fname,
                    startLine = range.start.line + 1,
                    startOffset = range.start.character + 1,
                    endLine = range["end"].line + 1,
                    endOffset = range["end"].character + 1,
                  },
                },
              }, function(_, result)
                local files = result.body.files
                table.insert(files, 1, "Enter new path...")

                vim.ui.select(files, {
                  prompt = "Select move destination:",
                  format_item = function(f)
                    return vim.fn.fnamemodify(f, ":~:.")
                  end,
                }, function(f)
                  if not f then
                    return
                  end

                  if f:match("^Enter new path") then
                    vim.ui.input({
                      prompt = "Enter move destination:",
                      default = vim.fn.fnamemodify(fname, ":h") .. "/",
                      completion = "file",
                    }, function(newf)
                      if newf then
                        move(newf)
                      end
                    end)
                  else
                    move(f)
                  end
                end)
              end)
            end
          end,

          settings = {
            vtsls = {
              autoUseWorkspaceTsdk = true,
            },
            typescript = {
              suggest = {
                completeFunctionCalls = true,
              },
            },
          },
        },
      },
    },
  },

  -- For Rust
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "simrat39/rust-tools.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    opts = {
      servers = {
        rust_analyzer = {
          filetypes = { "rust" },

          on_attach = function(_, buffer)
            vim.keymap.set("n", "<leader>fo", function()
              vim.lsp.buf.format({ async = true })
            end, { buffer = buffer, desc = "Format (rustfmt)" })

            vim.keymap.set("n", "<leader>re", vim.lsp.buf.rename, { buffer = buffer, desc = "Rename Symbol" })
          end,

          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
              },
              diagnostics = {
                enable = true,
                disabled = { "unresolved-import", "inactive-code" },
              },
              checkOnSave = {
                command = "clippy",
                extraArgs = { "--all", "--all-features" },
              },
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
        },
      },

      setup = {
        rust_analyzer = function(_, opts)
          require("rust-tools").setup({
            tools = {
              hover_actions = {
                auto_focus = true,
              },
              inlay_hints = {
                auto = true,
                show_parameter_hints = true,
                parameter_hints_prefix = "<- ",
                other_hints_prefix = "=> ",
              },
            },
            server = opts,
          })
          return true
        end,
      },
    },
  },
}
