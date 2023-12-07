local whichkey_defaults = {
	mode = { "n", "v" },
	["g"] = { name = "+goto" },
	["gs"] = { name = "+surround" },
	["]"] = { name = "+next" },
	["["] = { name = "+prev" },
}

-- Move Lines
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("i", "<A-j>", "<esc>:m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "<A-k>", "<esc>:m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Clear search with <esc>
--vim.keymap.set("<esc>", ":noh<cr><esc>", "Escape and clear hlsearch", { "i", "n" })

-- +Next, ]
whichkey_defaults["]"] = { name = "+next" }
vim.keymap.set("n", "]<tab>", ":tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "]b", ":BufferLineCycleNext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "]h", require("gitsigns").next_hunk, { desc = "Next Hunk" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "jump to next diagnostic in buffer" })

-- +Prev, [
whichkey_defaults["["] = { name = "+prev" }
vim.keymap.set("n", "[<tab>", ":tabprev<cr>", { desc = "Prev Tab" })
vim.keymap.set("n", "[b", "BufferLineCycleNext", { desc = "Prev buffer" })
vim.keymap.set("n", "[h", require("gitsigns").prev_hunk, { desc = "Prev Hunk" })
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Prev quickfix" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic in buffer" })

-- save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", ":w<cr><esc>", { desc = "Save file" })

vim.keymap.set("n", "gR", require("telescope.builtin").lsp_references, { desc = "show definition, references" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "go to declaration" })
vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "show lsp definitions" })
vim.keymap.set("n", "gi", require("telescope.builtin").lsp_implementations, { desc = "show lsp implementations" })
vim.keymap.set("n", "gt", require("telescope.builtin").lsp_type_definitions, { desc = "show lsp type definitions" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "show documentation for what is under cursor" })

-- Pane and Window Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate Left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate Down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate Up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate Right" })
vim.keymap.set("t", "<C-h>", ":wincmd h<cr>", { desc = "Navigate Left" })
vim.keymap.set("t", "<C-j>", ":wincmd j<cr>", { desc = "Navigate Down" })
vim.keymap.set("t", "<C-k>", ":wincmd k<cr>", { desc = "Navigate Up" })
vim.keymap.set("t", "<C-l>", ":wincmd l<cr>", { desc = "Navigate Right" })
vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<cr>", { desc = "Navigate Left" })
vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<cr>", { desc = "Navigate Down" })
vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<cr>", { desc = "Navigate Up" })
vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<cr>", { desc = "Navigate Right" })

-- Indenting
vim.keymap.set("v", "<", "<gv", { desc = "Shift Indentation to Left" })
vim.keymap.set("v", ">", ">gv", { desc = "Shift Indentation to Right" })

-- Comments
vim.keymap.set({ "n", "v" }, "<C-_>", "gcc", { desc = "Toggle Comments" })

-- Easily return to dashboard
vim.keymap.set("n", "<leader>0", ":Alpha<cr>", { desc = "Intro Dashboard" })

vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment Number" })
vim.keymap.set("n", "<leader>_", "<C-x>", { desc = "Decrement Number" })

-- Quick Window Management
vim.keymap.set("n", "<leader>|", ":vsplit<cr>", { desc = "Split Vertically" })
vim.keymap.set("n", "<leader>-", ":split<cr>", { desc = "Split Horizontally" })

-- Command history
vim.keymap.set("n", "<leader>:", require("telescope.builtin").command_history, { desc = "Command History" })

-- Plugins, <leader>P
vim.keymap.set("n", "<leader>P", ":Lazy<cr>", { desc = "Lazy (Plugin Manager)" })

-- spider
vim.keymap.set({ "n", "o", "x" }, "<leader>w", ":lua require('spider').motion('w')<cr>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "<leader>e", ":lua require('spider').motion('e')<cr>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "<leader>b", ":lua require('spider').motion('b')<cr>", { desc = "Spider-b" })

