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
  local after = require("blorente.nvim-hack");
  local function lazy_toggle()
    after.setup()
    vim.cmd.NvimTreeFindFileToggle()
  end

  nnoremap("<leader>e", lazy_toggle)
  vnoremap("<leader>e", lazy_toggle)
end

M.NvimTree = NvimTree

function CHADTree()
  -- nnoremap("<leader>e", vim.cmd.CHADopen)
  -- vnoremap("<leader>e", vim.cmd.CHADopen)
end

M.CHADTree = CHADTree

function Telescope()
  local builtin = require('telescope.builtin')
  nnoremap('<leader>ff', builtin.git_files)
  nnoremap('<leader>fa', builtin.find_files)
  nnoremap('<leader>fg', builtin.live_grep)
end

M.Telescope = Telescope

function Comment()
  local comment = require('Comment.api')
  nnoremap('<leader>/', comment.toggle.linewise.current)
end

M.Comment = Telescope

return M
