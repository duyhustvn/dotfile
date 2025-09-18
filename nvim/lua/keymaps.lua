-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}

-----------------
-- Normal mode --
-----------------

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- File finding
vim.keymap.set('n', '<leader><leader>', ':Telescope find_files<CR>', opts)
-- Find in all files (including hidden ones)
vim.keymap.set('n', '<leader>fa', ':Telescope find_files hidden=true no_ignore=true<CR>', opts)
-- Live grep (search in all files content)
vim.keymap.set('n', '<leader>/', ':Telescope live_grep<CR>', opts)
-- Buffers
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', opts)

-- Open terminal
vim.keymap.set('n', '<leader>ot', ':botright split | terminal<CR>', opts)

-- Clipboard shortcuts (optional - your current config should work without these)
-- Copy to system clipboard in visual mode
vim.keymap.set('v', '<C-c>', '"+y', opts)
-- Paste from system clipboard in insert mode
vim.keymap.set('i', '<C-v>', '<C-r>+', opts)
