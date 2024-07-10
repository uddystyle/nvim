return {

  -- {
  --   "mfussenegger/nvim-dap",
  --
  --   dependencies = {
  --     "rcarriga/nvim-dap-ui",
  --     "jbyuki/one-small-step-for-vimkind",
  --     {
  --       "theHamsta/nvim-dap-virtual-text",
  --       opts = {},
  --     },
  --   },
  --
  --   config = function()
  --     local dap = require("dap")
  --     dap.adapters.lldb = {
  --       type = "executable",
  --       command = "/opt/homebrew/opt/llvm/bin/lldb",
  --       name = "lldb",
  --     }
  --
  --     if LazyVim.has("mason-nvim-dap.nvim") then
  --       require("mason-nvim.dap").setup(LazyVim.opts("mason-nvim-dap.vim"))
  --     end
  --
  --     for name, sign in pairs(LazyVim.config.icons.dap) do
  --       sign = type(sign) == "table" and sign or { sign }
  --       vim.fn.sign_define(
  --         "Dap" .. name,
  --         { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
  --       )
  --     end
  --   end,
  --
  --   keys = {
  --     { "<leader>d", "", desc = "+debug", mode = { "n", "v" } },
  --     {
  --       "<leader>dB",
  --       function()
  --         require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
  --       end,
  --       desc = "Breakpoint Condition",
  --     },
  --     {
  --       "<leader>db",
  --       function()
  --         require("dap").toggle_breakpoint()
  --       end,
  --       desc = "Toggle Breakpoint",
  --     },
  --     {
  --       "<leader>dc",
  --       function()
  --         require("dap").continue()
  --       end,
  --       desc = "Continue",
  --     },
  --     {
  --       "<leader>da",
  --       function()
  --         require("dap").continue({ before = get_args })
  --       end,
  --       desc = "Run with Args",
  --     },
  --     {
  --       "<leader>dC",
  --       function()
  --         require("dap").run_to_cursor()
  --       end,
  --       desc = "Run to Cursor",
  --     },
  --     {
  --       "<leader>dg",
  --       function()
  --         require("dap").goto_()
  --       end,
  --       desc = "Go to Line (No Execute)",
  --     },
  --     {
  --       "<leader>di",
  --       function()
  --         require("dap").step_into()
  --       end,
  --       desc = "Step Into",
  --     },
  --     {
  --       "<leader>dj",
  --       function()
  --         require("dap").down()
  --       end,
  --       desc = "Down",
  --     },
  --     {
  --       "<leader>dk",
  --       function()
  --         require("dap").up()
  --       end,
  --       desc = "Up",
  --     },
  --     {
  --       "<leader>dl",
  --       function()
  --         require("dap").run_last()
  --       end,
  --       desc = "Run Last",
  --     },
  --     {
  --       "<leader>do",
  --       function()
  --         require("dap").step_out()
  --       end,
  --       desc = "Step Out",
  --     },
  --     {
  --       "<leader>dO",
  --       function()
  --         require("dap").step_over()
  --       end,
  --       desc = "Step Over",
  --     },
  --     {
  --       "<leader>dp",
  --       function()
  --         require("dap").pause()
  --       end,
  --       desc = "Pause",
  --     },
  --     {
  --       "<leader>dr",
  --       function()
  --         require("dap").repl.toggle()
  --       end,
  --       desc = "Toggle REPL",
  --     },
  --     {
  --       "<leader>ds",
  --       function()
  --         require("dap").session()
  --       end,
  --       desc = "Session",
  --     },
  --     {
  --       "<leader>dt",
  --       function()
  --         require("dap").terminate()
  --       end,
  --       desc = "Terminate",
  --     },
  --     {
  --       "<leader>dw",
  --       function()
  --         require("dap.ui.widgets").hover()
  --       end,
  --       desc = "Widgets",
  --     },
  --   },
  -- },

  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    lazy = false,
    config = function()
      local mason_registry = require("mason-registry")
      local codelldb = mason_registry.get_package("codelldb")
      local extension_path = codelldb:get_install_path() .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
      local config = require("rustaceanvim.config")

      vim.g.rustaceanvim = {
        tools = {
          hover_actions = {
            auto_focus = true,
          },
        },
        server = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          on_attach = function(_, bufnr)
            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "<leader>ca", function()
              vim.cmd.RustLsp("codeAction")
            end, { silent = true, buffer = bufnr })

            vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
          end,
          default_settings = {
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
              proMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
        dap = {
          autoload_configurations = true,
          adapter = config.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "Saecki/crates.nvim",
    },
    opts = {
      completion = {
        cmp = { enable = true },
      },
      servers = {
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
    },
  },

  -- add tsserver and setup with typescript.nvim instead of lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
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
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
      },
      setup = {
        tsserver = function()
          return true
        end,
        vtsls = function(_, opts)
          LazyVim.lsp.on_attach(function(client, buffer)
            client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
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
}
