" Script Name: indentLine.vim
" Version:     1.0.4
" Last Change: Jan 23, 2013
" Author:      Yggdroot <archofortune@gmail.com>
"
" Description: To show the indent lines

if !has("conceal") || exists("g:indentLine_loaded")
    finish
endif
let g:indentLine_loaded = 1

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

if !exists("g:indentLine_enabled")
    let g:indentLine_enabled = 1
endif

set conceallevel=1
set concealcursor=inc

function! <SID>InitColor()
    if !exists("g:indentLine_color_term")
        if &bg ==? "light"
            let term_color = 249
        else
            let term_color = 239
        endif
    else
        let term_color = g:indentLine_color_term
    endif

    if !exists("g:indentLine_color_gui")
        if &bg ==? "light"
            let gui_color = "Grey70"
        else
            let gui_color = "Grey30"
        endif
    else
        let gui_color = g:indentLine_color_gui
    endif

    exec "hi Conceal ctermfg=" . term_color . " ctermbg=NONE"
    exec "hi Conceal guifg=" . gui_color .  " guibg=NONE"
endfunction

function! <SID>SetIndentLine()
    if !exists("b:indentLine_enabled")
        let b:indentLine_enabled = g:indentLine_enabled
    endif

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

function! <SID>IndentLinesToggle()
    if b:indentLine_enabled
        let b:indentLine_enabled = 0
        syn clear IndentLine
    else
        let b:indentLine_enabled = 1
        call <SID>SetIndentLine()
    endif
endfunction

function! <SID>Setup()
    if !exists("b:indentLine_set")
        let b:indentLine_set = 1
        call <SID>SetIndentLine()
    endif
endfunction

autocmd BufWinEnter * call <SID>Setup()
autocmd BufRead,ColorScheme * call <SID>InitColor()

command! -nargs=? IndentLinesReset call <SID>ResetWidth(<f-args>)
command! IndentLinesToggle call <SID>IndentLinesToggle()

" vim:et:ts=4:sw=4:fdm=marker:fmr={{{,}}}
