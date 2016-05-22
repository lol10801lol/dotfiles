set background=dark
colorscheme base16-default
if has('gui_running')
 "set background=light
 "colorscheme solarized
 set gfn=Hack\ 11
 set mouse=a
else
 "colorscheme zenburn
 set mouse=
endif
set guioptions-=T  "remove toolbar
:set guioptions-=r  "remove right-hand scroll bar
set guiheadroom=0
syntax on
filetype plugin indent on
set encoding=utf-8
set shiftwidth=1
set expandtab
set tabstop=2
