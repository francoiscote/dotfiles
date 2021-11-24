set exrc
" Line Numbers
set relativenumber
set number

" Search and Case-sensitivity
set nohlsearch
set incsearch
set ignorecase
set smartcase

set colorcolumn=80
set signcolumn=yes
set cursorline
set hidden
set noerrorbells

" Tabs
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

set nowrap
set scrolloff=8

" History
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile


" Give more space for displaying messages.
set cmdheight=1

" default to Tree View in file explorer
let g:netrw_liststyle=3

let g:nvim_tree_add_trailing = 1

runtime ./plug.vim

if has("unix")
    let s:uname = system ("uname -s")
	" Do mac stuff
	if s:uname == "Darwin\n"
		runtime ./macos.vim
	endif
endif

" Theme
set background=dark
set termguicolors
let g:material_style = 'palenight'
let g:material_terminal_italics = 1
colorscheme material

" =====================================
" key maps
" =====================================

let mapleader=" "

" From Primagean's Top 5 remaps
" https://youtu.be/hSHATqh8svM
" Make Y behave like O
nnoremap Y y$
" Keep the cursor centeres
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
" Undo breakpoints
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
" Moving lines vertically
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
inoremap <C-k> <esc>:m .-2<CR>==i
inoremap <C-j> <esc>:m .+1<CR>==i
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" NvimTree
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
