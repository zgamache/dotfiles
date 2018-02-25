"===============================================================================
" Global VIM Config
"   Zak Gamache
"===============================================================================

" For making things work
set nocompatible
filetype off

"-------------------------------------------------------------------------------
" Vundle
"-------------------------------------------------------------------------------

" set the runtime path to include Vundle and initialize
if has("win32")
    set rtp+=~/vimfiles/bundle/Vundle.vim
    call vundle#begin('~/vimfiles/bundle')
elseif has("unix")
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
endif

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-scripts/a.vim'
Plugin 'scrooloose/syntastic'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"-------------------------------------------------------------------------------
" Standard VIM
"-------------------------------------------------------------------------------

" Appearance settings
set background=dark
silent! colorscheme solarized
"set relativenumber
set number
set cursorline
set ruler
set showmatch
set nowrap
set colorcolumn=81

" Tab settings
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set backspace=indent,eol,start
set autoindent
set tabpagemax=25

" Search Settings
set incsearch
set hlsearch
set ignorecase
set smartcase

" Syntax Settings
syntax on
set foldmethod=syntax
set foldnestmax=1
let c_no_comment_fold = 1
nnoremap <leader>z <Esc>zMzv

" The below provides a great performance boost while using syntax folding
" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window.
autocmd InsertEnter * let w:last_fdm=&foldmethod | setlocal foldmethod=manual
autocmd InsertLeave * let &l:foldmethod=w:last_fdm

" Command Completion
set wildmenu
set showcmd

"-------------------------------------------------------------------------------
" Simple Commands
"-------------------------------------------------------------------------------

command DU diffu

"-------------------------------------------------------------------------------
" Trailing Whitespace
"-------------------------------------------------------------------------------

" Auto highlight trailing whitespace as error
function! HighlightTrailing()
        match ErrorMsg '\s\+$'
endfunction
command HTW call HighlightTrailing()

" Remove trailing whitespace
function! TrimWhiteSpace()
        %s/\s\+$//e
        retab
endfunction

command RTW call TrimWhiteSpace()

"-------------------------------------------------------------------------------
" TMUX
"-------------------------------------------------------------------------------

function SetTitleFile()
    " Set title to shortened file path of form /d/d/d/filename
    "let &titlestring = pathshorten(expand("%:p"))

    " Set title to filename
    let &titlestring = expand("%:t")

    set title
endfunction

" Push filename to shell title
autocmd BufEnter * call SetTitleFile()

"-------------------------------------------------------------------------------
" Airline
"-------------------------------------------------------------------------------

" Always show statusbar
set laststatus=2

" Always show tabbar
let g:airline#extensions#tabline#enabled = 1

" Set separators
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_left_sep=''
let g:airline_right_sep=''

" Set tab names to filename only
let g:airline#extensions#tabline#fnamemod = ':t:.'

" Prevent default vim mode display
set noshowmode

"-------------------------------------------------------------------------------
" Syntastic
"-------------------------------------------------------------------------------

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0


"-------------------------------------------------------------------------------
" CTAGS
"-------------------------------------------------------------------------------

" Look all the way up for tags
set tags=tags;/
