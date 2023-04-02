function ColorMyPencils(color)
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)

  -- If we wanted to modify the color scheme, it would be here.
end

ColorMyPencils()
