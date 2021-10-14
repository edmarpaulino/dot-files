" Plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'terryma/vim-multiple-cursors'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'rking/ag.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'andweeb/presence.nvim'
call plug#end()

" Plugins config
colorscheme dracula
set background=dark

" Airline configurations
let g:airline_theme='dracula'

" NVIM configs
set hidden
syntax enable
set number
set relativenumber
set inccommand=split
set tabstop=4
set shiftwidth=4
set textwidth=80
" set colorcolumn=81
set autoindent
set noexpandtab
retab
set noerrorbells
set incsearch
set wildmenu
set laststatus=2
set title
set mouse=a
set cursorline
set encoding=utf-8
set enc=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set clipboard=unnamedplus
set textwidth=80
set list
set listchars=tab:→→,space:·
set clipboard+=unnamedplus

set guifont=DroidSansMono\ Font\ Mono:h12

" Leaderkey remap
let mapleader="\<space>"
"" n -> normal
"" nore -> no recursive
nnoremap <leader>; A;<esc>
nnoremap <leader>ev :vsplit ~/.config/nvim/init.vim<cr>
nnoremap <leader>sv :source ~/.config/nvim/init.vim<cr>
nnoremap <leader>t :terminal<cr>
nnoremap <leader>pi :PlugInstall<cr>


nnoremap <C-p> :FZF<cr>
nnoremap <C-f> :Ag<space>
nnoremap <C-E> :NERDTreeToggle<cr>
