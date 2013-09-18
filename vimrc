" Description: Vim configuration file
" Author: Philippe Pepiot <phil@philpep.org>

" No vi compatible
set nocompatible

" 3 lines visible around the cursor
set scrolloff=3

" No bells
set errorbells
set novisualbell

" History
set history=100
set undolevels=150

" hilight
set hls

set et
set smarttab
set ts=4
set sw=4
set tw=0

" Don't show these file during completion
set suffixes+=.jpg,.png,.jpeg,.gif,.bak,~,.swp,.swo,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pyc,.pyo,.mod

" Searching
set incsearch
set ignorecase
set smartcase

" spell
set spelllang=fr

" Statusline
set laststatus=2
set ruler

" Folding
set foldmethod=marker

" show tab and spaces
set list
set lcs:tab:>-,trail:.,nbsp:_

" paste/nopaste
set pastetoggle=<F11>

" Allow backspace in insert mode
set backspace=indent,eol,start

" For syntaxt/2html.vim
let use_xhtml=1
let html_ignore_folding=1

" Backup
set backup
if filewritable("$HOME/.vim/backup") == 2
	set backupdir=$HOME/.vim/backup
else
	call system("mkdir -p $HOME/.vim/backup")
	set backupdir=$HOME/.vim/backup
endif

filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'scrooloose/syntastic'
Bundle 'Glench/Vim-Jinja2-Syntax'
Bundle 'philpep/vim-rst-tables'

filetype plugin indent on
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\   exe "normal! g`\"" |
			\ endif

autocmd FileType text set tw=78
autocmd Filetype yaml set ts=2 sw=2
autocmd BufRead,BufNewFile *.pgc set ft=c
autocmd BufRead,BufNewFile *.pde set ft=c
autocmd BufRead,BufNewFile *.j2 set ft=jinja
syntax on

" :Man
runtime ftplugin/man.vim
nnoremap K :Man <cword><CR>
let $PAGER='less'
let $MANPAGER='less'

" Mappings
map <F5> <Esc>gg=G''
map ,,c :python ReformatTable()<CR>
map ,,f :python ReflowTable()<CR>

colo desert
