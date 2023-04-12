require("obsidian").setup({
  dir = "~/notes",
  completion = {
    nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
  },
  daily_notes = {
    folder = "Diary"
  },
})
require('blorente.remaps').Obsidian()
