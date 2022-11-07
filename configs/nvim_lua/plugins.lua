-- For now we use vim-plug (https://github.com/junegunn/vim-plug)
local Plug = vim.fn["plug#"]
vim.call('plug#begin', '~/.vim/my_plugins')

-- Telescope for fuzzy finding
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('nvim-telescope/telescope-fzy-native.nvim')

-- FZF because Telescope find_files is slow AF
Plug('junegunn/fzf', { ['do'] = vim.fn["fzf#install()"] })
Plug('junegunn/fzf.vim')

-- Nerdtree equivalent
Plug('kyazdani42/nvim-web-devicons') -- optional, for file icons
Plug('kyazdani42/nvim-tree.lua')

-- Fancy status lines
Plug('nvim-lualine/lualine.nvim')

-- Color themes
Plug('pineapplegiant/spaceduck', { branch = 'main' }) -- Spaceduck
--Plug('bluz71/vim-moonfly-colors') -- Moonfly
--Plug('EdenEast/nightfox.nvim') -- Nightfox
Plug('savq/melange') -- Melange

-- Rainbow brackets
Plug('frazrepo/vim-rainbow')

-- Autoformatting
Plug('sbdchd/neoformat')

-- Plugin to enable commant shortcuts
Plug('preservim/nerdcommenter')

-- Treesitter, mainly for better syntax highlighting
Plug('nvim-treesitter/nvim-treesitter')
Plug('nvim-treesitter/playground')
Plug('cappyzawa/starlark.vim') -- Ugly hack until treesitter gets a starlark parser.

-- LSP Config for NVim
Plug('neovim/nvim-lspconfig')

-- Snippets (mostly a dep of completion for now)
-- Plug('L3MON4D3/LuaSnip')
-- Plug('saadparwaiz1/cmp_luasnip')

-- Autocompletion
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')

-- Harpoon
Plug('ThePrimeagen/harpoon')

-- Per-project nvim configuration
Plug('windwp/nvim-projectconfig')

-- Zen Mode 
Plug('folke/zen-mode.nvim')

-- Vim in Firefox
Plug('glacambre/firenvim', { ['do'] = vim.fn['firenvim#install(0)'] })

-- Vim pencil, for soft-wrapping prose.
Plug('preservim/vim-pencil')

-- For debugging startup time
Plug('dstein64/vim-startuptime')

vim.call('plug#end')
