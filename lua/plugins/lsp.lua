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

    opts = {
      servers = {
        -- tsserver は使わない
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
            -- Organize Imports
            vim.keymap.set("n", "<leader>co", function()
              client:exec_cmd({
                command = "typescript.organizeImports",
                arguments = {
                  vim.api.nvim_buf_get_name(buffer),
                },
              })
            end, {
              buffer = buffer,
              desc = "Organize Imports",
            })

            -- Rename current file
            vim.keymap.set("n", "<leader>cR", function()
              local old_name = vim.api.nvim_buf_get_name(buffer)

              vim.ui.input({
                prompt = "New file name: ",
                default = old_name,
                completion = "file",
              }, function(new_name)
                if not new_name or new_name == "" or new_name == old_name then
                  return
                end

                vim.lsp.util.rename(old_name, new_name)

                vim.cmd.edit(vim.fn.fnameescape(new_name))
              end)
            end, {
              buffer = buffer,
              desc = "Rename File",
            })

            -- vtsls: Move to File Refactoring
            client.commands["_typescript.moveToFileRefactoring"] = function(command)
              local action, uri, range = unpack(command.arguments)

              local function move(newf)
                client.request("workspace/executeCommand", {
                  command = command.command,
                  arguments = {
                    action,
                    uri,
                    range,
                    newf,
                  },
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
              }, function(err, result)
                if err then
                  vim.notify("Failed to get move suggestions: " .. vim.inspect(err), vim.log.levels.ERROR)
                  return
                end

                if not result or not result.body or not result.body.files then
                  return
                end

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
                      if newf and newf ~= "" then
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

              -- Move to File のCode Actionを有効化
              enableMoveToFileCodeAction = true,
            },

            typescript = {
              suggest = {
                completeFunctionCalls = true,
              },
            },

            javascript = {
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