-- +Tabs <leader><tab>
whichkey_defaults["<leader><tab>"] = { name = "+tabs" }
vim.keymap.set("n", "<leader><tab>$", ":tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>0", ":tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab>n", ":tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>l", ":tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>x", ":tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>h", ":tabprevious<cr>", { desc = "Prev Tab" })

-- +Code Actions <leader>c
whichkey_defaults["<leader>c"] = { name = "+code actions" }
vim.keymap.set("n", "<leader>cd", require("telescope.builtin").lsp_document_symbols, { desc = "Document Symbols" })
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	})
end, { desc = "Format" })
vim.keymap.set({ "n", "v" }, "<leader>cF", function()
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
		formatters = { "injected" },
	})
end, { desc = "Format Injected Langs" })
vim.keymap.set("n", "<leader>cL", require("lint").try_lint, { desc = "Trigger linting for current file" })
vim.keymap.set("n", "<leader>ci", ":LspInfo<cr>", { desc = "LSP Info" })
vim.keymap.set("n", "<leader>cI", vim.show_pos, { desc = "Inspect Pos" })
vim.keymap.set("n", "<leader>cm", ":Mason<cr>", { desc = "Mason" })
vim.keymap.set("n", "<leader>co", ":lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>cq", ":copen<cr>", { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>cQ", require("telescope.builtin").quickfix, { desc = "Telescope Quickfix" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>cR", ":LspRestart<cr>", { desc = "Restart LSP" })
vim.keymap.set(
	"n",
	"<leader>cw",
	require("telescope.builtin").lsp_dynamic_workspace_symbols,
	{ desc = "Workspace Symbols" }
)
vim.keymap.set("n", "<leader>cW", require("telescope.builtin").diagnostics, { desc = "Workspace diagnostics" })

-- +Debugging <leader>d
whichkey_defaults["<leader>d"] = { name = "+debug" }
vim.keymap.set("n", "<leader>db", require("dap").step_back, { desc = "Step Back" })
vim.keymap.set("n", "<leader>dc", require("dap").continue, { desc = "Continue" })
vim.keymap.set("n", "<leader>dC", require("dap").run_to_cursor, { desc = "Run To Cursor" })
vim.keymap.set("n", "<leader>dd", require("dap").disconnect, { desc = "Disconnect" })
vim.keymap.set({ "n", "v" }, "<leader>de", require("dapui").eval, { desc = "Eval" })
vim.keymap.set("n", "<leader>dg", require("dap").session, { desc = "Get Session" })
vim.keymap.set("n", "<leader>di", require("dap").step_into, { desc = "Step Into" })
vim.keymap.set("n", "<leader>do", require("dap").step_over, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dp", require("dap").pause, { desc = "Pause" })
vim.keymap.set("n", "<leader>dq", require("dap").close, { desc = "Quit" })
vim.keymap.set("n", "<leader>dr", require("dap").repl.toggle, { desc = "Toggle Repl" })
vim.keymap.set("n", "<leader>ds", require("dap").continue, { desc = "Start" })
vim.keymap.set("n", "<leader>dt", require("dap").toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>du", require("dap").step_out, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dU", function()
	require("dapui").toggle({ reset = true })
end, { desc = "Toggle UI" })

-- +Find/Files <leader>f
-- TODO: There are other bufferline options worth exploring
whichkey_defaults["<leader>f"] = { name = "+files/buffers" }
vim.keymap.set("n", "<leader>fb", function()
	require("neo-tree.command").execute({ source = "buffers", toggle = true })
end, { desc = "Buffer explorer" })
vim.keymap.set("n", "<leader>fB", require("telescope.builtin").buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fc", ":NvimTreeCollapse<cr>", { desc = "Collapse file explorer" })
vim.keymap.set("n", "<leader>fC", ":BufferLinePickClose<cr>", { desc = "Choose which buffer to close" })
vim.keymap.set("n", "<leader>fD", ":BufferLineSortByDirectory<cr>", { desc = "Sort by directory" })
vim.keymap.set("n", "<leader>fe", ":NvimTreeFindFile<cr>", { desc = "File explorer on current file" })
vim.keymap.set("n", "<leader>ff", ":NvimTreeToggle<cr>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>fF", require("telescope.builtin").find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fh", ":BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<leader>fH", ":BufferLineCloseLeft<cr>", { desc = "Close all buffers to the left" })
vim.keymap.set("n", "<leader>fj", ":BufferLinePick<cr>", { desc = "Jump" })
vim.keymap.set("n", "<leader>fl", ":BufferLineCycleNext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>fL", ":BufferLineCloseRight<cr>", { desc = "Close all buffers to the right" })
vim.keymap.set("n", "<leader>fn", ":enew<cr>", { desc = "New File/Buffer" })
vim.keymap.set("n", "<leader>fo", ":e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>fO", ":BufferLineCloseOthers<cr>", { desc = "Delete other buffers" })
vim.keymap.set("n", "<leader>fp", ":BufferLineTogglePin<cr>", { desc = "Toggle Pin" })
vim.keymap.set("n", "<leader>fP", ":BufferLineGroupClose ungrouped<cr>", { desc = "Delete non-pinned buffers" })
vim.keymap.set("n", "<leader>fr", require("telescope.builtin").oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fT", ":BufferLineSortByExtension<cr>", { desc = "Sort by type (File extension)" })
vim.keymap.set("n", "<leader>fW", ":noautocmd w<cr>", { desc = "Save without formatting (no autocmd)" })
vim.keymap.set("n", "<leader>fx", require("epicvim.util.buffer").buf_kill, { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>fX", function()
	require("epicvim.util.buffer").buf_kill(true)
end, { desc = "Delete Buffer (Force)" })
-- +Go (actions) <leader>g
whichkey_defaults["<leader>g"] = { name = "+go (actions)" }
vim.keymap.set({ "n", "o", "x" }, "<leader>ge", ":lua require('spider').motion('ge')<cr>", { desc = "Spider-ge" })

-- Panes <leader>p
whichkey_defaults["<leader>p"] = { name = "+panes" }
vim.keymap.set("n", "<leader>p-", "<C-W>s", { desc = "Split pane below", remap = true })
vim.keymap.set("n", "<leader>p|", "<C-W>v", { desc = "Split pane right", remap = true })
vim.keymap.set("n", "<leader>pf", ":MaximizerToggle<cr>", { desc = "Maximize/Unmaximize pane" })
vim.keymap.set("n", "<leader>pw", "<C-W>p", { desc = "Other pane", remap = true })
vim.keymap.set("n", "<leader>px", "<C-W>c", { desc = "Delete pane", remap = true })
vim.keymap.set("n", "<leader>p-", "<C-W>s", { desc = "Split pane below", remap = true })
vim.keymap.set("n", "<leader>p|", "<C-W>v", { desc = "Split pane right", remap = true })

-- +Session <leader>q
whichkey_defaults["<leader>q"] = { name = "+session" }
vim.keymap.set("n", "<leader>qd", require("persistence").stop, { desc = "Don't Save Current Session" })
vim.keymap.set("n", "<leader>ql", function()
	require("persistence").load({ last = true })
end, { desc = "Restore Last Session" })
vim.keymap.set("n", "<leader>qq", ":qa<cr>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>qs", require("persistence").load, { desc = "Restore Session" })
-- +search <leader>s
local function grep_in_search_dir()
	vim.ui.input({ prompt = "Which dir (ex: app/)? Relative to " .. vim.loop.cwd() }, function(dir)
		require("telescope.builtin").live_grep({ search_dirs = { dir } })
	end)
end
local function grep_in_cwd()
	require("telescope.builtin").live_grep({ cwd = require("telescope.utils").buffer_dir() })
end

whichkey_defaults["<leader>s"] = { name = "+search" }
vim.keymap.set("n", '<leader>s"', require("telescope.builtin").registers, { desc = "Registers" })
vim.keymap.set("n", "<leader>sa", require("telescope.builtin").autocommands, { desc = "Auto Commands" })
vim.keymap.set("n", "<leader>sb", require("telescope.builtin").current_buffer_fuzzy_find, { desc = "Buffer" })
vim.keymap.set("n", "<leader>sc", require("telescope.builtin").command_history, { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", require("telescope.builtin").commands, { desc = "Commands" })
vim.keymap.set("n", "<leader>sd", ":Telescope diagnostics bufnr=0<cr>", { desc = "Document diagnostics" })
vim.keymap.set("n", "<leader>sD", require("telescope.builtin").diagnostics, { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>sF", grep_in_search_dir, { desc = "Grep (Specify directory)" })
vim.keymap.set("n", "<leader>sg", grep_in_cwd, { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>sG", require("telescope.builtin").live_grep, { desc = "Grep (root dir)" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", require("telescope.builtin").highlights, { desc = "Search Highlight Groups" })
vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps, { desc = "Key Maps" })
vim.keymap.set("n", "<leader>sK", function()
	vim.cmd("enew")
	vim.cmd(":put = execute('verbose map')")
end, { desc = "Verbose Key Maps" })
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
vim.keymap.set("n", "<leader>sW", ":Telescope grep_string cwd=false word_match='-w'<cr>", { desc = "Word (root dir)" })

-- +Set/Toggle Session Features <leader>S
whichkey_defaults["<leader>S"] = { name = "+Set/Toggle Session Features" }
vim.keymap.set("n", "<leader>Sc", function()
	vim.ui.select({ 0, 1, 2, 3 }, {}, function(selection)
		vim.opt.conceallevel = selection
		print("Set conceallevel to " .. selection)
	end)
end, { desc = "Set Concellevel" })
vim.keymap.set("n", "<leader>SC", function()
	require("telescope.builtin").colorscheme({ enable_preview = true })
end, { desc = "Colorscheme with preview" })
vim.keymap.set("n", "<leader>Sd", function()
	local status = vim.diagnostic.is_disabled()
	if status == false then
		vim.diagnostic.disable()
		print("Diagnostics disabled")
	else
		vim.diagnostic.enable()
		print("Diagnostics enabled")
	end
end, { desc = "Toggle diagnostics" })
vim.keymap.set("n", "<leader>Sf", function()
	if vim.g.autoformat ~= nil and vim.g.autoformat == true then
		vim.g.autoformat = false
		require("conform").setup({ format_on_save = false })
		print("Disabled autoformatting")
	else
		vim.g.autoformat = true
		require("conform").setup({
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})
		print("Enabled autoformatting")
	end
end, { desc = "Toggle auto format" })
if vim.lsp.inlay_hint then
	vim.keymap.set("<leader>Sh", function()
		vim.lsp.inlay_hint(0, nil)
	end, { desc = "Toggle Inlay Hints" })
end
vim.keymap.set("n", "<leader>SH", function()
	local status = require("hardtime").is_plugin_enabled
	status = not status
	if status then
		require("hardtime").enable()
		print("Hardtime enabled")
	else
		require("hardtime").disable()
		print("Hardtime disabled")
	end
end, { desc = "Toggle Hardtime" })
vim.keymap.set("n", "<leader>Si", function()
	local paused = require("illuminate.engine").is_paused()
	paused = not paused
	require("illuminate.engine").toggle()
	if paused then
		print("Illuminate paused")
	else
		print("Illuminate started")
	end
end, { desc = "Toggle Illiminate" })
vim.keymap.set("n", "<leader>Sl", function()
	local status = vim.o["number"]
	status = not status
	vim.o["number"] = status
	if status == false then
		vim.o["relativenumber"] = false
	end
	if status then
		print("Line numbers enabled")
	else
		print("Line numbers disabled")
	end
end, { desc = "Toggle Line Numbers" })
vim.keymap.set("n", "<leader>Sp", function()
	if vim.g.autopairs ~= nil and vim.g.autopairs == true then
		vim.g.autopairs = false
		require("nvim-autopairs").enable()
		print("Autopairs enabled")
	else
		vim.g.autopairs = true
		require("nvim-autopairs").disable()
		print("Autopairs disabled")
	end
end, { desc = "Toggle auto pairs" })
vim.keymap.set("n", "<leader>Sr", function()
	local status = vim.o["relativenumber"]
	status = not status
	vim.o["relativenumber"] = status
	if status then
		print("Relative line number enabled")
	else
		print("Relative line number disabled")
	end
end, { desc = "Toggle relative line numbers" })
vim.keymap.set("n", "<leader>Ss", function()
	local status = vim.opt["spell"]
	status = not status
	vim.opt["spell"] = status
	if status then
		print("Spell enabled")
	else
		print("Spell disabled")
	end
end, { desc = "Toggle Spelling" })
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
vim.keymap.set("n", "<leader>Sw", function()
	local status = vim.o["wrap"]
	status = not status
	vim.o["wrap"] = status
	if status then
		print("Wrap enabled")
	else
		print("Wrap disabled")
	end
end, { desc = "Toggle Word Wrap" })

-- Version Control <leader>v
whichkey_defaults["<leader>v"] = { name = "+version control" }
vim.keymap.set("n", "<leader>vb", ":Telescope git_branches<cr>", { desc = "Checkout branch" })
vim.keymap.set("n", "<leader>vB", require("gitsigns").blame_line, { desc = "Blame" })
vim.keymap.set("n", "<leader>vC", ":Telescope git_bcommits<cr>", { desc = "Checkout commit(for current file)" })
vim.keymap.set("n", "<leader>vc", ":Telescope git_commits<cr>", { desc = "Checkout commit" })
vim.keymap.set("n", "<leader>vd", ":Gitsigns diffthis HEAD<cr>", { desc = "Git Diff (against head)" })
vim.keymap.set("n", "<leader>ve", function()
	require("neo-tree.command").execute({ source = "git_status", toggle = true })
end, { desc = "Git explorer" })
vim.keymap.set("n", "<leader>vG", ":AdvancedGitSearch<cr>", { desc = "Advanced Git Search" })
vim.keymap.set("n", "<leader>vj", require("gitsigns").next_hunk, { desc = "Next Hunk" })
vim.keymap.set("n", "<leader>vk", require("gitsigns").prev_hunk, { desc = "Prev Hunk" })
vim.keymap.set("n", "<leader>vl", ":LazyGit<cr>", { desc = "Lazygit (cwd)" })
vim.keymap.set("n", "<leader>vL", ":LazyGitCurrentFile<cr>", { desc = "Lazygit (Current File)" })
vim.keymap.set("n", "<leader>vo", require("telescope.builtin").git_status, { desc = "Open changed file" })
vim.keymap.set("n", "<leader>vp", require("gitsigns").preview_hunk, { desc = "Preview Hunk" })
vim.keymap.set("n", "<leader>vr", require("gitsigns").reset_hunk, { desc = "Reset Hunk" })
vim.keymap.set("n", "<leader>vs", require("gitsigns").stage_hunk, { desc = "Stage Hunk" })
vim.keymap.set("n", "<leader>vu", require("gitsigns").undo_stage_hunk, { desc = "Undo Stage Hunk" })
vim.keymap.set("n", "<leader>vU", ":Telescope undo<cr>", { desc = "View Undo History" })

whichkey_defaults["[{"] = "Prev {"
whichkey_defaults["[("] = "Prev ("
whichkey_defaults["[<lt>"] = "Prev <"
whichkey_defaults["[m"] = "Prev method start"
whichkey_defaults["[M"] = "Prev method end"
whichkey_defaults["[%"] = "Prev unmatched group"
whichkey_defaults["[s"] = "Prev misspelled word"
whichkey_defaults["<leader>e"] = "End of this Subword"
whichkey_defaults["<leader>w"] = "Start of next Subword"
whichkey_defaults["<leader>b"] = "Beginning of this Subword"

require("which-key").register(whichkey_defaults)
