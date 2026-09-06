local root = require("config.root")

local function files(opts)
  require("fzf-lua").files(opts or {})
end

local function grep(opts)
  require("fzf-lua").live_grep(opts or {})
end

return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      files = {
        hidden = true,
        no_ignore = true,
      },
      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore --max-columns=4096 -e",
      },
    },
    keys = {
      { "<leader><space>", function() files({ cwd = root.get() }) end, desc = "Find Files (Root Dir)" },
      { "<leader>/", function() grep({ cwd = root.get() }) end, desc = "Grep (Root Dir)" },
      { "<leader>,", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
      { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
      { "<leader>fB", "<cmd>FzfLua buffers<cr>", desc = "Buffers (all)" },
      { "<leader>fc", function() files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff", function() files({ cwd = root.get() }) end, desc = "Find Files (Root Dir)" },
      { "<leader>fF", files, desc = "Find Files (cwd)" },
      { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
      { "<leader>fR", function() require("fzf-lua").oldfiles({ cwd = vim.uv.cwd() }) end, desc = "Recent (cwd)" },
      { "<leader>sg", function() grep({ cwd = root.get() }) end, desc = "Grep (Root Dir)" },
      { "<leader>sG", grep, desc = "Grep (cwd)" },
      { "<leader>sw", function() require("fzf-lua").grep_cword({ cwd = root.get() }) end, desc = "Word (Root Dir)" },
      { "<leader>sW", "<cmd>FzfLua grep_cword<cr>", desc = "Word (cwd)" },
      { "<leader>sw", function() require("fzf-lua").grep_visual({ cwd = root.get() }) end, mode = "x", desc = "Selection (Root Dir)" },
      { "<leader>sW", "<cmd>FzfLua grep_visual<cr>", mode = "x", desc = "Selection (cwd)" },
      { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
      { "<leader>s/", "<cmd>FzfLua search_history<cr>", desc = "Search History" },
      { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>FzfLua lines<cr>", desc = "Buffer Lines" },
      { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics" },
      { "<leader>sD", "<cmd>FzfLua diagnostics_document<cr>", desc = "Buffer Diagnostics" },
      { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
      { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
      { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
      { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Marks" },
      { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
      { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
      { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
      { "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Goto Symbol" },
      { "<leader>sS", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "Goto Symbol (Workspace)" },
      {
        "<leader>uC",
        function()
          require("fzf-lua").fzf_exec(require("config.themes").names(), {
            prompt = "Themes> ",
            actions = { ["default"] = function(selected) require("config.themes").apply(selected[1]) end },
          })
        end,
        desc = "Select Colorscheme",
      },
      { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Commits" },
      { "<leader>gd", "<cmd>FzfLua git_diff<cr>", desc = "Git Diff (files)" },
      { "<leader>gl", "<cmd>FzfLua git_commits<cr>", desc = "Commits" },
      { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Status" },
      { "<leader>gS", "<cmd>FzfLua git_stash<cr>", desc = "Git Stash" },
    },
  },
}
