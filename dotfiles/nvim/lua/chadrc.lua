-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "aylin",

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

-- vim.g.copilot_assume_mapped = true

vim.filetype.add({
  pattern = {
    ["Dockerfile*"] = "dockerfile",
    ["Brewfile"] = "ruby",
    [".aliases"] = "bash",
    [".functions"] = "bash",
  },
})

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
--}

return M
