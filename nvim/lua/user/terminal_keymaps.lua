-- ~/.config/nvim/lua/user/terminal_keymaps.lua

local set = vim.keymap.set
set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
set("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
set("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })
