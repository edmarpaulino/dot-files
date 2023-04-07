local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
    	'--filter=blob:none',
    	'https://github.com/folke/lazy.nvim.git',
    	'--branch=stable', -- latest stable release
    	lazypath,
  	})
end
vim.opt.rtp:prepend(lazypath)

-- setup(plugins, opts)
require('lazy').setup({
	'42Paris/42header',
	{ 'catppuccin/nvim', as = 'catppuccin' },
	'nvim-tree/nvim-tree.lua',
	'nvim-tree/nvim-web-devicons',
	'nvim-lualine/lualine.nvim',
	{ -- Fuzzy Finder (files, lsp, etc)
		'nvim-telescope/telescope.nvim',
		version = '*',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make',
		cond = function()
			return vim.fn.executable 'make' == 1
		end,
	},
	{ -- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
	config = function()
		pcall(require('nvim-treesitter.install').update { with_sync = true })
	end,
	},
	{ -- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ 'j-hui/fidget.nvim', opts = {} },
			-- Additional lua configuration, makes nvim stuff amazing!
			'folke/neodev.nvim',
		},
	},
	{ -- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
	},
	{-- Useful plugin to show you pending keybinds.
  		'folke/which-key.nvim',
		opts = {}
	},
  	-- Git related plugins
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',
	{ -- Adds git releated signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = { -- See `:help gitsigns.txt`
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		},
	},
	{ -- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		opts = {
			char = '│',
			show_trailing_blankline_indent = false,
		},
  },
}, {})
