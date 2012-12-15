" Script Name: indentLine.vim
" Version:     1.0.1
" Last Change: Dec 3, 2012
" Author:      Yggdroot <archofortune@gmail.com>
"
" Description: To show the indent line

if !has("conceal") || exists("g:loaded_indentLine")
    finish
endif 
let g:loaded_indentLine = 1

set conceallevel=2
set concealcursor=inc

function! <SID>InitColor()
    if &bg == 'light'
        hi Conceal ctermfg=7 ctermbg=NONE guifg=Grey guibg=NONE
    else
        hi Conceal ctermfg=8 ctermbg=NONE guifg=Grey40 guibg=NONE
    endif
endfunction

function! <SID>SetIndentLine()
    for i in range(&shiftwidth+1, 100, &shiftwidth)
        exe 'syn match IndentLine /\(^\s\+\)\@<=\%'.i.'v / containedin=ALL conceal cchar=|'
    endfor
endfunction

autocmd BufRead * call <SID>SetIndentLine()
autocmd BufRead,ColorScheme * call <SID>InitColor()
