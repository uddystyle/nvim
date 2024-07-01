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

            vim.keymap.set("n", "<leader>k", function()
              vim.cmd.RustLsp({ "hover", "actions" })
            end, { silent = true, buffer = bufnr })

            vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                  enable = true,
                },
              },
              checkOnSave = true,
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

  {
    "b0o/SchemaStore.nvim",
    enabled = false,
  },
}
