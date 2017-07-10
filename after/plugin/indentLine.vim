" Script Name: indentLine.vim
" Author:      Yggdroot <archofortune@gmail.com>
"
" Description: To show the indention levels with thin vertical lines

scriptencoding utf-8

if !has("conceal") || exists("g:indentLine_loaded")
    finish
endif
let g:indentLine_loaded = 1

let g:indentLine_newVersion = get(g:,'indentLine_newVersion',v:version > 704 || v:version == 704 && has("patch792"))

let g:indentLine_char = get(g:, 'indentLine_char', (&encoding ==# "utf-8" && &term isnot# "linux" ? '¦' : '|'))
let g:indentLine_first_char = get(g:, 'indentLine_first_char', (&encoding ==# "utf-8" && &term isnot# "linux" ? '¦' : '|'))
let g:indentLine_indentLevel = get(g:, 'indentLine_indentLevel', 20)
let g:indentLine_enabled = get(g:, 'indentLine_enabled', 1)
let g:indentLine_fileType = get(g:, 'indentLine_fileType', [])
let g:indentLine_fileTypeExclude = get(g:, 'indentLine_fileTypeExclude', [])
let g:indentLine_bufNameExclude = get(g:, 'indentLine_bufNameExclude', [])
let g:indentLine_showFirstIndentLevel = get(g:, 'indentLine_showFirstIndentLevel', 0)
let g:indentLine_maxLines = get(g:, 'indentLine_maxLines', 3000)
let g:indentLine_setColors = get(g:, 'indentLine_setColors', 1)
let g:indentLine_setConceal = get(g:, 'indentLine_setConceal', 1)
let g:indentLine_faster = get(g:, 'indentLine_faster', 0)
let g:indentLine_leadingSpaceChar = get(g:, 'indentLine_leadingSpaceChar', (&encoding ==# "utf-8" && &term isnot# "linux" ? '˰' : '.'))
let g:indentLine_leadingSpaceEnabled = get(g:, 'indentLine_leadingSpaceEnabled', 0)
let g:indentLine_mysyntaxfile = fnamemodify(expand("<sfile>"), ":p:h:h")."/syntax/indentLine.vim"

"{{{1 function! s:InitColor()
function! s:InitColor()
    if !g:indentLine_setColors
        return
    endif

    if !exists("g:indentLine_color_term")
        if &background ==# "light"
            let term_color = 249
        else
            let term_color = 239
        endif
    else
        let term_color = g:indentLine_color_term
    endif

    if !exists("g:indentLine_color_gui")
        if &background ==# "light"
            let gui_color = "Grey70"
        else
            let gui_color = "Grey30"
        endif
    else
        let gui_color = g:indentLine_color_gui
    endif

    execute "highlight Conceal cterm=NONE ctermfg=" . term_color . " ctermbg=NONE"
    execute "highlight Conceal gui=NONE guifg=" . gui_color .  " guibg=NONE"

    if &term ==# "linux"
        if &background ==# "light"
            let tty_color = exists("g:indentLine_color_tty_light") ? g:indentLine_color_tty_light : 4
        else
            let tty_color = exists("g:indentLine_color_tty_dark") ? g:indentLine_color_tty_dark : 2
        endif
        execute "highlight Conceal cterm=bold ctermfg=" . tty_color .  " ctermbg=NONE"
    endif
endfunction

"{{{1 function! s:SetConcealOption()
function! s:SetConcealOption()
    if !g:indentLine_setConceal
        return
    endif
    if !exists("b:indentLine_ConcealOptionSet")
        let b:indentLine_ConcealOptionSet = 1
        let &l:concealcursor = exists("g:indentLine_concealcursor") ? g:indentLine_concealcursor : "inc"
        let &l:conceallevel = exists("g:indentLine_conceallevel") ? g:indentLine_conceallevel : "2"
    endif
endfunction

"{{{1 function! s:IndentLinesEnable()
function! s:IndentLinesEnable()
    if g:indentLine_newVersion
        if &diff
            return
        endif

        if exists("b:indentLine_enabled") && b:indentLine_enabled == 0
            return
        endif

        if !exists("w:indentLine_indentLineId")
            let w:indentLine_indentLineId = []
        endif

        call s:SetConcealOption()

        if g:indentLine_showFirstIndentLevel
            call add(w:indentLine_indentLineId, matchadd('Conceal', '^ ', 0, -1, {'conceal': g:indentLine_first_char}))
        endif

        let space = &l:shiftwidth == 0 ? &l:tabstop : &l:shiftwidth
        for i in range(space+1, space * g:indentLine_indentLevel + 1, space)
            call add(w:indentLine_indentLineId, matchadd('Conceal', '^\s\+\zs\%'.i.'v ', 0, -1, {'conceal': g:indentLine_char}))
        endfor

        return
    endif

    if exists("b:indentLine_enabled") && b:indentLine_enabled
        return
    else
        let b:indentLine_enabled = 1
    endif

    call s:SetConcealOption()

    let g:mysyntaxfile = g:indentLine_mysyntaxfile

    let space = &l:shiftwidth == 0 ? &l:tabstop : &l:shiftwidth

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

"{{{1 function! s:IndentLinesDisable()
function! s:IndentLinesDisable()
    if g:indentLine_newVersion
        if exists("w:indentLine_indentLineId") && ! empty(w:indentLine_indentLineId)
            for id in w:indentLine_indentLineId
                try
                    call matchdelete(id)
                catch /^Vim\%((\a\+)\)\=:E80[23]/
                endtry
            endfor
            let w:indentLine_indentLineId = []
        endif

        return
    endif

    let b:indentLine_enabled = 0
    try
        syntax clear IndentLine
        syntax clear IndentLineSpace
    catch /^Vim\%((\a\+)\)\=:E28/	" catch error E28
    endtry
endfunction

"{{{1 function! s:IndentLinesToggle()
function! s:IndentLinesToggle()
    if g:indentLine_newVersion
        if exists("w:indentLine_indentLineId") && ! empty(w:indentLine_indentLineId)
            let b:indentLine_enabled = 0
            call s:IndentLinesDisable()
        else
            let b:indentLine_enabled = 1
            call s:IndentLinesEnable()
        endif

        return
    endif

    if exists("b:indentLine_enabled") && b:indentLine_enabled
        call s:IndentLinesDisable()
    else
        call s:IndentLinesEnable()
    endif
endfunction

"{{{1 function! s:ResetWidth(...)
function! s:ResetWidth(...)
    if 0 < a:0
        let &l:shiftwidth = a:1
    endif

    let b:indentLine_enabled = 1
    call s:IndentLinesDisable()
    call s:IndentLinesEnable()
endfunction

"{{{1 function! s:Filter()
function! s:Filter()
    if index(g:indentLine_fileTypeExclude, &filetype) != -1
        return 0
    endif

    if len(g:indentLine_fileType) != 0 && index(g:indentLine_fileType, &filetype) == -1
        return 0
    endif

    for name in g:indentLine_bufNameExclude
        if matchstr(bufname(''), name) == bufname('')
            return 0
        endif
    endfor

    return 1
endfunction

"{{{1 function! s:Disable()
function! s:Disable()
    if exists("b:indentLine_enabled") && b:indentLine_enabled
        return
    elseif exists("b:indentLine_leadingSpaceEnabled") && b:indentLine_leadingSpaceEnabled
        return
    elseif s:Filter() == 0
        call s:IndentLinesDisable()
        call s:LeadingSpaceDisable()
    endif
endfunction

"{{{1 function! s:Setup()
function! s:Setup()
    if &filetype ==# ""
        call s:InitColor()
    endif

    if s:Filter() && g:indentLine_enabled || exists("b:indentLine_enabled") && b:indentLine_enabled
        call s:IndentLinesEnable()
    endif

    if s:Filter() && g:indentLine_leadingSpaceEnabled || exists("b:indentLine_leadingSpaceEnabled") && b:indentLine_leadingSpaceEnabled
        call s:LeadingSpaceEnable()
    endif
endfunction

"{{{1 function! s:LeadingSpaceEnable()
function! s:LeadingSpaceEnable()
    if g:indentLine_newVersion
        if &diff
            return
        endif

        if exists("b:indentLine_leadingSpaceEnabled") && b:indentLine_leadingSpaceEnabled == 0
            return
        endif

        if !exists("w:indentLine_leadingSpaceId")
            let w:indentLine_leadingSpaceId = []
        endif

        call s:SetConcealOption()

        call add(w:indentLine_leadingSpaceId, matchadd('Conceal', '\%(^\s*\)\@<= ', 0, -1, {'conceal': g:indentLine_leadingSpaceChar}))

        if exists("w:indentLine_indentLineId") && ! empty(w:indentLine_indentLineId)
            call s:ResetWidth()
        endif

        return
    endif

    if g:indentLine_faster
        echoerr 'LeadingSpace can not be shown when g:indentLine_faster == 1'
        return
    endif
    let g:mysyntaxfile = g:indentLine_mysyntaxfile
    let b:indentLine_leadingSpaceEnabled = 1
    call s:SetConcealOption()
    execute 'syntax match IndentLineLeadingSpace /\%(^\s*\)\@<= / containedin=ALLBUT,IndentLine conceal cchar=' . g:indentLine_leadingSpaceChar
endfunction

"{{{1 function! s:LeadingSpaceDisable()
function! s:LeadingSpaceDisable()
    if g:indentLine_newVersion
        if exists("w:indentLine_leadingSpaceId") && ! empty(w:indentLine_leadingSpaceId)
            for id in w:indentLine_leadingSpaceId
                try
                    call matchdelete(id)
                catch /^Vim\%((\a\+)\)\=:E80[23]/
                endtry
            endfor
            let w:indentLine_leadingSpaceId = []
        endif

        return
    endif

    let b:indentLine_leadingSpaceEnabled = 0
    try
        syntax clear IndentLineLeadingSpace
    catch /^Vim\%((\a\+)\)\=:E28/   " catch error E28
    endtry
endfunction

"{{{1 function! s:LeadingSpaceToggle()
function! s:LeadingSpaceToggle()
    if g:indentLine_newVersion
        if exists("w:indentLine_leadingSpaceId") && ! empty(w:indentLine_leadingSpaceId)
            let b:indentLine_leadingSpaceEnabled = 0
            call s:LeadingSpaceDisable()
        else
            let b:indentLine_leadingSpaceEnabled = 1
            call s:LeadingSpaceEnable()
        endif

        return
    endif

    if exists("b:indentLine_leadingSpaceEnabled") && b:indentLine_leadingSpaceEnabled
        call s:LeadingSpaceDisable()
    else
        call s:LeadingSpaceEnable()
    endif
endfunction

"{{{1 augroup indentLine
augroup indentLine
    autocmd!
    if g:indentLine_newVersion
        autocmd BufRead,BufNewFile,ColorScheme,Syntax * call <SID>InitColor()
        autocmd BufWinEnter * call <SID>IndentLinesDisable() | call <SID>LeadingSpaceDisable() | call <SID>Setup()
        autocmd WinEnter * call <SID>Setup()
        autocmd FileType * call <SID>Disable()
    else
        autocmd BufWinEnter * call <SID>Setup()
        autocmd User * if exists("b:indentLine_enabled") || exists("b:indentLine_leadingSpaceEnabled") |
                        \ call <SID>Setup() | endif
        autocmd BufRead,BufNewFile,ColorScheme,Syntax * call <SID>InitColor()
        autocmd BufUnload * let b:indentLine_enabled = 0 | let b:indentLine_leadingSpaceEnabled = 0
        autocmd SourcePre $VIMRUNTIME/syntax/nosyntax.vim doautocmd indentLine BufUnload
        autocmd FileChangedShellPost * doautocmd indentLine BufUnload | call <SID>Setup()
    endif
augroup END

"{{{1 commands
command! -nargs=? IndentLinesReset call <SID>ResetWidth(<f-args>)
command! IndentLinesToggle call <SID>IndentLinesToggle()
if g:indentLine_newVersion
    command! IndentLinesEnable let b:indentLine_enabled = 1 | call <SID>IndentLinesEnable()
    command! IndentLinesDisable let b:indentLine_enabled = 0 | call <SID>IndentLinesDisable()
    command! LeadingSpaceEnable let b:indentLine_leadingSpaceEnabled = 1 | call <SID>LeadingSpaceEnable()
    command! LeadingSpaceDisable let b:indentLine_leadingSpaceEnabled = 0 | call <SID>LeadingSpaceDisable()
else
    command! IndentLinesEnable call <SID>IndentLinesEnable()
    command! IndentLinesDisable call <SID>IndentLinesDisable()
    command! LeadingSpaceEnable call <SID>LeadingSpaceEnable()
    command! LeadingSpaceDisable call <SID>LeadingSpaceDisable()
endif
command! LeadingSpaceToggle call <SID>LeadingSpaceToggle()

" vim:et:ts=4:sw=4:fdm=marker:fmr={{{,}}}

