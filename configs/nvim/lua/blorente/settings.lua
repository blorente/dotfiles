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
  autocmd BufWritePre * undojoin | lua vim.lsp.buf.format()
  autocmd BufWritePre <buffer> undojoin | lua vim.lsp.buf.format()
augroup END
  
command NoAutoFormat autocmd!fmt 
]])
