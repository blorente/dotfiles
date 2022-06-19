colorscheme duskfox
set wrap
set scrolloff=999
set nonumber
set norelativenumber

autocmd BufNewFile,BufRead *.md ZenMode
autocmd BufWritePost *.md !pandoc -s %:p -o %:p.docx

lua <<EOF
  require("zen-mode").setup {
    window = {
      width = 60
    }
  }
EOF
