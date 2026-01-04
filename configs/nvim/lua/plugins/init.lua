return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Install color schemes
  { 'navarasu/onedark.nvim', name = "onedark" },
  { 
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme rose-pine]])
    end,
  },
  -- Switch to that color scheme

  -- Treesitter for nice syntax
  {
    'nvim-treesitter/nvim-treesitter', 
    build = ':TSUpdate',
    opts = {
      -- A list of parser names, or "all" (the five listed parsers should always be installed)
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "java", "go", "python", "starlark", "bash" },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,

      ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
      -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

      highlight = {
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },

      incremental_selection = {
        enable = true,
      }
    }
  },

  -- Harpoon
  { 
    'ThePrimeagen/harpoon',
    dependencies = { { 'nvim-lua/plenary.nvim' } }
  },

  -- nvim tree for fancy file navigation
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
  },

  -- Easy comments
  'numToStr/Comment.nvim',

--  -- LSP
--  use {
--    'VonHeikemen/lsp-zero.nvim',
--    branch = 'v4.x',
--    dependencies = {
--      -- LSP Support
--      { 'neovim/nvim-lspconfig' }, -- Required
--      {
--        -- Optional
--        'williamboman/mason.nvim',
--        run = function()
--          pcall(vim.cmd, 'MasonUpdate')
--        end,
--      },
--      { 'williamboman/mason-lspconfig.nvim' }, -- Optional
--
--      -- Autocompletion
--      { 'hrsh7th/nvim-cmp' },     -- Required
--      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
--      { 'L3MON4D3/LuaSnip' },     -- Required
--    }
--  }

  -- Debug startup time
  "dstein64/vim-startuptime",
  "stevearc/profile.nvim",

  -- Format on save
  "lukas-reineke/lsp-format.nvim",

  -- Better undos
  "mbbill/undotree",
}

