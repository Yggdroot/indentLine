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
if !exists("g:indentLine_color_term")
    if &bg =~? "light"
        let g:indentLine_color_term = 238
    else
        let g:indentLine_color_term = 039
    endif
endif
if !exists("g:indentLine_color_gui")
    if &bg =~? "light"
        let g:indentLine_color_gui = "Grey"
    else
        let g:indentLine_color_gui = "Grey40"
    endif
endif

if !exists("g:indentLine_indentLevel")
    let g:indentLine_indentLevel = 10
endif

set conceallevel=1
set concealcursor=inc

function! <SID>InitColor()
    exec "hi Conceal ctermfg=" . g:indentLine_color_term . " ctermbg=NONE cterm=bold" .
                \ " guifg=" . g:indentLine_color_gui .  " guibg=NONE"
endfunction

function! <SID>SetIndentLine()
    let space = &l:shiftwidth
    for i in range(space+1, space * g:indentLine_indentLevel + 1, space)
        exec 'syn match IndentLine /\(^\s\+\)\@<=\%'.i.'v / containedin=ALL conceal cchar=' . g:indentLine_char
    endfor
endfunction

autocmd BufRead * call <SID>SetIndentLine()
autocmd BufRead,ColorScheme * call <SID>InitColor()
