scriptencoding utf-8

set nocompatible
let g:loaded_matchit = 1
filetype plugin indent on

let mapleader = ","
let maplocalleader = ";"

if empty(glob(stdpath('config') . '/autoload/plug.vim'))
  echoerr 'vim-plug is missing from the tracked Neovim configuration'
  finish
endif

call plug#begin(stdpath('data') . '/plugged')

Plug 'tweekmonster/startuptime.vim', { 'on': ['StartupTime'] }

Plug 'chuling/ci_dark'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'

Plug 'vim-ruby/vim-ruby', { 'for': ['ruby'] }
Plug 'tpope/vim-rails', { 'for': ['ruby'] }
Plug 'ecomba/vim-ruby-refactoring', { 'for': ['ruby'] }
Plug 'tpope/vim-rake', { 'for': ['ruby'] }
Plug 'benmills/vimux', { 'for': ['ruby'] }
Plug 'vim-test/vim-test', { 'for': ['ruby'] }

Plug 'nelstrom/vim-textobj-rubyblock', { 'for': ['ruby'] }
Plug 'kana/vim-textobj-user', { 'for': ['ruby'] }
Plug 'Julian/vim-textobj-variable-segment', { 'for': ['ruby'] }
Plug 'kana/vim-textobj-line', { 'for': ['ruby'] }
Plug 'thinca/vim-textobj-between', { 'for': ['ruby'] }

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'matt-royal/diffthese'
Plug 'Peeja/vim-cdo'
Plug 'tpope/vim-projectionist'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'danilamihailov/beacon.nvim'
Plug 'rhysd/committia.vim'
Plug 'github/copilot.vim'

Plug 'tpope/vim-abolish'
Plug 'henrik/vim-qargs'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'google/vim-searchindex'

Plug 'nvim-tree/nvim-tree.lua'
Plug 'juvenn/mustache.vim'
Plug 'fatih/vim-go', { 'for': ['go'] }

Plug 'neovim/nvim-lspconfig'
Plug 'mason-org/mason.nvim'
Plug 'mason-org/mason-lspconfig.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'andymass/vim-matchup'

Plug 'itchyny/vim-gitbranch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'kdheepak/lazygit.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tmux-plugins/vim-tmux-focus-events'

call plug#end()

syntax on
if empty($DOTFILES_NVIM_BOOTSTRAP)
  runtime! init/**.vim
endif
set timeoutlen=300
