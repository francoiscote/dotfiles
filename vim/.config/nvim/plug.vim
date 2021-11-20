" Plugins
call plug#begin('~/.vim/plugged')
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-rhubarb'

	Plug 'hoob3rt/lualine.nvim'
    Plug 'marko-cerovac/material.nvim'
	
	if has ("nvim")
        " File Explorer
		Plug 'kyazdani42/nvim-web-devicons'
        Plug 'kyazdani42/nvim-tree.lua'
        
		" LSP Config
		Plug 'neovim/nvim-lspconfig'	

        " Completion
        Plug 'hrsh7th/nvim-cmp'
        Plug 'hrsh7th/cmp-nvim-lsp'
        Plug 'hrsh7th/cmp-buffer'
        Plug 'hrsh7th/cmp-path'
        Plug 'hrsh7th/cmp-calc'
		
        " Treesitter
		Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate' }

		" Telescope
		Plug 'nvim-lua/popup.nvim'
		Plug 'nvim-lua/plenary.nvim'
		Plug 'nvim-telescope/telescope.nvim'
	    Plug 'nvim-telescope/telescope-fzy-native.nvim'

		"Vim-Tmux
		Plug 'christoomey/vim-tmux-navigator'
        Plug 'ThePrimeagen/vim-be-good'
	endif
call plug#end()
