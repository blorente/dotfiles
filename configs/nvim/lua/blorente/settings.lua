-- TODO
vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after runtimepath+=~/.config/nvim/lua
let &packpath=&runtimepath
source ~/.vimrc
]])

---------------------
-- Plugins augroup
---------------------
-- Autoformat buffers on write with Neoformat
-- TODO
vim.cmd([[
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
  
command NoAutoFormat autocmd!fmt 
]])
