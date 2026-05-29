-- ~/.config/nvim/lua/user/common_keymaps.lua

vim.opt.hlsearch = true -- Highlight all matches on search
vim.opt.incsearch = true -- Show matches while typing


-- remap leader key
local keymap = vim.keymap.set

keymap("n", "<Space>", "", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- yank to system clipboard
keymap({"n", "v"}, "<leader>y", '"+y', opts)

-- paste from system clipboard
keymap({"n", "v"}, "<leader>p", '"+p', opts)

-- better indent handling
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- move text up and down
keymap("v", "J", ":m .+1<CR>==", opts)
keymap("v", "K", ":m .-2<CR>==", opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- paste preserves primal yanked piece
keymap("v", "p", '"_dP', opts)

-- removes highlighting after escaping vim search
keymap("n", "<Esc>", "<Esc>:noh<CR>", opts)


