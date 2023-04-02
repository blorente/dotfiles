local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
-- vim.keymap.set("n", "<leader>hm", ui.toogle_quick_menu)
