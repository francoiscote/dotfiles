return  {
	'nvim-telescope/telescope.nvim', 
	tag = '0.1.8',
	dependencies = { 
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-ui-select.nvim' }	
	},
	config = function()
		require("telescope").setup({
			pickers = {
				find_files = {
					hidden = true, 
				},
			},
			extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
		})

		-- Enable Telescope extensions if they are installed
		pcall(require('telescope').load_extension, 'fzf')
		pcall(require('telescope').load_extension, 'ui-select')


		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<C-p>", builtin.find_files, {})
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>,", builtin.buffers, {})
		vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
	end,
}

