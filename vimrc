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

" file completion
set wildignorecase
"set wildcharm=<tab>
set wildmenu
set wildmode=list:longest,full

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
"" When editing a file, always jump to the last known cursor position.
"" Don't do it when the position is invalid or when inside an event handler
"" (happens when dropping a file on gvim).
"autocmd BufReadPost *
"            \ if line("'\"") > 0 && line("'\"") <= line("$") |
"            \   exe "normal! g`\"" |
"            \ endif

autocmd Filetype python set tw=0 smarttab et list
autocmd Filetype sql set tw=0 smarttab et list
autocmd Filetype yaml set ts=2 sw=2 tw=0 smarttab et list
autocmd Filetype javascript set tw=0 smarttab et list
autocmd Filetype dosini set tw=0 smarttab et list
autocmd FileType sh set et list
autocmd FileType text set tw=78
autocmd BufRead,BufNewFile *.pgc set ft=c
autocmd BufRead,BufNewFile *.pde set ft=c
autocmd BufRead,BufNewFile *.j2 set ft=jinja et list
autocmd BufRead,BufNewFile *.go set noet nolist
autocmd BufRead,BufNewFile *.html set et
autocmd BufNewFile,BufRead *.tsx,*.jsx,*.ts set filetype=typescript.tsx tw=0 smarttab et list
autocmd BufRead,BufNewFile Jenkinsfile set et sw=2 ts=2 tw=0 smarttab list ft=groovy
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

"let g:ale_sign_column_always = 1
" linters = flake8, mypy
let g:ale_linters = {
    \ 'python': ['pylsp', 'ruff', 'mypy'],
    \ 'typescriptreact': ['biome', 'tsserver'],
    \ 'typescript': ['biome', 'tsserver'],
    \ 'yaml': ['yamllint']}
let g:ale_fixers = {
    \ 'python': ['ruff', 'ruff_format'],
    \ 'typescriptreact': ['biome'],
    \ 'typescript': ['biome']}
let g:ale_python_pylsp_config = {
    \ 'pylsp': {
    \   'plugins': {
    \     'autopep8': {'enabled': v:false},
    \     'flake8': {'enabled': v:false},
    \     'jedi_completion': {'enabled': v:false},
    \     'jedi_definition': {'enabled': v:true},
    \     'jedi_hover': {'enabled': v:false},
    \     'jedi_references': {'enabled': v:false},
    \     'jedi_signature_help': {'enabled': v:false},
    \     'jedi_symbols': {'enabled': v:false},
    \     'mccabe': {'enabled': v:false},
    \     'preload': {'enabled': v:false},
    \     'pycodestyle': {'enabled': v:false},
    \     'pydocstyle': {'enabled': v:false},
    \     'pyflakes': {'enabled': v:false},
    \     'pylint': {'enabled': v:false},
    \     'rope_autoimport': {'enabled': v:false},
    \     'rope_completion': {'enabled': v:false},
    \     'yapf': {'enabled': v:false},
    \     'isort': {'enabled': v:false},
    \     'black': {'enabled': v:false},
    \     'pylsp_mypy': {'enabled': v:false},
    \   }
    \  }
    \}
"let $ESLINT_D_PPID = getpid()
"let g:ale_javascript_eslint_executable = 'eslint_d'
"let g:ale_javascript_eslint_use_global = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_fix_on_save = 1
let g:ale_virtualtext_cursor = 'disabled'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <silent> gd <Plug>(ale_go_to_definition)
nmap <silent> gD <Plug>(ale_go_to_definition_in_split)

let g:lightline = {
  \ 'colorscheme': 'solarized',
  \ 'component_function': {
  \   'filename': 'LightlineFilename',
  \ }
  \ }

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

"noremap <Up> <Nop>
"noremap <Down> <Nop>
"noremap <Left> <Nop>
"noremap <Right> <Nop>

" load all plugins
packadd! debPlugin
packadd! detectindent
packadd! gnupg
packadd! solarized
packadd! nerd-commenter
packadd! ale
packadd! lightline
