syntax on
set autoindent
set number
set ruler
set colorcolumn=80

" show tabs
set list
set listchars=tab:\|_

set ttyfast
set mouse=a
set ttymouse=xterm2

set backspace=2 " make backspace work like most other apps
set backspace=indent,eol,start

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')

Plug 'fatih/vim-go'

" Initialize plugin system
call plug#end()

