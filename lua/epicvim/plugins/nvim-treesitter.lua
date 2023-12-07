return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			-- import nvim-treesitter plugin
			local treesitter = require("nvim-treesitter.configs")

			-- configure treesitter
			treesitter.setup({ -- enable syntax highlighting
				highlight = {
					enable = true,
				},
				-- enable indentation
				indent = { enable = true },
				-- enable autotagging (w/ nvim-ts-autotag plugin)
				autotag = {
					enable = true,
				},
				-- ensure these language parsers are installed
				ensure_installed = {
					"json",
					"javascript",
					"typescript",
					"tsx",
					"yaml",
					"html",
					"css",
					"prisma",
					"markdown_inline",
					"bash",
					"lua",
					"luadoc",
					"python",
					"regex",
					"vim",
					"dockerfile",
					"gitignore",
					"query",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
				-- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
			})
			vim.keymap.set("n", "<leader>St", function()
				require("treesitter-context").toggle()
				print("Treesitter context toggled")
			end, { desc = "Toggle Treesitter Context" })
			vim.keymap.set("n", "<leader>ST", function()
				if vim.b.ts_highlight then
					vim.treesitter.stop()
					print("Disabled Treesitter Highlight")
				else
					vim.treesitter.start()
					print("Enabled Treesitter Highlight")
				end
			end, { desc = "Toggle Treesitter Highlight" })
			vim.keymap.set("n", "<leader>vo", require("telescope.builtin").git_status, { desc = "Open changed file" })
			vim.keymap.set("n", "<leader>vb", ":Telescope git_branches<cr>", { desc = "Checkout branch" })
			vim.keymap.set(
				"n",
				"<leader>vC",
				":Telescope git_bcommits<cr>",
				{ desc = "Checkout commit(for current file)" }
			)
			vim.keymap.set("n", "<leader>vc", ":Telescope git_commits<cr>", { desc = "Checkout commit" })
			vim.keymap.set("n", "<leader>vU", ":Telescope undo<cr>", { desc = "View Undo History" })
		end,
	},
	-- Show context of the current function
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		enabled = true,
		opts = { mode = "cursor", max_lines = 3 },
	},
}
