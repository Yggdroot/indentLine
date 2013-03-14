" Script Name: indentLine.vim
" Version:     1.0.5
" Last Change: March 5, 2013
" Author:      Yggdroot <archofortune@gmail.com>
"
" Description: To show the indent lines

"{{{1 global variables
if !has("conceal") || exists("g:indentLine_loaded")
    finish
endif
let g:indentLine_loaded = 1

" | ¦ ┆  │
if !exists("g:indentLine_char")
    if &encoding ==? "utf-8"
        let g:indentLine_char = "¦"
    else
        let  g:indentLine_char = "|"
    endif
endif

if !exists("g:indentLine_indentLevel")
    let g:indentLine_indentLevel = 10
endif

if !exists("g:indentLine_enabled")
    let g:indentLine_enabled = 1
endif

if !exists("g:indentLine_fileType")
    let g:indentLine_fileType = []
endif

if !exists("g:indentLine_fileTypeExclude")
    let g:indentLine_fileTypeExclude = []
endif

if !exists("g:indentLine_showFirstIndentLevel")
    let g:indentLine_showFirstIndentLevel = 0
endif

set conceallevel=1
set concealcursor=inc

"{{{1 function! <SID>InitColor()
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

"{{{1 function! <SID>SetIndentLine()
function! <SID>SetIndentLine()
    let b:indentLine_enabled = 1
    let space = &l:shiftwidth

    if g:indentLine_showFirstIndentLevel
        exec 'syn match IndentLine /^ / containedin=ALL conceal cchar=' . g:indentLine_char
    endif

    for i in range(space+1, space * g:indentLine_indentLevel + 1, space)
        exec 'syn match IndentLine /\(^\s\+\)\@<=\%'.i.'v / containedin=ALL conceal cchar=' . g:indentLine_char
    endfor
endfunction

"{{{1 function! <SID>ResetWidth(...)
function! <SID>ResetWidth(...)
    if a:0 > 0
        let &l:shiftwidth = a:1
    endif

    if exists("b:indentLine_enabled")
        syn clear IndentLine
    endif
    call <SID>SetIndentLine()
endfunction

"{{{1 function! <SID>IndentLinesToggle()
function! <SID>IndentLinesToggle()
    if !exists("b:indentLine_enabled")
        let b:indentLine_enabled = 0
    endif

    if b:indentLine_enabled
        let b:indentLine_enabled = 0
        syn clear IndentLine
    else
        call <SID>SetIndentLine()
    endif
endfunction

"{{{1 function! <SID>Setup()
function! <SID>Setup()
    if !getbufvar("%","&hidden") || !exists("b:indentLine_set")
        let b:indentLine_set = 1

        if index(g:indentLine_fileTypeExclude, &ft) != -1
            return
        endif

        if len(g:indentLine_fileType) != 0 && index(g:indentLine_fileType, &ft) == -1
            return
        end

        if !exists("b:indentLine_enabled")
            let b:indentLine_enabled = g:indentLine_enabled
        endif

        if b:indentLine_enabled
            call <SID>SetIndentLine()
        endif

        if &ft == ""
            call <SID>InitColor()
        endif
    endif
endfunction

"{{{1 commands
autocmd BufWinEnter * call <SID>Setup()
autocmd BufRead,ColorScheme * call <SID>InitColor()

command! -nargs=? IndentLinesReset call <SID>ResetWidth(<f-args>)
command! IndentLinesToggle call <SID>IndentLinesToggle()

" vim:et:ts=4:sw=4:fdm=marker:fmr={{{,}}}
