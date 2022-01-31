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
let g:loaded_matchit = 1 " force disable matchit
filetype off
if has("autocmd")
  filetype indent plugin on
endif

augroup vimrc
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  endif
augroup END

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif


call plug#begin('~/.config/.nvim/plugged')

Plug 'tweekmonster/startuptime.vim', { 'on': ['StartupTime'] }
Plug 'lewis6991/impatient.nvim'
"
" Colorschemes
"
Plug 'cocopon/iceberg.vim'
Plug 'joshdick/onedark.vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'morhetz/gruvbox'
Plug 'rakr/vim-one'
Plug 'chuling/ci_dark'

Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

"
" Ruby / Rails
"
Plug 'vim-ruby/vim-ruby', { 'for': ['ruby'] }
Plug 'tpope/vim-rails', { 'for': ['ruby'] }
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

"
" General Editing
"
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'matt-royal/diffthese'
Plug 'b3nj5m1n/kommentary'
Plug 'Peeja/vim-cdo'
Plug 'tpope/vim-projectionist' " this is for :AV
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'vim-scripts/regreplop.vim' " This is for ctrl-K replacing
Plug 'danilamihailov/beacon.nvim' "Shows the cursor location with a blink after jumping
Plug 'mhinz/vim-startify'

Plug 'folke/which-key.nvim'
Plug 'rhysd/committia.vim'
Plug 'github/copilot.vim'

"
" Searching
"
Plug 'tpope/vim-abolish' " For searching with :S vs :s
Plug 'henrik/vim-qargs'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'

" Plug 'jremmen/vim-ripgrep'
Plug 'tacahiroy/vim-ripgrep', { 'branch': 'fix-e1208' }
Plug 'google/vim-searchindex'

"
" Navigation
"
Plug 'kyazdani42/nvim-tree.lua'

"
" Languages
"
Plug 'nathom/filetype.nvim'
Plug 'juvenn/mustache.vim'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': ['go'] }

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'saadparwaiz1/cmp_luasnip' " Snippets source for nvim-cmp
Plug 'L3MON4D3/LuaSnip'
Plug 'tami5/lspsaga.nvim'

"
" Tree Sitter
"

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'p00f/nvim-ts-rainbow'
Plug 'nvim-treesitter/playground'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'andymass/vim-matchup'

"
" Development Tool Integration
"
Plug 'itchyny/vim-gitbranch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb' "GitHub extension for fugitive
Plug 'kdheepak/lazygit.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'

Plug 'tmux-plugins/vim-tmux-focus-events'

call plug#end()

lua require('impatient')

syntax on

runtime! init/**.vim

filetype on

set timeoutlen=20
