" Plugins
call plug#begin('~/.vim/plugged')
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-rhubarb'

	Plug 'hoob3rt/lualine.nvim'
	Plug 'kyazdani42/nvim-palenight.lua'

	if has ("nvim")
		Plug 'neovim/nvim-lspconfig'	

		" Treesitter
		Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate' }

		" Telescope
		Plug 'kyazdani42/nvim-web-devicons'
		Plug 'nvim-lua/popup.nvim'
		Plug 'nvim-lua/plenary.nvim'
		Plug 'nvim-telescope/telescope.nvim'
	  Plug 'nvim-telescope/telescope-fzy-native.nvim'
	endif
call plug#end()


