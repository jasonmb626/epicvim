return {
	{ "folke/neoconf.nvim", cmd = "Neoconf" },

	"folke/neodev.nvim",

	"nvim-lua/plenary.nvim", -- lua functions that many plugins use

	"inkarkat/vim-ReplaceWithRegister", -- replace with register contents using motion (gr + motion)

	"nvim-tree/nvim-web-devicons", -- better icons for NeoTree

	"szw/vim-maximizer", -- Maximize/minimuze current window

	{
		"kylechui/nvim-surround",
		event = { "BufReadPre", "BufNewFile" },
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = true,
	},
	{
		"NvChad/nvim-colorizer.lua",
		event = { "BufReadPre", "BufNewFile" },
		config = true,
	},
	{
		"rmehri01/onenord.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			require("onenord").setup({
				disable = {
					background = true,
				},
			})
			vim.cmd([[colorscheme onenord]])
		end,
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
		lazy = false,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = true,
	},
	{
		"lewis6991/gitsigns.nvim",
		lazy = false,
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	{
		"windwp/nvim-ts-autotag",
		lazy = false,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		config = function()
			require("neo-tree").setup()
			vim.keymap.set("n", "<leader>ve", function()
				require("neo-tree.command").execute({ source = "git_status", toggle = true })
			end, { desc = "Git explorer" })
			vim.keymap.set("n", "<leader>fb", function()
				require("neo-tree.command").execute({ source = "buffers", toggle = true })
			end, { desc = "Buffer explorer" })
		end,
	},
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	"folke/neodev.nvim",
	{
		"chrisgrieser/nvim-various-textobjs",
		lazy = false,
		opts = { useDefaultKeymaps = true },
	},
}
