
indentLine
==========

This plugin is used for displaying thin vertical lines at each indentation level for code indented with spaces.
For code indented with tabs, I think there is no need to support it, using :set list lcs=tab:\\|\ (here is a space) can 
achieve it.

## Requirements
This plugin takes advantage of newly provided conceal feature in Vim 7.3, so Vim 7.3 with conceal feature is needed.

## Installation
To install the plugin just put plugin files in your ~/.vim (linux) or ~/vimfiles (Windows). 

## Setting custom indentLines
You can change the color of indentLines:<br/>
for vim, you can set g:indentLine_color_term in your vimrc, e.g. let g:indentLine_color_term = 239(any color you like),<br/>
for gvim, you can set g:indentLine_color_gui in your vimrc, e.g. let g:indentLine_color_gui = '#A4E57E'(any color you like)

You can change indentLine char by youself.<br/>
change this variable: let g:indentLine_char = 'c'; 'c' can be any ascii character you like, you can also use '¦', '┆'and '│' to display more beautiful lines, 
but this only aplies to file whose encoding is utf-8

##Self promotion
If you think this script is helpful, follow the GitHub [repository][repository], and don't forget to vote for it on Vim.org! ([vimscript #4354][script]).
[repository]: https://github.com/Yggdroot/indentLine
[script]: http://www.vim.org/scripts/script.php?script_id=4354


## Screenshots
<img src="http://i.imgur.com/KVi0T.jpg" width="800" height="600" alt="" />

