return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  -- Rose pine color scheme
  use({ 'rose-pine/neovim', as = 'rose-pine' })
  -- Switch to that color scheme
  vim.cmd('colorscheme rose-pine')

  -- Treesitter for nice syntax
  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
  use('nvim-treesitter/playground')
  -- Expand selection to code objects
  use { 'RRethy/nvim-treesitter-textsubjects',
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  }

  -- Harpoon
  use('theprimeagen/harpoon')

  -- nvim tree for fancy file navigation
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
  }

  -- Easy comments
  use {
    'numToStr/Comment.nvim',
  }

  -- LSP out of the box?
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      { -- Optional
        'williamboman/mason.nvim',
        run = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' }, -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'L3MON4D3/LuaSnip' }, -- Required
    }
  }

  -- Debug startup time
  use("dstein64/vim-startuptime")
  use("stevearc/profile.nvim")

  -- Format on save
  use("lukas-reineke/lsp-format.nvim")

  -- Better git maybe
  use("tpope/vim-fugitive")

end)
