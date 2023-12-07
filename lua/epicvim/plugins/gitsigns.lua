return {
	"lewis6991/gitsigns.nvim",
	opts = {},
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			yadm = {
				enable = false,
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				vim.keymap.set("n", "]h", require("gitsigns").next_hunk, { desc = "Next Hunk" })
				vim.keymap.set("n", "[h", require("gitsigns").prev_hunk, { desc = "Prev Hunk" })
				vim.keymap.set("n", "<leader>vB", require("gitsigns").blame_line, { desc = "Blame" })
				vim.keymap.set("n", "<leader>vd", ":Gitsigns diffthis HEAD<cr>", { desc = "Git Diff (against head)" })
				vim.keymap.set("n", "<leader>vG", ":AdvancedGitSearch<cr>", { desc = "Advanced Git Search" })
				vim.keymap.set("n", "<leader>vj", require("gitsigns").next_hunk, { desc = "Next Hunk" })
				vim.keymap.set("n", "<leader>vk", require("gitsigns").prev_hunk, { desc = "Prev Hunk" })
				vim.keymap.set("n", "<leader>vp", require("gitsigns").preview_hunk, { desc = "Preview Hunk" })
				vim.keymap.set("n", "<leader>vr", require("gitsigns").reset_hunk, { desc = "Reset Hunk" })
				vim.keymap.set("n", "<leader>vs", require("gitsigns").stage_hunk, { desc = "Stage Hunk" })
				vim.keymap.set("n", "<leader>vu", require("gitsigns").undo_stage_hunk, { desc = "Undo Stage Hunk" })
			end,
		})
	end,
}
