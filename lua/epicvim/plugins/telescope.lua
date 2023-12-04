return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			-- This will not install any breaking changes.
			-- For major updates, this must be adjusted manually.
			version = "^1.0.0",
		},
		"nvim-tree/nvim-web-devicons",
		"debugloop/telescope-undo.nvim",
		"AckslD/nvim-neoclip.lua",
		"nvim-telescope/telescope-ui-select.nvim",
		"aaronhallaert/advanced-git-search.nvim",
		-- to show diff splits and open commits in browser
		"tpope/vim-fugitive",
		-- to open commits in browser with fugitive
		"tpope/vim-rhubarb",
		-- optional: to replace the diff from fugitive with diffview.nvim
		-- (fugitive is still needed to open in browser)
		"sindrets/diffview.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local telescopeConfig = require("telescope.config")

		-- Clone the default Telescope configuration
		local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

		-- I want to search in hidden/dot files.
		table.insert(vimgrep_arguments, "--hidden")
		-- I don't want to search in the `.git` directory.
		table.insert(vimgrep_arguments, "--glob")
		table.insert(vimgrep_arguments, "!**/.git/*")

		local select_one_or_multi = function(prompt_bufnr)
			local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
			local multi = picker:get_multi_selection()
			if not vim.tbl_isempty(multi) then
				require("telescope.actions").close(prompt_bufnr)
				for _, j in pairs(multi) do
					if j.path ~= nil then
						vim.cmd(string.format("%s %s", "edit", j.path))
					end
				end
			else
				require("telescope.actions").select_default(prompt_bufnr)
			end
		end

		telescope.setup({
			defaults = {
				-- `hidden = true` is not supported in text grep commands.
				vimgrep_arguments = vimgrep_arguments,
				path_display = { "truncate " },
				mappings = {
					n = {
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<CR>"] = select_one_or_multi,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-S-d>"] = actions.delete_buffer,
					},
				},
			},
			pickers = {
				find_files = {
					-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
			},
			extensions = {
				undo = {
					use_delta = true,
					use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
					side_by_side = false,
					diff_context_lines = vim.o.scrolloff,
					entry_format = "state #$ID, $STAT, $TIME",
					mappings = {
						i = {
							["<C-cr>"] = require("telescope-undo.actions").yank_additions,
							["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
							["<cr>"] = require("telescope-undo.actions").restore,
						},
					},
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("neoclip")
		telescope.load_extension("ui-select")
		vim.g.zoxide_use_select = true
		telescope.load_extension("undo")
		telescope.load_extension("advanced_git_search")
		telescope.load_extension("live_grep_args")
	end,
}
