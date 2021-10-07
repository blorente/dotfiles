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

call plug#end()

""""""""""""""""""""
" Keybinds for Plugins
""""""""""""""""""""

" Open Nerdtree
map <Leader>t :NERDTreeFind<CR>

" Map fzf to Leader-f
:nnoremap <Leader>f :GitFiles<CR>

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

