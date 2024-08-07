return {
	{ "folke/neoconf.nvim", cmd = "Neoconf" },

	"folke/neodev.nvim",

	{ "numToStr/Comment.nvim", opts = {} },

	"nvim-lua/plenary.nvim", -- lua functions that many plugins use

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
	{ "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
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
		end,
	},
	{
		"bluz71/vim-nightfly-colors",
		name = "nightfly",
		lazy = false,
		priority = 1000,
	},
	{
		"Tsuzat/NeoSolarized.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			--vim.cmd [[ colorscheme NeoSolarized ]]
		end,
	},
	-- {
	--   "lukas-reineke/indent-blankline.nvim",
	--   main = "ibl",
	--   opts = {},
	-- },
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
			vim.keymap.set("n", "<leader>fB", function()
				require("neo-tree.command").execute({ source = "buffers", toggle = true })
			end, { desc = "Buffer explorer" })
		end,
	},
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	"folke/neodev.nvim",
	{
		"chrisgrieser/nvim-various-textobjs",
		lazy = false,
		opts = { useDefaultKeymaps = true, disabledKeymaps = { "gc", "gb" } },
	},
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("undotree").setup()
			vim.keymap.set(
				"n",
				"<leader>vt",
				require("undotree").toggle,
				{ noremap = true, silent = true, desc = "Toggle undotree" }
			)
		end,
	},
}
