return {
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Install color schemes
  { 'navarasu/onedark.nvim', name = "onedark" },
  { 'tiagovla/tokyodark.nvim', name = "tokyodark"},
  { 'scottmckendry/cyberdream.nvim',
      name = "cyberdream",
      lazy = false,
      priority = 1000,
      opts = {
        transparent = true,
      },
  },
  { 
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
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
  {
    'numToStr/Comment.nvim',
    opts = {
      toggler = {
        line = "<leader>/",
      },
      opleader = {
        line = "<leader>/",
      },
    },
  },

--  -- LSP
  { 'mason-org/mason.nvim', opts = {} },

  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    opts = {},
    init = function()
      require("blorente.remaps").Lsp()
    end,
  },

  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = '1.*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      completion = {
        documentation = {
          auto_show = true,
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      signature = { enabled = true },
    },

    opts_extend = { 'sources.default' },
  },

  -- Debug startup time
  "dstein64/vim-startuptime",
  "stevearc/profile.nvim",

  -- Format on save
  "lukas-reineke/lsp-format.nvim",

  -- Better undos
  "mbbill/undotree",

  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- use latest release, remove to use latest commit
    ft = "markdown",
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false, -- this will be removed in the next major release
      workspaces = {
        {
          name = "notes",
          path = "~/notes",
        },
      },
    },
    config = function()
      vim.opt.conceallevel = 1
    end
  },
}

