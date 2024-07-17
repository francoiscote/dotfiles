local set = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Quick Source current file
set("n", "<leader>s", "<cmd>luafile %<CR>")

-- Go down and up half-page, but keep centered
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")

-- Same as above, go next/previous search term, but keep centered
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

set("n", "<Esc>", "<cmd>nohlsearch<CR>")
