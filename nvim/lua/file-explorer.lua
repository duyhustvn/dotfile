-- Make sure you have a patched Nerd Font installed and configured in your terminal
-- Install nvim-web-devicons if not already installed
-- Use :PackerInstall nvim-web-devicons or your package manager's equivalent

require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 30,
        cursorline = true,
        signcolumn = "yes",
    },
    renderer = {
        group_empty = true,
        highlight_opened_files = "all",
        highlight_git = true,
        add_trailing = true,
        indent_markers = {
            enable = true,
            icons = {
                corner = "└",
                edge = "│",
                item = "│",
                none = " ",
            },
        },
        icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "",
                symlink = "",
                bookmark = "",
                folder = {
                    arrow_closed = "",  -- Alternative: "▶"
                    arrow_open = "",    -- Alternative: "▼"
                    default = "📁",      -- Simple folder icon
                    open = "📂",         -- Simple open folder icon
                    empty = "📁",        -- Simple empty folder icon
                    empty_open = "📂",   -- Simple empty open folder icon
                    symlink = "📁",      -- Simple symlink folder icon
                    symlink_open = "📂", -- Simple symlink open folder icon
                },
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
    },
    filters = {
        dotfiles = false, --- false: display hidden file
        git_ignored = false, --- false: display file in .gitignore
    },
    update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
    },
})

-- Key mappings
vim.keymap.set('n', '<leader>op', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>f', ':NvimTreeFocus<CR>', { noremap = true, silent = true })

-- Add custom highlighting for NvimTree
vim.cmd([[
  augroup NvimTreeHighlight
    autocmd!
    autocmd ColorScheme * highlight NvimTreeCursorLine guibg=#3a3a3a
    autocmd ColorScheme * highlight NvimTreeOpenedFile gui=bold guifg=#88c0d0
    autocmd ColorScheme * highlight NvimTreeIndentMarker guifg=#3b4252
    autocmd ColorScheme * highlight NvimTreeFolderIcon guifg=#81a1c1
    autocmd ColorScheme * highlight NvimTreeFolderName guifg=#81a1c1 gui=bold
    autocmd ColorScheme * highlight NvimTreeRootFolder guifg=#88c0d0 gui=bold
  augroup END
]])
