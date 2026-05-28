-- ~/.config/nvim/init.lua

-- remap leader key
local keymap = vim.keymap.set
vim.opt.clipboard = "unnamedplus"
keymap("n", "<Space>", "", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Check for lazy nvim (pluging manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Install plugins
require("lazy").setup("plugins")


-- Import configuration
if vim.g.vscode then
  -- VSCode Neovim
  require "user.vscode_keymaps"
else
  -- Ordinary Neovim
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.signcolumn = "yes"
  vim.opt.termguicolors = true
  vim.opt.tabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.expandtab = true

  vim.cmd[[colorscheme tokyonight-moon]]

  require "user.terminal_keymaps"
end

