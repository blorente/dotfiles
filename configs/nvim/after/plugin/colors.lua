function ColorMyPencils(color)
  color = color or "rose-pine"

  -- If we wanted to modify the color scheme, it would be here.
  require('onedark').setup {
    style = 'darker'
  }

  vim.cmd.colorscheme(color)
end

ColorMyPencils("cyberdream")
