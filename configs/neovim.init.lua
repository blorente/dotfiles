-- TODO
vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
]])

---------------------
-- Plugins
---------------------
require("plugins")

-- ----------------
-- Plugins settings
-- ----------------
-- Nerd Comment 
vim.g.NERDCreateDefaultMappings = 0 -- Dont create default mappings, define our own below

-- Telescope config
require("telescope")

-- Treesitter config
require("treesitter")

-- LSP
require("lsp")

-- Autocompletion config
vim.opt.completeopt = "menu,menuone,noselect"
require("cmp")

-- General LSP config
vim.lsp.set_log_level("debug")
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'G', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<Leader>gr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'go', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'gopls', 'bashls', 'rust_analyzer' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  }
end

-- Setup nvim-tree
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
require("nvim-tree").setup()

---------------------
-- Keybinds for Plugins
---------------------
require("plugin_keybinds")

---------------------
-- Plugins augroup
---------------------
-- Autoformat buffers on write with Neoformat
-- TODO
vim.cmd([[
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
  
command NoAutoFormat autocmd!fmt 
]])

---------------------
-- Color Scheme
---------------------
-- TODO
vim.cmd([[
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
]])
vim.cmd('colorscheme melange')
require('lualine').setup()
-- Enable Rainbow Brackets globally
vim.g.rainbow_active = 1

---------------------
-- Zen mode config
---------------------
require("zen-mode").setup {
  window = {
    width = 100,
  }
}

-- Set up nvim-project 
require('nvim-projectconfig').setup()

