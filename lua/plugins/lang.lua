return {
  {
    {
      "mfussenegger/nvim-dap",
      recommended = true,
      desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

      dependencies = {
        "rcarriga/nvim-dap-ui",
        -- virtual text for the debugger
        {
          "theHamsta/nvim-dap-virtual-text",
          opts = {},
        },
      },

  -- stylua: ignore
  keys = {
    { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },

      config = function()
        -- load mason-nvim-dap here, after all adapters have been setup
        if LazyVim.has("mason-nvim-dap.nvim") then
          require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
        end

        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

        for name, sign in pairs(LazyVim.config.icons.dap) do
          sign = type(sign) == "table" and sign or { sign }
          vim.fn.sign_define(
            "Dap" .. name,
            { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
          )
        end

        -- setup dap config by VsCode launch.json file
        local vscode = require("dap.ext.vscode")
        local json = require("plenary.json")
        vscode.json_decode = function(str)
          return vim.json.decode(json.json_strip_comments(str))
        end
      end,
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    lazy = false,
    config = function()
      local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path .. "lldb/lib/liblldb"
      local this_os = vim.uv.os_uname().sysname
      local config = require("rustaceanvim.config")
      -- The path is different on Windows
      if this_os:find("Windows") then
        codelldb_path = extension_path .. "adapter\\codelldb.exe"
        liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
      else
        -- The liblldb extension is .so for Linux and .dylib for MacOS
        liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
      end
      vim.g.rustaceanvim = {
        tools = {
          auto_focus = true,
        },
        server = {
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
}
