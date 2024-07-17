return {
	{
		"f-person/auto-dark-mode.nvim",
		config = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.api.nvim_set_option("background", "dark")
				vim.cmd('colorscheme rose-pine')
			end,
			set_light_mode = function()
				vim.api.nvim_set_option("background", "light")
				vim.cmd('colorscheme github_light')
			end,
		},
	},
	{
		'rose-pine/neovim', name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function()
			require('rose-pine').setup({
				variant = "auto",
				dark_variant = "moon",	
				dim_inactive_windows = true
			})
    end,
  },
	{	
		'projekt0n/github-nvim-theme', name = 'github',
    lazy = false,
    priority = 1000,
		config = function ()
			require('github-theme').setup()
		end,
  },
}
