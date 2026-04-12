syntax on
filetype plugin indent on

" vim-plug plugin manager. plug.vim is stored in this dotfiles repo at
" .vim/autoload/plug.vim so no separate install is needed — just run
" install_symlinks.sh to symlink ~/.vim, then run:
"
"   vim +PlugInstall +GoInstallBinaries +qall
"
" to download plugins and Go tooling binaries (gopls, goimports, etc.)
call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

" relative line numbers in navigation mode
:set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

set ruler
set colorcolumn=80
set autoindent
set smartindent

" tabstop:          Width of tab character
" softtabstop:      Fine tunes the amount of white space to be added
" shiftwidth        Determines the amount of whitespace to add in normal mode
" expandtab:        When on uses space instead of tabs
set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set expandtab

" show tabs
set list
set listchars=tab:\|_

set ttyfast
" set mouse=a
" set ttymouse=xterm2

set backspace=2 " make backspace work like most other apps
set backspace=indent,eol,start

" highlight unwanted spaces like trailing spaces, spaces before tab, tabs
" that aren't at the start of a line.
" (adopted from https://vim.fandom.com/wiki/Highlight_unwanted_spaces)
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
match ExtraWhitespace /[^\t]\zs\t\+/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" for git commit editor, show an extra ruler for the first line
autocmd FileType gitcommit set colorcolumn+=51

" kubectl edit borking out
set maxmempattern=2000000

" Go-specific settings (via vim-go plugin)
"
" Use goimports instead of gofmt on save. goimports is a superset of gofmt:
" it formats the code identically but also adds/removes import lines as needed.
let g:go_fmt_command = "goimports"
"
" Auto-format the buffer with goimports on every :w.
let g:go_fmt_autosave = 1
"
" Use gopls (the official Go language server) for go-to-definition (:GoDef / gd)
" instead of the older godef tool. gopls is module-aware and more accurate.
let g:go_def_mode = 'gopls'
"
" Use gopls for type info displayed by :GoInfo (bound to K by vim-go).
let g:go_info_mode = 'gopls'
"
" Go mandates tabs for indentation (enforced by gofmt). Override the global
" expandtab setting so vim doesn't silently convert tabs to spaces in Go files.
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
"
" Go community convention is 100 chars, not the general-purpose 80 set globally.
autocmd FileType go setlocal colorcolumn=100
"
" Disable the tab/whitespace markers (set list) for Go files. Since goimports
" enforces correct indentation on every save, the visual noise isn't useful.
autocmd FileType go setlocal nolist

