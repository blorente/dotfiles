function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end
function nnoremap(shortcut, command)
  map('n', shortcut, command)
end
function vnoremap(shortcut, command)
  map('v', shortcut, command)
end

vim.g.mapleader = " "
nnoremap("<leader>w", ":w<CR>")
