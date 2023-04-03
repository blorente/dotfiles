local comment = require('Comment')
comment.setup({
  toggler = {
    line = "<leader>/",
  },
  opleader = {
    line = "<leader>/",
  }
})

local remaps = require("blorente.remaps")
remaps.Comment()
