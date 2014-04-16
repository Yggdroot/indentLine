indentLine
==========

This plugin is used for displaying thin vertical lines at each indentation level for code indented with spaces. For code indented with tabs I think there is no need to support it, because you can use `:set list lcs=tab:\|\ ` (here is a space).

## Requirements
This plugin takes advantage of the newly provided `conceal` feature in Vim 7.3, so this plugin will not work with lower versions of Vim.

## Installation
To install the plugin just put the plugin files in your `~/.vim` (Linux) or `~/vimfiles` (Windows).

If you use a plugin manager you can put the whole directory into your `~/.vim/bundle/` directory ([Pathogen][pathogen]) or add the line `Bundle 'Yggdroot/indentLine'` to your `.vimrc` ([Vundle][vundle]).

## Customization
You can change the color of indentLines:  
for Vim, set `g:indentLine_color_term` in your `.vimrc`, e.g. `let g:indentLine_color_term = 239`,  
for GVim, set `g:indentLine_color_gui` in your `.vimrc`, e.g. `let g:indentLine_color_gui = '#A4E57E'`  
for none X terminal, set `g:indentLine_color_tty_light` and `g:indentLine_color_tty_dark` in your `.vimrc`. e.g. `let g:indentLine_color_tty_light = 7`(default: 4), `let g:indentLine_color_dark = 1`(default: 2).

You can also change the indentLine char:  
for both Vim and GVim, set `let g:indentLine_char = 'c'` where `'c'` can be any ASCII character. You can also use one of `¦`, `┆` or `│` to display more beautiful lines. However, these characters will only work with files whose encoding is UTF-8.

## Self promotion
If you think this script is helpful, follow the [GitHub repository][repository], and don't forget to vote for it on Vim.org! ([vimscript #4354][script]).

[pathogen]: https://github.com/tpope/vim-pathogen
[vundle]: https://github.com/gmarik/vundle
[repository]: https://github.com/Yggdroot/indentLine
[script]: http://www.vim.org/scripts/script.php?script_id=4354


## Screenshots
![Screenshot](http://i.imgur.com/KVi0T.jpg)

