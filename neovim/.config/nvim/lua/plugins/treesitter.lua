return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,  
	opts = {
		ensure_installed = { "bash", "diff", "lua", "luadoc", "vim", "vimdoc", "query", "markdown", "javascript", "html", "css" },
		auto_install = true,
		sync_install = false,
		highlight = { enable = true },
		indent = { enable = true },  
	},
	config = function (_, opts) 
		require("nvim-treesitter.configs").setup({ opts })
	end
}
