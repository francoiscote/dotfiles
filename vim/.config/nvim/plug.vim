" Plugins
call plug#begin('~/.vim/plugged')
	Plug 'hoob3rt/lualine.nvim'
  Plug 'rose-pine/neovim'
	
  Plug 'machakann/vim-highlightedyank'

  " File Explorer
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'
        
	" LSP Config
	Plug 'neovim/nvim-lspconfig'	
  Plug 'glepnir/lspsaga.nvim'
  
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
call plug#end()
