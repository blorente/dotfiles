vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
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

  -- Harpoon
  use('theprimeagen/harpoon')

  -- nvim tree for fancy file navigation
  --  use {
  --    'nvim-tree/nvim-tree.lua',
  --    requires = {
  --      'nvim-tree/nvim-web-devicons', -- optional
  --    },
  --    config = function()
  --      require("nvim-tree").setup {}
  --    end
  --  }
  -- Until I figure out the speed hiccups with neovim-tree
  use("ms-jpq/chadtree", { run = ":CHADdeps" })

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

  -- Format on save
  use("lukas-reineke/lsp-format.nvim")
end)
