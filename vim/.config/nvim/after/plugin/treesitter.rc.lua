require('nvim-treesitter.configs').setup({
	ensure_installed = {'javascript', 'typescript', 'tsx', 'vim', 'lua'},
	highlight = {
		enable = true
	},
	indent = {
		enable = true
	}
})
