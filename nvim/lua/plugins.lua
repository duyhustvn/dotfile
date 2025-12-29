local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

require("lazy").setup({
    "tanvirtin/monokai.nvim",
	-- LSP manager
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",

    -- File explorer
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = {
        "nvim-tree/nvim-web-devicons", -- file icon
      },
    },

    -- Git
    {
      "NeogitOrg/neogit",
      dependencies = {
        "nvim-lua/plenary.nvim",         -- required
        "sindrets/diffview.nvim",        -- optional - Diff integration
        -- Only one of these is needed.
        "nvim-telescope/telescope.nvim", -- optional - For better picker experience
        "ibhagwan/fzf-lua",              -- optional
        "echasnovski/mini.pick",         -- optional
      },
    },

    -- Find file
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Optional: for better sorting performance
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        },
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",           -- LSP completion source
            "hrsh7th/cmp-buffer",             -- Buffer completion source
            "hrsh7th/cmp-path",               -- Path completion source
            "hrsh7th/cmp-cmdline",            -- Cmdline completion source
            "L3MON4D3/LuaSnip",              -- Snippet engine
            "saadparwaiz1/cmp_luasnip",      -- Snippet completion source
            "rafamadriz/friendly-snippets",   -- Useful snippets
        },
    },

    { 
      "nvim-tree/nvim-web-devicons", 
      opts = {},
    },

    {
        "rust-lang/rust.vim",
        ft = "rust",
        init = function ()
          vim.g.rustfmt_autosave = 1
        end
    },

    {
      "dart-lang/dart-vim-plugin",
      ft = "dart",
      init = function()
        vim.g.dart_format_on_save = 1
      end,
    },

    {
        "nvim-flutter/flutter-tools.nvim",
    },
})
