set exrc
" Line Numbers
set relativenumber
set number

" Search and Case-sensitivity
set hlsearch
set incsearch
set ignorecase
set smartcase

set colorcolumn=80
set signcolumn=yes
set hidden
set noerrorbells

" Cursor Line
set cursorline

" Indentation
filetype plugin indent on
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent

set nowrap
set scrolloff=8

" History
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

" incremental substitution (neovim)
if has('nvim')
  set inccommand=split
endif

" Nvim Tree
let g:nvim_tree_highlight_opened_files = 1

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
let g:rose_pine_variant = "moon"
colorscheme rose-pine

" Highlight yank with yellow bg
highlight HighlightedyankRegion guifg=#191724 guibg=#f6c177

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
