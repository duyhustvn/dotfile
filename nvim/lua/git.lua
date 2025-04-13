require("neogit").setup({
    -- Optional: customize the behavior
    kind = "split",           -- opens neogit in a split
    signs = {
        -- Change signs for git status
        section = { "󰁙", "󰁊" },
        item = { "󰁙", "󰁊" },
    },
    integrations = {
        diffview = true       -- enable diffview.nvim integration
    },
})
-- Add a keymap similar to Doom Emacs
vim.keymap.set('n', '<leader>gg', ':Neogit<CR>', { noremap = true, silent = true })
