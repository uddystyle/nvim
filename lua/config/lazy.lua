local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to bootstrap lazy.nvim:\n" .. output)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  -- Keep lazy.nvim's runtime state out of this configuration repository.
  lockfile = vim.env.NVIM_STANDALONE_TEST == "1" and vim.fn.stdpath("data") .. "/lazy-lock.json"
    or vim.fn.stdpath("state") .. "/lazy-lock.json",
  defaults = { lazy = true, version = false },
  install = { missing = vim.env.NVIM_STANDALONE_TEST ~= "1" },
  checker = { enabled = true },
  change_detection = { notify = false },
  performance = {
    rtp = {
      reset = true,
      disabled_plugins = { "gzip", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
