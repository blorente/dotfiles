set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc

""""""""""""""""""""
" Plugins
""""""""""""""""""""

" For now we use vim-plug (https://github.com/junegunn/vim-plug)
call plug#begin('~/.vim/my_plugins')
" Ripgrep integration
Plug 'jremmen/vim-ripgrep'


" fzf - Find files easily
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Install Nerdtree
Plug 'preservim/nerdtree'

" Fancy status lines
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Spaceduck theme
Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }

" Rainbow brackets
Plug 'frazrepo/vim-rainbow'

" Autoformatting
Plug 'sbdchd/neoformat'

" Plugin to enable commant shortcuts
Plug 'preservim/nerdcommenter'

call plug#end() 

filetype plugin on

""""""""""""""""""""
" Plugins settings
""""""""""""""""""""
let g:NERDCreateDefaultMappings = 0 " Don't create default mappings, define our own below

""""""""""""""""""""
" Keybinds for Plugins
""""""""""""""""""""

" Open Nerdtree
map <Leader>t :NERDTreeFind<CR>

" Map fzf to Leader-f
:nnoremap <Leader>f :GitFiles<CR>

" Auto Commenter mappings
:nnoremap <Leader>/ :call NERDComment(0, 'toggle')<CR> " Toggle comments in current line

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

colorscheme spaceduck
let g:airline_theme = 'spaceduck'

" Enable Rainbow Brackets globally
let g:rainbow_active = 1

