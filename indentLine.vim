" Script Name: indentLine.vim
" Version:     1.0.0
" Last Change: Oct 20, 2012
" Author:      Yggdroot <archofortune@gmail.com>
"
" Description: To show the indent line

if !has("conceal") || exists("g:loaded_indentLine")
    finish
endif 
let g:loaded_indentLine = 1

if (has("gui_running"))
    hi Conceal      guifg=grey guibg=bg
else
    hi Conceal      ctermfg=8 
endif

set conceallevel=2
set concealcursor=inc

function! SetIndentLine()
    for i in range(&shiftwidth+1, 100, &shiftwidth)
        exe 'syn match IndentLine /\(^\s\+\)\@<=\%'.i.'v / containedin=ALL conceal cchar=|'
    endfor
endfunction

autocmd BufRead * call SetIndentLine()
autocmd ColorScheme * hi Conceal  guifg=grey guibg=bg ctermfg=8
