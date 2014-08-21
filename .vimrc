" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set ignorecase 

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup			" keep a backup file
endif

set history=50		" keep 50 lines of command line history
set ruler					" show the cursor position all the time
set showcmd				" display incomplete commands
set incsearch			" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

au BufNewFile,BufRead *.yaml,*.yml,*.sls so ~/.vim/syntax/yaml.vim

"-------------- Custom key bindings -------------------
" Set custom key bindings using comma 
let mapleader = ","

" Toggle paste mode via ',pp' 
map <leader>pp :setlocal paste!<cr>
" Toggle line numbering via ',nn'
map <leader>nn :setlocal number!<cr>
" long lines 
map <leader>ll :setlocal tw=2000000<cr>
" da for data files (need to escape pipe)  
map <leader>da :setlocal tw=2000000 \| setlocal paste \| setlocal nonu<cr>
" ta for tab 
map <leader>ta :setlocal expandtab!<cr>
" Format JSON using ',json' 
map <leader>json :%!python -m json.tool<cr>
"------------------------------------------------------

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

set autoindent
set ts=2
set number
set bg=dark
set shiftwidth=2
set wrap
set textwidth=80
set tabstop=2
set expandtab 
syntax on
colorscheme molokai



" OSX Crontab crap
if $VIM_CRONTAB == "true"
set nobackup
set nowritebackup
endif
