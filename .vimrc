" this is based off my work config, trying to be better about implementing and
" understanding rules instead of chucking in a billion settings from an
" opinionated config
"
" :help in vim to explain what a lot of these do

filetype plugin indent on
syntax on

runtime macros/matchit.vim
set autoindent
set backspace=indent,eol,start
set hidden
set incsearch
set wildmenu

" useful for jumps
set relativenumber

" show current position
set ruler

" ignore case on search
set ignorecase

" show matching brackets when text indicator is over them
set showmatch

" tab settings
set expandtab
set softtabstop=4
set shiftwidth=4
set tabstop=4
