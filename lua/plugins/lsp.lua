return {

  -- For typescript
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", ":TypescriptOrganizeImports<CR>", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", ":TypescriptRenameFile<CR>", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    opts = {
      servers = {
        -- typescript
        tsserver = {
          enabled = false,
        },
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            complate_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "never" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = false },
                parameterNames = { enabled = false },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
        -- C lang
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp" },
          settings = {
            fallbackFlags = { "--fallback-style=llvm" },
          },
          cmd = { "clangd", "--fallback-style={IndektWidth: 4, TabWidth: 4}" },
        },
      },
      setup = {
        tsserver = function(_, opts)
          return opts
        end,
        vtsls = function(_, opts)
          LazyVim.lsp.on_attach(function(client, buffer)
            client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
              ---@type string, string, lsp.Range
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
                ---@type string[]
                local files = result.body.files
                table.insert(files, 1, "Enter new path...")
                vim.ui.select(files, {
                  prompt = "Select move destination:",
                  format_item = function(f)
                    return vim.fn.fnamemodify(f, ":~:.")
                  end,
                }, function(f)
                  if f and f:find("^Enter new path") then
                    vim.ui.input({
                      prompt = "Enter move destination:",
                      default = vim.fn.fnamemodify(fname, ":h") .. "/",
                      completion = "file",
                    }, function(newf)
                      return newf and move(newf)
                    end)
                  elseif f then
                    move(f)
                  end
                end)
              end)
            end
          end, "vtsls")
          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
        end,
      },
    },
  },

  -- For Rust
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "simrat39/rust-tools.nvim",
      "williamboman/mason-lspconfig.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(client, buffer)
          vim.keymap.set("n", "<leader>fo", function()
            vim.lsp.buf.format({ async = true })
          end, { buffer = buffer, desc = "Format (rustfmt)" })

          vim.keymap.set("n", "<leader>re", vim.lsp.buf.rename, { desc = "Rename Symbol", buffer = buffer })
        end)
      end,
    },
    opts = {
      servers = {
        rust_analyzer = {
          filetypes = { "rust" },
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
