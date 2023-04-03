local M = {}
-- Requiring "nvim-tree" takes a fucking long time. So we lazy load it the first time.
-- Ideally, we would love to just require the bit that we need.
-- But that's not the world we live in.
local tree = nil
function setup()
  if tree == nil then
    tree = require("nvim-tree")
  end
  if not tree.is_setup then
    tree.setup({
      sort_by = "case_sensitive",
      hijack_netrw = true,
      disable_netrw = true,
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
      git = {
        enable = false,
      },
      log = {
        enable = true,
        truncate = false,
        types = {
          all = true,
          diagnostics = true,
          git = true,
          profile = true,
          watcher = true,
        },
      },
    })
  end
end

M.setup = setup


local remaps = require("blorente.remaps")
remaps.NvimTree()

vim.keymap.set("n", "<leader>nvs", function()
  print("Setting up nvimtree")
  setup()
  print("DOne")
end)

return M
