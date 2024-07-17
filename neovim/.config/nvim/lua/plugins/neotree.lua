return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", 
		"MunifTanjim/nui.nvim",
	},
	opts = {
		filesystem = {
			filtered_items = {
				visible = true,
				hide_dotfiles = false
			}
		}
	},

	keys = {
		{ "<C-n>", ":Neotree toggle<CR>", { desc = "NeoTree Toggle" }}
	},
}
