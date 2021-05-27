" ----------
" Vim Config
" ----------
"
"
" How this works:
"
" This file is minimal.  Most of the vim settings and initialization is in
" several files in .vim/init.  This makes it easier to find things and to
" merge between branches and repos.
"
" Please do not add configuration to this file, unless it *really* needs to
" come first or last, like Vundle and sourcing the machine-local config.
" Instead, add it to one of the files in .vim/init, or create a new one.

set nocompatible               " be iMproved
filetype off

augroup vimrc
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
augroup END

call plug#begin('~/.config/.nvim/plugged')

Plug 'tweekmonster/startuptime.vim', { 'on': ['StartupTime'] }
"
" Colorschemes
"
Plug 'cocopon/iceberg.vim'
Plug 'joshdick/onedark.vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'morhetz/gruvbox'
Plug 'rakr/vim-one'
Plug 'chuling/ci_dark'
Plug 'luochen1990/rainbow'

Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

"
" Ruby / Rails
"
Plug 'vim-ruby/vim-ruby', { 'for': ['ruby'] }
Plug 'tpope/vim-rails', { 'for': ['ruby'] }
Plug 'tpope/vim-endwise', { 'for': ['ruby'] }
Plug 'ecomba/vim-ruby-refactoring', { 'for': ['ruby'] }
Plug 'tpope/vim-rake', { 'for': ['ruby'] }
Plug 'benmills/vimux', { 'for': ['ruby'] }
Plug 'janko-m/vim-test', { 'for': ['ruby'] }

"
" Text Objects
"
Plug 'nelstrom/vim-textobj-rubyblock', { 'for': ['ruby'] }
Plug 'kana/vim-textobj-user', { 'for': ['ruby'] }
Plug 'Julian/vim-textobj-variable-segment', { 'for': ['ruby'] }
Plug 'kana/vim-textobj-line', { 'for': ['ruby'] }
Plug 'thinca/vim-textobj-between', { 'for': ['ruby'] }
Plug 'vim-scripts/matchit.zip'

"
" General Editing
"
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdcommenter'
Plug 'matt-royal/diffthese'
Plug 'Peeja/vim-cdo'
Plug 'tpope/vim-projectionist' " this is for :AV
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'vim-scripts/regreplop.vim' " This is for ctrl-K replacing
Plug 'danilamihailov/beacon.nvim' "Shows the cursor location with a blink after jumping

"
" Searching
"
Plug 'tpope/vim-abolish' " For searching with :S vs :s
Plug 'henrik/vim-qargs'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/remote', 'do': ':UpdateRemotePlugins' }

Plug 'jremmen/vim-ripgrep'
Plug 'google/vim-searchindex'

"
" Navigation
"
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeFind', 'NERDTreeClose', 'NERDTreeToggle', 'NERDTreeRefreshRoot'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeFind', 'NERDTreeClose', 'NERDTreeToggle', 'NERDTreeRefreshRoot'] }

"
" Languages
"
Plug 'juvenn/mustache.vim'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': ['go'] }
Plug 'sheerun/vim-polyglot'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

"
" Development Tool Integration
"
Plug 'itchyny/vim-gitbranch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb' "GitHub extension for fugitive
" Plug 'airblade/vim-gitgutter'
Plug 'tmux-plugins/vim-tmux-focus-events'
call plug#end()

syntax on

runtime! init/**.vim

filetype on
