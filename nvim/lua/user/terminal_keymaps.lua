-- ~/.config/nvim/lua/user/terminal_keymaps.lua

local set = vim.keymap.set

-- Navigation
set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
set("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
set("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })

set('t', '<C-h>', [[<C-\><C-n><C-w>h]], { silent = true })
set('t', '<C-j>', [[<C-\><C-n><C-w>j]], { silent = true })
set('t', '<C-k>', [[<C-\><C-n><C-w>k]], { silent = true })
set('t', '<C-l>', [[<C-\><C-n><C-w>l]], { silent = true })

-- Buffer management
set('n', '<leader>x', ':bdelete<CR>', { silent = true, desc = 'Close current buffer' })
set('n', '<leader>X', ':bdelete!<CR>', { silent = true, desc = 'Force close buffer (discard changes)' })


-- Terminal toggling
local term_buf = nil
local term_win = nil
local function toggle_terminal()
    -- Terminal window is active and open -> Hide it (Go back to code)
    if term_win and vim.api.nvim_win_is_valid(term_win) then
        vim.api.nvim_win_close(term_win, [[force]])
        term_win = nil
        return
    end

    -- Terminal buffer already exists but window is closed -> Reopen it
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
        vim.cmd('botright split | resize 12')
        vim.api.nvim_win_set_buf(0, term_buf)
        term_win = vim.api.nvim_get_current_win()
        vim.cmd('startinsert')
        return
    end

    -- Terminal doesn't exist yet -> Create it from scratch
    vim.cmd('botright split | resize 12 | terminal')
    term_win = vim.api.nvim_get_current_win()
    term_buf = vim.api.nvim_get_current_buf()
    
    -- Clean UI options for the terminal pane
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.cmd('startinsert')
end

-- Map <leader>t for Normal mode (to open/hide it)
vim.keymap.set('n', '<leader>t', toggle_terminal, { desc = 'Toggle Terminal' })

-- Map <leader>t for Terminal mode (so you can type it WHILE inside the terminal to close it!)
vim.keymap.set('t', '<leader>t', toggle_terminal, { desc = 'Toggle Terminal' })

-- Keep the easy Escape fix so you can navigate out if you don't want to close it
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit Terminal Mode' })
