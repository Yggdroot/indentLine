" Script Name: indentLine.vim
" Author:      Yggdroot <archofortune@gmail.com>
"
" Description: To show the indention levels with thin vertical lines

scriptencoding utf-8

if ! has("conceal") || exists("g:indentLine_loaded")
    finish
endif
let g:indentLine_loaded = 1


let g:indentLine_char = get(g:,'indentLine_char',(&encoding is# "utf-8" && &term isnot# "linux" ? '¦' : '|'))
let g:indentLine_first_char = get(g:,'indentLine_first_char',(&encoding is# "utf-8" && &term isnot# "linux"  ? '¦' : '|'))
let g:indentLine_indentLevel = get(g:,'indentLine_indentLevel',10)
let g:indentLine_enabled = get(g:,'indentLine_enabled',1)
let g:indentLine_fileType = get(g:,'indentLine_fileType',[])
let g:indentLine_fileTypeExclude = get(g:,'indentLine_fileTypeExclude',[])
let g:indentLine_bufNameExclude = get(g:,'indentLine_bufNameExclude',[])
let g:indentLine_showFirstIndentLevel = get(g:,'indentLine_showFirstIndentLevel',0)
let g:indentLine_maxLines = get(g:,'indentLine_maxLines',3000)
let g:indentLine_setColors = get(g:,'indentLine_setColors',1)
let g:indentLine_faster = get(g:,'indentLine_faster',0)

"{{{1 function! s:InitColor()
function! s:InitColor()
    if ! g:indentLine_setColors
        return
    endif

    if ! exists("g:indentLine_color_term")
        if &background is# "light"
            let term_color = 249
        else
            let term_color = 239
        endif
    else
        let term_color = g:indentLine_color_term
    endif

    if ! exists("g:indentLine_color_gui")
        if &background is# "light"
            let gui_color = "Grey70"
        else
            let gui_color = "Grey30"
        endif
    else
        let gui_color = g:indentLine_color_gui
    endif

    execute "highlight Conceal ctermfg=" . term_color . " ctermbg=NONE"
    execute "highlight Conceal guifg=" . gui_color .  " guibg=NONE"

    if &term is# "linux"
        if &background is# "light"
            let tty_color = exists("g:indentLine_color_tty_light") ? g:indentLine_color_tty_light : 4
        else
            let tty_color = exists("g:indentLine_color_tty_dark") ? g:indentLine_color_tty_dark : 2
        endif
        execute "highlight Conceal cterm=bold ctermfg=" . tty_color .  " ctermbg=NONE"
    endif
endfunction

"{{{1 function! s:SetIndentLine()
function! s:SetIndentLine()
    let b:indentLine_enabled = 1
    let space = &l:shiftwidth is 0 ? &l:tabstop : &l:shiftwidth

    if g:indentLine_showFirstIndentLevel
        execute 'syntax match IndentLine /^ / containedin=ALL conceal cchar=' . g:indentLine_first_char
    endif

    if g:indentLine_faster
        execute 'syntax match IndentLineSpace /^\s\+/ containedin=ALL contains=IndentLine'
        execute 'syntax match IndentLine / \{'.(space-1).'}\zs / contained conceal cchar=' . g:indentLine_char
        execute 'syntax match IndentLine /\t\zs / contained conceal cchar=' . g:indentLine_char
    else
        let pattern = line('$') < g:indentLine_maxLines ? 'v' : 'c'
        for i in range(space+1, space * g:indentLine_indentLevel + 1, space)
            execute 'syntax match IndentLine /\%(^\s\+\)\@<=\%'.i.pattern.' / containedin=ALL conceal cchar=' . g:indentLine_char
        endfor
    endif
endfunction

"{{{1 function! s:ResetWidth(...)
function! s:ResetWidth(...)
    if 0 < a:0
        let &l:shiftwidth = a:1
    endif

    if exists("b:indentLine_enabled")
        syntax clear IndentLine
    endif
    call s:SetIndentLine()
endfunction

"{{{1 function! s:IndentLinesEnable()
function! s:IndentLinesEnable()
    call s:SetIndentLine()
endfunction

"{{{1 function! s:IndentLinesDisable()
function! s:IndentLinesDisable()
    let b:indentLine_enabled = 0
    syntax clear IndentLine
endfunction

"{{{1 function! s:IndentLinesToggle()
function! s:IndentLinesToggle()
    if ! exists("b:indentLine_enabled")
        let b:indentLine_enabled = 0
    endif

    if b:indentLine_enabled
        call s:IndentLinesDisable()
    else
        call s:IndentLinesEnable()
    endif
endfunction

"{{{1 function! s:Setup()
function! s:Setup()
    if index(g:indentLine_fileTypeExclude, &filetype) isnot -1
        return
    endif

    if len(g:indentLine_fileType) isnot 0 && index(g:indentLine_fileType, &filetype) is -1
        return
    end

    for name in g:indentLine_bufNameExclude
        if matchstr(bufname(''), name) is bufname('')
            return
        endif
    endfor

    if ! exists("b:indentLine_bufNr")
        let b:indentLine_bufNr = bufnr('%')
        let g:indentLine_bufNr = bufnr('%')
    elseif g:indentLine_bufNr != bufnr('%') && &hidden
        let g:indentLine_bufNr = bufnr('%')
        return
    endif

    if ! exists("g:indentLine_noConcealCursor")
        setlocal concealcursor=inc
    endif
    setlocal conceallevel=2

    if &filetype is# ""
        call s:InitColor()
    endif

    if ! exists("b:indentLine_enabled")
        let b:indentLine_enabled = g:indentLine_enabled
    endif

    if b:indentLine_enabled
        call s:SetIndentLine()
    endif
endfunction

"{{{1 augroup indentLine
augroup indentLine
    autocmd!
    autocmd BufWinEnter * call <SID>Setup()
    autocmd BufRead,BufNewFile,ColorScheme,Syntax * call <SID>InitColor()
augroup END

"{{{1 commands
command! -nargs=? IndentLinesReset call <SID>ResetWidth(<f-args>)
command! IndentLinesToggle call <SID>IndentLinesToggle()
command! IndentLinesEnable call <SID>IndentLinesEnable()
command! IndentLinesDisable call <SID>IndentLinesDisable()

" vim:et:ts=4:sw=4:fdm=marker:fmr={{{,}}}

