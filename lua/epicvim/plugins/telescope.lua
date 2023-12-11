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
				undo = {},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("neoclip")
		telescope.load_extension("ui-select")
		vim.g.zoxide_use_select = true
		telescope.load_extension("undo")
		telescope.load_extension("advanced_git_search")
		telescope.load_extension("live_grep_args")

		vim.keymap.set("n", "gR", require("telescope.builtin").lsp_references, { desc = "show definition, references" })
		vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "show lsp definitions" })
		vim.keymap.set(
			"n",
			"gi",
			require("telescope.builtin").lsp_implementations,
			{ desc = "show lsp implementations" }
		)
		vim.keymap.set(
			"n",
			"gt",
			require("telescope.builtin").lsp_type_definitions,
			{ desc = "show lsp type definitions" }
		)
		vim.keymap.set("n", "<leader>:", require("telescope.builtin").command_history, { desc = "Command History" })
		vim.keymap.set(
			"n",
			"<leader>cd",
			require("telescope.builtin").lsp_document_symbols,
			{ desc = "Document Symbols" }
		)
		vim.keymap.set({ "n", "v" }, "<leader>cf", function()
			require("conform").format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format" })
		vim.keymap.set(
			"n",
			"<leader>cw",
			require("telescope.builtin").lsp_dynamic_workspace_symbols,
			{ desc = "Workspace Symbols" }
		)
		vim.keymap.set("n", "<leader>cW", require("telescope.builtin").diagnostics, { desc = "Workspace diagnostics" })
		vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Find Buffers" })
		vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find files" })
		vim.keymap.set("n", "<leader>fr", require("telescope.builtin").oldfiles, { desc = "Recent files" })
		vim.keymap.set("n", '<leader>s"', require("telescope.builtin").registers, { desc = "Registers" })
		vim.keymap.set("n", "<leader>sa", require("telescope.builtin").autocommands, { desc = "Auto Commands" })
		vim.keymap.set("n", "<leader>sb", require("telescope.builtin").current_buffer_fuzzy_find, { desc = "Buffer" })
		vim.keymap.set("n", "<leader>sc", require("telescope.builtin").command_history, { desc = "Command History" })
		vim.keymap.set("n", "<leader>sC", require("telescope.builtin").commands, { desc = "Commands" })
		vim.keymap.set("n", "<leader>sd", ":Telescope diagnostics bufnr=0<cr>", { desc = "Document diagnostics" })
		vim.keymap.set("n", "<leader>sD", require("telescope.builtin").diagnostics, { desc = "Workspace diagnostics" })
		vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "Find files" })
		vim.keymap.set("n", "<leader>sF", function()
			vim.ui.input({ prompt = "Which dir (ex: app/)? Relative to " .. vim.loop.cwd() }, function(dir)
				require("telescope.builtin").live_grep({ search_dirs = { dir } })
			end)
		end, { desc = "Grep (Specify directory)" })
		vim.keymap.set("n", "<leader>sg", function()
			require("telescope.builtin").live_grep({ cwd = require("telescope.utils").buffer_dir() })
		end, { desc = "Grep (cwd)" })
		vim.keymap.set("n", "<leader>sG", require("telescope.builtin").live_grep, { desc = "Grep (root dir)" })
		vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "Help Pages" })
		vim.keymap.set("n", "<leader>sH", require("telescope.builtin").highlights, { desc = "Search Highlight Groups" })
		vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps, { desc = "Key Maps" })
		vim.keymap.set("n", "<leader>sM", require("telescope.builtin").man_pages, { desc = "Man Pages" })
		vim.keymap.set("n", "<leader>sm", require("telescope.builtin").marks, { desc = "Jump to Mark" })
		vim.keymap.set("n", "<leader>so", require("telescope.builtin").vim_options, { desc = "Options" })
		vim.keymap.set("n", "<leader>sr", require("telescope.builtin").oldfiles, { desc = "Recent" })
		vim.keymap.set("n", "<leader>sR", require("telescope.builtin").resume, { desc = "Resume" })
		vim.keymap.set(
			"n",
			"<leader>ss",
			require("telescope.builtin").lsp_document_symbols,
			{ desc = "Goto Symbol (Document)" }
		)
		vim.keymap.set(
			"n",
			"<leader>sS",
			require("telescope.builtin").lsp_dynamic_workspace_symbols,
			{ desc = "Goto Symbol (Workspace)" }
		)
		vim.keymap.set("n", "<leader>sw", ":Telescope grep_string word_match='-w'<cr>", { desc = "Word (cwd)" })
		vim.keymap.set(
			"n",
			"<leader>sW",
			":Telescope grep_string cwd=false word_match='-w'<cr>",
			{ desc = "Word (root dir)" }
		)
		vim.keymap.set("n", "<leader>SC", function()
			require("telescope.builtin").colorscheme({ enable_preview = true })
		end, { desc = "Colorscheme with preview" })
		vim.keymap.set("n", "<leader>cQ", require("telescope.builtin").quickfix, { desc = "Telescope Quickfix" })
	end,
}
