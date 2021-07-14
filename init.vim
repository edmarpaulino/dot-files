syntax enable
set relativenumber
set nu
set tabstop=4
set autoindent
set smartindent
retab
set incsearch
set wildmenu
set laststatus=2
set title
set mouse=a
set cursorline
scriptencoding utf-8
set encoding=utf-8
set clipboard=unnamedplus
set textwidth=80

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

Plug 'gruvbox-community/gruvbox'

" Initialize plugin system
call plug#end()

colorscheme gruvbox
