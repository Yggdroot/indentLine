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
if !exists("g:indentLine_char")
    " | ┆ │
    let g:indentLine_char = "┆"
endif

set conceallevel=1
set concealcursor=inc

function! <SID>InitColor()
    if &bg == 'light'
        " ctermfg= 039, 234
        hi Conceal ctermfg=039 ctermbg=NONE guifg=Grey guibg=NONE
    else
        hi Conceal ctermfg=235 ctermbg=NONE guifg=Grey40 guibg=NONE
    endif
endfunction

function! <SID>SetIndentLine()
    for i in range(&shiftwidth+1, 100, &shiftwidth)
        exe 'syn match IndentLine /\(^\s\+\)\@<=\%'.i.'v / containedin=ALL conceal cchar=' . g:indentLine_char
    endfor
endfunction

autocmd BufRead * call <SID>SetIndentLine()
autocmd BufRead,ColorScheme * call <SID>InitColor()
