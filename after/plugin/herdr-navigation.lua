-- SPDX-License-Identifier: MIT
-- Derived from paulbkim-dev/vim-herdr-navigation at
-- 79679dacc791f70fc34de8b29a3cf9706c0f5b2f (Copyright 2026 Paul B. Kim).

local function navigate(window_command, direction)
  local previous_window = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. window_command)
  if vim.api.nvim_get_current_win() ~= previous_window then
    return
  end

  local pane = vim.env.HERDR_PANE_ID
  if pane and pane ~= "" then
    local herdr = vim.env.HERDR_BIN_PATH
    if not herdr or herdr == "" then
      herdr = "herdr"
    end
    vim.fn.system({ herdr, "pane", "focus", "--direction", direction, "--pane", pane })
  elseif vim.env.TMUX and vim.env.TMUX ~= "" then
    local tmux_directions = { left = "Left", down = "Down", up = "Up", right = "Right" }
    pcall(vim.cmd, "TmuxNavigate" .. tmux_directions[direction])
  end
end

local function map(key, window_command, direction)
  vim.keymap.set("n", key, function()
    navigate(window_command, direction)
  end, { silent = true, noremap = true, desc = "Navigate " .. direction .. " (Vim/Herdr)" })
end

map("<C-h>", "h", "left")
map("<C-j>", "j", "down")
map("<C-k>", "k", "up")
map("<C-l>", "l", "right")
