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

" Case insentisive for file completion
set wildignorecase

" hilight
set hls

set ts=4
set sw=4
set lcs:tab:>-,trail:.,nbsp:_

" Don't show these file during completion
set suffixes+=.jpg,.png,.jpeg,.gif,.bak,~,.swp,.swo,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pyc,.pyo,.mod

" Searching
set incsearch
set ignorecase
set smartcase

" spell
set spelllang=en

" Statusline
set laststatus=2
set ruler

" Folding
set foldmethod=marker

" paste/nopaste
set pastetoggle=<F11>

" Allow backspace in insert mode
set backspace=indent,eol,start

" For syntaxt/2html.vim
let use_xhtml=1
let html_ignore_folding=1
let g:vim_markdown_folding_disabled=1

" Backup
set backup
if filewritable("$HOME/.vim/backup") == 2
	set backupdir=$HOME/.vim/backup
else
	call system("mkdir -p $HOME/.vim/backup")
	set backupdir=$HOME/.vim/backup
endif

" Swap files
if filewritable("$HOME/.vim/swap") == 2
    set dir=$HOME/.vim/swap
else
	call system("mkdir -p $HOME/.vim/swap")
	set dir=$HOME/.vim/swap
endif

filetype plugin on
filetype indent on
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\   exe "normal! g`\"" |
			\ endif

autocmd Filetype python set tw=0 smarttab et list
autocmd Filetype sql set tw=0 smarttab et list
autocmd Filetype yaml set ts=2 sw=2 tw=0 smarttab et list
autocmd Filetype javascript set tw=0 smarttab et list
autocmd Filetype dosini set tw=0 smarttab et list
autocmd FileType sh set et list
autocmd FileType text set tw=78
autocmd BufRead,BufNewFile *.pgc set ft=c
autocmd BufRead,BufNewFile *.pde set ft=c
autocmd BufRead,BufNewFile *.j2 set ft=jinja
autocmd BufRead,BufNewFile *.go set noet nolist
autocmd BufRead,BufNewFile *.html set et
autocmd BufNewFile,BufRead *.tsx,*.jsx,*.ts set filetype=typescript.tsx tw=0 smarttab et list
autocmd BufRead,BufNewFile Jenkinsfile set et sw=2 ts=2 tw=0 smarttab list
autocmd BufRead,BufNewFile Dockerfile set tw=0 smarttab et list
autocmd BufNewFile,BufRead /var/tmp/mutt* set noautoindent filetype=mail wm=0 tw=78 nonumber digraph nolist spelllang=en,fr
syntax on
set background=light
if &diff
	colorscheme evening
else
	try
		colorscheme solarized
	catch /^Vim\%((\a\+)\)\=:E185/
	endtry
endif


" :Man
runtime ftplugin/man.vim
nnoremap K :Man <cword><CR>
let $PAGER='less'
let $MANPAGER='less'

" Mappings
map <F5> <Esc>gg=G''
map ,,c :EasyAlign*<Bar><Enter>
map ,,f :python ReflowTable()<CR>

" let g:ale_sign_column_always = 1
let g:ale_linters = {'python': ['flake8', 'yafp', 'mypy']}
let g:ale_fixers = {'python': ['isort', 'black'], 'javascript': ['prettier'], 'text': []}
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_fix_on_save = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

"noremap <Up> <Nop>
"noremap <Down> <Nop>
"noremap <Left> <Nop>
"noremap <Right> <Nop>

" load all plugins
packadd! debPlugin
packadd! detectindent
packadd! gnupg
packadd! ale
packadd! solarized
