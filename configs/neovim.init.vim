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


" Install Nerdtree
Plug 'preservim/nerdtree'

" Fancy status lines
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Spaceduck theme
Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }
Plug 'bluz71/vim-moonfly-colors'

" Rainbow brackets
Plug 'frazrepo/vim-rainbow'

" Autoformatting
Plug 'sbdchd/neoformat'

" Plugin to enable commant shortcuts
Plug 'preservim/nerdcommenter'

" Get a terminal inside nvim
Plug 'akinsho/toggleterm.nvim'

" Treesitter, mainly for better syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
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
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier",
    },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" Toggleterm config
lua <<EOF
require("toggleterm").setup{
  open_mapping = [[<C-s>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true,
  direction = 'float',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
    border = 'double',
    winblend = 3,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
}
EOF

""""""""""""""""""""
" Keybinds for Plugins
""""""""""""""""""""

" Open Nerdtree
map <Leader>tf :NERDTreeFind<CR>
map <Leader>tt :NERDTreeToggle<CR>

" Finding files
:noremap <Leader>ff :Telescope find_files<CR>
:noremap <Leader>fb :Telescope buffers<CR>
:noremap <Leader>fg :Telescope live_grep<CR>

" Auto Commenter mappings
:nnoremap <Leader>/ :call nerdcommenter#Comment('n', 'toggle')<CR> " Toggle comments in current line
:vnoremap <Leader>/ :call nerdcommenter#Comment('x', 'toggle')<CR> " Toggle comments in current line

""""""""""""""""""""
" Plugins augroup
""""""""""""""""""""
" Autoformat buffers on write with Neoformat
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

""""""""""""""""""""
" Color Scheme
""""""""""""""""""""
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

colorscheme moonfly
let g:airline_theme = 'moonfly'

" Enable Rainbow Brackets globally
let g:rainbow_active = 1

