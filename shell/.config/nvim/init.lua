vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
local base46_defaults = vim.g.base46_cache .. "defaults"
local base46_statusline = vim.g.base46_cache .. "statusline"
if vim.uv.fs_stat(base46_defaults) then
  dofile(base46_defaults)
end
if vim.uv.fs_stat(base46_statusline) then
  dofile(base46_statusline)
end

require("options")
require("nvchad.autocmds")

vim.schedule(function()
  require("mappings")
end)

-- Auto-open nvim-tree if it's available
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("NvimTreeFocus")
  end,
  desc = "Open nvim-tree if it's available",
})
