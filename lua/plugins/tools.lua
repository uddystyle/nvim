local root = require("config.root")

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>n",
        function()
          require("neo-tree.command").execute({ toggle = true, position = "float", dir = root.get() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<leader>N",
        function()
          require("neo-tree.command").execute({ toggle = true, position = "float", dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, position = "float", dir = root.get() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ toggle = true, position = "float", dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, position = "float", dir = root.get() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, position = "float", dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true, position = "right" })
        end,
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true, position = "right" })
        end,
        desc = "Buffer Explorer",
      },
    },
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false },
        bind_to_cwd = false,
        follow_current_file = { enabled = true, leave_dirs_open = false },
        use_libuv_file_watcher = true,
      },
      buffers = { follow_current_file = { enabled = true, leave_dirs_open = false } },
      window = {
        position = "float",
        popup = { size = { height = "80%", width = "80%" }, border = "rounded" },
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["<space>"] = "none",
          ["Y"] = function(state)
            vim.fn.setreg("+", state.tree:get_node():get_id(), "c")
          end,
          ["O"] = function(state)
            require("lazy.util").open(state.tree:get_node().path, { system = true })
          end,
          ["P"] = { "toggle_preview", config = { use_float = false } },
        },
      },
    },
    config = function(_, opts)
      local events = require("neo-tree.events")
      opts.event_handlers = {
        {
          event = events.FILE_MOVED,
          handler = function(data)
            for _, client in ipairs(vim.lsp.get_clients()) do
              if client:supports_method("workspace/didRenameFiles") then
                client:notify("workspace/didRenameFiles", {
                  files = {
                    { oldUri = vim.uri_from_fname(data.source), newUri = vim.uri_from_fname(data.destination) },
                  },
                })
              end
            end
          end,
        },
        {
          event = events.FILE_RENAMED,
          handler = function(data)
            for _, client in ipairs(vim.lsp.get_clients()) do
              if client:supports_method("workspace/didRenameFiles") then
                client:notify("workspace/didRenameFiles", {
                  files = {
                    { oldUri = vim.uri_from_fname(data.source), newUri = vim.uri_from_fname(data.destination) },
                  },
                })
              end
            end
          end,
        },
        {
          event = "file_opened",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      }
      require("neo-tree").setup(opts)
    end,
  },
}
