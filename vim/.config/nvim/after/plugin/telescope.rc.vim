if !exists('g:loaded_telescope') | finish | endif

nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files({hidden = true})<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').file_browser()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>\\ <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

lua << EOF
local actions = require('telescope.actions')

function telescope_buffer_dir()
	return vim.fn.expand('%:p:h')
end

require("telescope").setup({
	defaults = {
		mappings = {
			n = {
				["q"] = actions.close
			}	
		},
		file_ignore_patterns = {
			"^.git/"
		}	
	}
})
EOF
