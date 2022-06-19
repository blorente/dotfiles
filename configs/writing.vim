colorscheme duskfox
set wrap
set scrolloff=999
set nonumber
set cmdheight=1 " One line for command output
set norelativenumber

autocmd BufNewFile,BufRead *.md ZenMode
autocmd BufNewFile,BufRead *.md PencilSoft
autocmd BufWritePost *.md !pandoc -s %:p -o %:p.docx

lua <<EOF
  require("zen-mode").setup {
    window = {
      width = 70
    }
  }
EOF
