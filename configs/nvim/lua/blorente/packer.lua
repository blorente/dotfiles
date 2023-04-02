vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Rose pine color scheme
  use({ 'rose-pine/neovim', as = 'rose-pine' })
  -- Switch to that color scheme
  vim.cmd('colorscheme rose-pine')

  -- Treesitter for nice syntax
  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate'})
  use('nvim-treesitter/playground')

  -- Harpoon
  use('theprimeagen/harpoon')

  -- nvim tree for fancy file navigation
  use {
	  'nvim-tree/nvim-tree.lua',
	  requires = {
		  'nvim-tree/nvim-web-devicons', -- optional
	  },
	  config = function()
		  require("nvim-tree").setup {}
	  end
  }
end)
