NOTE
====
This is an improve version of original plugin.
The original version plugin is at here https://github.com/Yggdroot/indentLine.git

indentLine
==========

This plugin is used for displaying thin vertical lines at each indentation level for code indented with spaces.
For code indented with tabs, I think there is no need to support it, using :set list lcs=tab:\\|\ (here is a space) can 
achieve it.

## Requirements
This plugin takes advantage of newly provided conceal feature in Vim 7.3, so Vim 7.3 with conceal feature is needed.

## Installation
To install the plugin just copy indentLine.vim into plugin directory.


## Setting custom line colors
For gvim, hi Conceal guifg=(color you like) guibg=NONE

For vim, hi Conceal ctermfg=(color you like) ctermbg=NONE

You can change indentline char by youself.
change this variable:
let g:indentLine_char = 'c'
'c' can be any ascii character you like, you can also use '¦', '┆' to display more beautiful lines, 
but this only aplies to file whose encoding is utf-8

## Screenshots
<img src="http://i.imgur.com/WQqhH.jpg" width="800" height="600" alt="" />
<img src="http://i.imgur.com/zhV1v.jpg" width="800" height="600" alt="" />
<img src="http://i.imgur.com/cENlq.jpg" width="800" height="600" alt="" />

