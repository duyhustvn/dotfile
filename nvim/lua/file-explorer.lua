require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
})

-- Key mappings
vim.keymap.set('n', '<leader>op', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>f', ':NvimTreeFocus<CR>', { noremap = true, silent = true })
