set guicursor=
set nohlsearch
set incsearch
set hidden
set number
set relativenumber
set signcolumn=yes
set cursorline
set shiftwidth=2
set tabstop=2
set scrolloff=8
set background=dark
set termguicolors
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

" Give more space for displaying messages.
set cmdheight=1

" default to Tree View in file explorer
let g:netrw_liststyle=3

runtime ./plug.vim


if has("unix")
	let s:uname = system ("uname -s")
	" Do mac stuff
	if s:uname == "Darwin\n"
		runtime ./macos.vim
	endif
endif

colorscheme palenight

" =====================================
" key maps
" =====================================

let mapleader=" "
