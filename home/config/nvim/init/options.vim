scriptencoding utf-8

set encoding=utf-8
set updatetime=100
set guicursor=a:blinkon0
set noerrorbells
set visualbell

set notimeout
set ttimeout
set ttimeoutlen=100

set showcmd
set mouse=a
set expandtab
set tabstop=2
set autoindent
set smarttab
set shiftwidth=2
set number
set nowrap
set backspace=indent,eol,start
set wildignore+=tags,tmp/**,public/uploads/**,public/images/**,vendor/**

set list
set listchars=trail:·,tab:▸\
set showmatch
set hidden
set splitright
set splitbelow
set scrolloff=3
set laststatus=2
set incsearch
set history=1024
set ignorecase
set smartcase
set autoread
set swapfile
set hlsearch
set nocursorline
set foldmethod=manual

augroup external_file_changes
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() !=# 'c' | checktime | endif
augroup END
