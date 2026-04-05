syntax on
filetype plugin indent on

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

" Go-specific settings
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType go setlocal colorcolumn=100
autocmd FileType go setlocal nolist
function! GoFmt()
  let lines = systemlist('gofmt', getline(1, '$'))
  if v:shell_error == 0
    let view = winsaveview()
    call setline(1, lines)
    call winrestview(view)
  endif
endfunction
autocmd FileType go autocmd BufWritePre <buffer> call GoFmt()

