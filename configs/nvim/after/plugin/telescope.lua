local builtin = require('telescope.builtin')

local remaps = require("blorente.remaps")
remaps.Telescope()

-- Disable folding in telescope's result window
vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults", command = [[setlocal nofoldenable]]
})
