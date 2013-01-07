" Script Name: indentLine.vim
" Version:     1.0.3
" Last Change: Dec 25, 2012
" Author:      Yggdroot <archofortune@gmail.com>
"
" Description: To show the indent line

if !has("conceal") || exists("g:loaded_indentLine")
    finish
endif
let g:loaded_indentLine = 1

if !exists("g:indentLine_char")
    " | ¦ ┆  │
    if &encoding ==? "utf-8"
        let g:indentLine_char = "¦"
    else
        let  g:indentLine_char = "|"
    endif
endif

if !exists("g:indentLine_indentLevel")
    let g:indentLine_indentLevel = 20
endif

set conceallevel=1
set concealcursor=inc

function! <SID>InitColor()
    if !exists("g:indentLine_color_term")
        if &bg ==? "light"
            let term_color = 238
        else
            let term_color = 039
        endif
    else
        let term_color = g:indentLine_color_term
    endif

    if !exists("g:indentLine_color_gui")
        if &bg ==? "light"
            let gui_color = "Grey65"
        else
            let gui_color = "Grey40"
        endif
    else
        let gui_color = g:indentLine_color_gui
    endif

    exec "hi Conceal ctermfg=" . term_color . " ctermbg=NONE"
    exec "hi Conceal guifg=" . gui_color .  " guibg=NONE"
endfunction

function! <SID>SetIndentLine()
    let space = &l:shiftwidth
    for i in range(space+1, space * g:indentLine_indentLevel + 1, space)
        exec 'syn match IndentLine /\(^\s\+\)\@<=\%'.i.'v / containedin=ALL conceal cchar=' . g:indentLine_char
    endfor
endfunction

function! <SID>ResetWidth(...)
    if a:0 > 0
        let &l:shiftwidth = a:1
    endif
    syn clear IndentLine
    call <SID>SetIndentLine()
endfunction

autocmd BufRead * call <SID>SetIndentLine()
autocmd BufRead,ColorScheme * call <SID>InitColor()
command! -nargs=? ResetIndentLines call <SID>ResetWidth(<f-args>)

" vim:et:ts=4:sw=4:fdm=marker:fmr={{{,}}}
