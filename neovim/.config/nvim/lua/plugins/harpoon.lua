return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		local set = vim.keymap.set

		harpoon:setup()

		set("n", "<leader>a", function() harpoon:list():add() end)
		set("n", "<C-b>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

		set("n", "<C-S-j>", function() harpoon:list():select(1) end)
		set("n", "<C-S-k>", function() harpoon:list():select(2) end)
		set("n", "<C-S-l>", function() harpoon:list():select(3) end)
		set("n", "<C-S-;>", function() harpoon:list():select(4) end)

		-- Toggle previous & next buffers stored within Harpoon list
		set("n", "<C-S-P>", function() harpoon:list():prev() end)
		set("n", "<C-S-N>", function() harpoon:list():next() end)
	end
}
