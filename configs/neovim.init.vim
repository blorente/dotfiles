set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc

""""""""""""""""""""
" Plugins
""""""""""""""""""""

" For now we use vim-plug (https://github.com/junegunn/vim-plug)
call plug#begin('~/.vim/my_plugins')

" Telescope for fuzzy finding
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" FZF because Telescope find_files is slow AF
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Install Nerdtree
Plug 'preservim/nerdtree'

" Fancy status lines
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Color themes
Plug 'pineapplegiant/spaceduck', { 'branch': 'main' } " Spaceduck
Plug 'bluz71/vim-moonfly-colors' " Moonfly
Plug 'EdenEast/nightfox.nvim' " Nightfox

" Rainbow brackets
Plug 'frazrepo/vim-rainbow'

" Autoformatting
Plug 'sbdchd/neoformat'

" Plugin to enable commant shortcuts
Plug 'preservim/nerdcommenter'

" Treesitter, mainly for better syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'cappyzawa/starlark.vim' " Ugly hack until treesitter gets a starlark parser.

" LSP Config for NVim
Plug 'neovim/nvim-lspconfig'

" Snippets (mostly a dep of completion for now)
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" Autocompletion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Harpoon
Plug 'nvim-lua/plenary.nvim' " don't forget to add this one if you don't have it yet!
Plug 'ThePrimeagen/harpoon'

" Per-project nvim configuration
Plug 'windwp/nvim-projectconfig'

" Zen Mode 
Plug 'folke/zen-mode.nvim'

" Vim in Firefox
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

" Vim pencil, for soft-wrapping prose.
Plug 'preservim/vim-pencil'

" For debugging startup time
Plug 'dstein64/vim-startuptime'
call plug#end() 

filetype plugin on

""""""""""""""""""""
" Plugins settings
""""""""""""""""""""
" Nerd Comment 
let g:NERDCreateDefaultMappings = 0 " Don't create default mappings, define our own below

" Telescope config
lua <<EOF
local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    preview = false,
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
  }
}
EOF

" Treesitter config
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

" LSP Config

" Add bazel-lsp as a server
lua <<EOF
-- Configure bazel-lsp server, a heavily modified version of 
--   https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/pyright.lua
local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local bazel_lsp_name = 'bazel'
local bazel_lsp_bin = 'bazel-lsp'
lspconfig = require 'lspconfig'

configs[bazel_lsp_name] = {
  default_config= {
    cmd = {bazel_lsp_bin},
    filetypes = {'bzl'},
    root_dir = function(fname)
       local root_files = {'WORKSPACE', 'workspace.bzl'}
       return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
     end,
     settings = {},
   },
   commands = {},
   docs = {},
}

-- Configure pyright, for python
lspconfig.pyright.setup{}

-- Configure gopls, for go
lspconfig.gopls.setup {
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  }

lspconfig.rust_analyzer.setup{
    on_attach = on_attach,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
      ["rust-analyzer"] = {}
    }
}
EOF

" Autocompletion config
set completeopt=menu,menuone,noselect

lua <<EOF
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args) vim.fn["vsnip#anonymous"](args.body) end
    },
    mapping = {
      ['<Tab>'] = cmp.mapping.confirm({ select = true }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-j>'] = {
            c = function(fallback)
                local cmp = require('cmp')
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end,
        },
        ['<C-k>'] = {
            c = function(fallback)
                local cmp = require('cmp')
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end,
        },
    },
    sources = {{ name = 'nvim_lsp' },
      { name = 'buffer' }
      }
  })

  -- When searching with `/`, use the buffer as a source for autocompletion.
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- When searching with `:`, use the vim path and the command line completions as a source for autocompletion.
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

EOF


" General LSP config
lua <<EOF
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

EOF


""""""""""""""""""""
" Keybinds for Plugins
""""""""""""""""""""

" Open Nerdtree
map <Leader>tf :NERDTreeFind<CR>
map <Leader>tt :NERDTreeToggle<CR>

" Finding files
" Telescope
:noremap <Leader>ff :GitFiles<CR>
:noremap <Leader>fb :Telescope buffers<CR>
:noremap <Leader>fi :Telescope current_buffer_fuzzy_find<CR>
:noremap <Leader>fg :Telescope live_grep<CR>

" Harpoon
:noremap <Leader>fa :lua require("harpoon.mark").add_file()<CR>
:noremap <Leader>fm :lua require("harpoon.ui").toggle_quick_menu()<CR>
:noremap <Leader>fj :lua require("harpoon.ui").nav_file(1)<CR>
:noremap <Leader>fk :lua require("harpoon.ui").nav_file(2)<CR>
:noremap <Leader>fl :lua require("harpoon.ui").nav_file(3)<CR>

" Auto Commenter mappings
:nnoremap <Leader>/ :call nerdcommenter#Comment('n', 'toggle')<CR> " Toggle comments in current line
:vnoremap <Leader>/ :call nerdcommenter#Comment('x', 'toggle')<CR> " Toggle comments in current line

" LSP
:nnoremap K :lua vim.lsp.buf.hover()<CR>
:nnoremap gR :lua vim.lsp.buf.rename()<CR>

""""""""""""""""""""
" Plugins augroup
""""""""""""""""""""
" Autoformat buffers on write with Neoformat
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
  
command NoAutoFormat autocmd!fmt 

""""""""""""""""""""
" Color Scheme
""""""""""""""""""""
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

colorscheme duskfox
let g:airline_theme = 'moonfly'

" Enable Rainbow Brackets globally
let g:rainbow_active = 1

""""""""""""""""""""
" Zen mode config
""""""""""""""""""""
lua <<EOF
  require("zen-mode").setup {
    window = {
      width = 100,
    }
  }
EOF

" Set up nvim-project 
lua << EOF
  require('nvim-projectconfig').setup()
EOF
