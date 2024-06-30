return {
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
