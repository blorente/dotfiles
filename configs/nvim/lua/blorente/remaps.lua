function map(mode, shortcut, command)
  vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true })
end

function nnoremap(shortcut, command)
  map('n', shortcut, command)
end

function vnoremap(shortcut, command)
  map('v', shortcut, command)
end

vim.g.mapleader = " "

-- Write easy
nnoremap("<leader>w", ":w<CR>")
vnoremap("<leader>w", ":w<CR>")

-- leader-y to copy to clipboard.
nnoremap("<leader>y", "\"+y")
vnoremap("<leader>y", "\"+y")
nnoremap("<leader>Y", "\"+Y")

-- leader-d to delete to the void
-- (and not the clipboard)
nnoremap("<leader>d", "\"_d")
vnoremap("<leader>d", "\"_d")

-- Plugin Remaps

local M = {}

function Lsp()
  nnoremap("<leader>la", vim.lsp.buf.code_action)
end

M.Lsp = Lsp

function NvimTree()
  nnoremap("<leader>e", vim.cmd.NvimTreeFindFileToggle)
  vnoremap("<leader>e", vim.cmd.NvimTreeFindFileToggle)
end

M.NvimTree = NvimTree

function CHADTree()
  nnoremap("<leader>e", vim.cmd.CHADopen)
  vnoremap("<leader>e", vim.cmd.CHADopen)
end

M.CHADTree = CHADTree

function Telescope()
  local builtin = require('telescope.builtin')
  nnoremap('<leader>ff', builtin.git_files)
  nnoremap('<leader>fa', builtin.find_files)
  nnoremap('<leader>fg', builtin.live_grep)
end

M.Telescope = Telescope

return M
