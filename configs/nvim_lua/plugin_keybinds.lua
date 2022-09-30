function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end
function nnoremap(shortcut, command)
  map('n', shortcut, command)
end
function vnoremap(shortcut, command)
  map('v', shortcut, command)
end

-- Open Nerdtree
nnoremap("<Leader>tf", ":NvimTreeFindFile<CR>")
nnoremap("<Leader>tt", ":NvimTreeToggle<CR>")

-- Finding files
-- Telescope
nnoremap("<Leader>ff", ":GitFiles<CR>")
nnoremap("<Leader>fb", ":Telescope buffers<CR>")
nnoremap("<Leader>fi", ":Telescope current_buffer_fuzzy_find<CR>")
nnoremap("<Leader>fg", ":Telescope live_grep<CR>")

-- Harpoon
nnoremap("<Leader>fa", "<cmd>lua require('harpoon.mark').add_file()<CR>")
nnoremap("<Leader>fm", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>")
nnoremap("<Leader>fj", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>")
nnoremap("<Leader>fk", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>")
nnoremap("<Leader>fl", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>")

-- Auto Commenter mappings
nnoremap('<Leader>/', "<cmd>call nerdcommenter#Comment('n', 'toggle')<CR>") -- Toggle comments in current line
vnoremap('<Leader>/', "<cmd>call nerdcommenter#Comment('x', 'toggle')<CR>") -- Toggle comments in current line

-- LSP
nnoremap("K", "<cmd>lua vim.lsp.buf.hover()<CR>")
nnoremap("gR", "<cmd>lua vim.lsp.buf.rename()<CR>")
