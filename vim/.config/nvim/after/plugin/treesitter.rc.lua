require('nvim-treesitter.configs').setup({
	ensure_installed = {'javascript', 'typescript', 'tsx', 'vim'},
	highlight = {
		enable = true
	},
	indent = {
		enable = true
	}
})
