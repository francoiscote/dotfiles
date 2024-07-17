return {
	{
		"f-person/auto-dark-mode.nvim",
		config = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.api.nvim_set_option("background", "dark")
			end,
			set_light_mode = function()
				vim.api.nvim_set_option("background", "light")
			end,
		},
	},
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	event = 'ColorScheme',
  config = function()
    require("lualine").setup({
			options = {
				theme = 'rose-pine'
			}
		})
  end,
}
