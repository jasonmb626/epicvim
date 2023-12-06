-----------------------------  Define some helper functions --------------------------------------
--              These are for allowing imports to be based on relative path
--https://stackoverflow.com/questions/72921364/whats-the-lua-equivalent-of-pythons-endswith
local function endswith(str, suffix)
	return str:sub(-#suffix) == suffix
end

--https://stackoverflow.com/questions/1426954/split-string-in-lua
local function split(str, sep)
	local result = {}
	local regex = ("([^%s]+)"):format(sep)
	for each in str:gmatch(regex) do
		table.insert(result, each)
	end
	return result
end

local function get_parent_path(cwd)
	local splitpath = split(cwd, ".")
	table.remove(splitpath)
	return table.concat(splitpath, ".") -- this is now one directory up from cwd in lua format
end

local function get_revised_cwd(dotdotdot)
	-- if file ends in init.lua return dotdotdot otherwise go up one "dot"
	local filename = debug.getinfo(1, "S").source
	if endswith(filename, "init.lua") then
		return dotdotdot
	else
		return get_parent_path(dotdotdot)
	end
end

-----------------------------  Start of actual config --------------------------------------------
local folder_this_file = get_revised_cwd(...)
local parent_path = get_parent_path(folder_this_file)

local wk = require("which-key")
local bind = require(parent_path .. ".util.function_binder")
local Telescope = require("telescope.builtin")
local conform = require("conform")
local lint = require("lint")
local dap = require("dap")
local dapui = require("dapui")
local persistence = require("persistence")
local toggle = require(parent_path .. ".util").toggle
local gitsigns = require("gitsigns")
local neotreecmd = require("neo-tree.command")
local buf_kill = require(parent_path .. ".util.buffer").buf_kill
local toggle_autopairs = require(parent_path .. ".util").toggle_autopairs
local toggle_ts_highlights = require(parent_path .. ".util").toggle_ts_highlights
local toggle_autoformatting = require(parent_path .. ".util").toggle_autoformatting
local toggle_diagnostics = require(parent_path .. ".util").toggle_diagnostics
local toggle_hardtime = require(parent_path .. ".util").toggle_hardtime
local toggle_treesitter_context = require(parent_path .. ".util").toggle_treesitter_context
local set_conceallevel = require(parent_path .. ".util").set_conceallevel
local toggle_illuminate = require(parent_path .. ".util").toggle_illuminate

local format_options = require(parent_path .. ".config.formatting").format_options

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
vim.keymap.set("n", "]h", gitsigns.next_hunk, { desc = "Next Hunk" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "jump to next diagnostic in buffer" })

-- +Prev, [
whichkey_defaults["["] = { name = "+prev" }
vim.keymap.set("n", "[<tab>", ":tabprev<cr>", { desc = "Prev Tab" })
vim.keymap.set("n", "[b", "BufferLineCycleNext", { desc = "Prev buffer" })
vim.keymap.set("n", "[h", gitsigns.prev_hunk, { desc = "Prev Hunk" })
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Prev quickfix" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic in buffer" })

-- save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", ":w<cr><esc>", { desc = "Save file" })

vim.keymap.set("n", "gR", Telescope.lsp_references, { desc = "show definition, references" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "go to declaration" })
vim.keymap.set("n", "gd", Telescope.lsp_definitions, { desc = "show lsp definitions" })
vim.keymap.set("n", "gi", Telescope.lsp_implementations, { desc = "show lsp implementations" })
vim.keymap.set("n", "gt", Telescope.lsp_type_definitions, { desc = "show lsp type definitions" })
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
vim.keymap.set("n", "<leader>:", Telescope.command_history, { desc = "Command History" })

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
local fo_injected = vim.deepcopy(format_options)
fo_injected.formatters = { "injected" }
vim.keymap.set("n", "<leader>cd", Telescope.lsp_document_symbols, { desc = "Document Symbols" })
vim.keymap.set({ "n", "v" }, "<leader>cf", bind(conform.format, "A", format_options), { desc = "Format" })
vim.keymap.set({ "n", "v" }, "<leader>cF", bind(conform.format, "A", fo_injected), { desc = "Format Injected Langs" })
vim.keymap.set("n", "<leader>cL", lint.try_lint, { desc = "Trigger linting for current file" })
vim.keymap.set("n", "<leader>ci", ":LspInfo<cr>", { desc = "LSP Info" })
vim.keymap.set("n", "<leader>cI", vim.show_pos, { desc = "Inspect Pos" })
vim.keymap.set("n", "<leader>cm", ":Mason<cr>", { desc = "Mason" })
vim.keymap.set("n", "<leader>co", ":lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>cq", ":copen<cr>", { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>cQ", Telescope.quickfix, { desc = "Telescope Quickfix" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>cR", ":LspRestart<cr>", { desc = "Restart LSP" })
vim.keymap.set("n", "<leader>cw", Telescope.lsp_dynamic_workspace_symbols, { desc = "Workspace Symbols" })
vim.keymap.set("n", "<leader>cW", Telescope.diagnostics, { desc = "Workspace diagnostics" })

-- +Debugging <leader>d
whichkey_defaults["<leader>d"] = { name = "+debug" }
vim.keymap.set("n", "<leader>db", dap.step_back, { desc = "Step Back" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run To Cursor" })
vim.keymap.set("n", "<leader>dd", dap.disconnect, { desc = "Disconnect" })
vim.keymap.set({ "n", "v" }, "<leader>de", dapui.eval, { desc = "Eval" })
vim.keymap.set("n", "<leader>dg", dap.session, { desc = "Get Session" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dp", dap.pause, { desc = "Pause" })
vim.keymap.set("n", "<leader>dq", dap.close, { desc = "Quit" })
vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle Repl" })
vim.keymap.set("n", "<leader>ds", dap.continue, { desc = "Start" })
vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dU", bind(dapui.toggle, "A", { reset = true }), { desc = "Toggle UI" })

-- +Find/Files <leader>f
-- TODO: There are other bufferline options worth exploring
whichkey_defaults["<leader>f"] = { name = "+files/buffers" }
--local ttopts = {
--	find_files = false,
--	focus = true,
--	update_root = false,
--}
vim.keymap.set(
	"n",
	"<leader>fb",
	bind(neotreecmd.execute, "A", { source = "buffers", toggle = true }),
	{ desc = "Buffer explorer" }
)
vim.keymap.set("n", "<leader>fB", Telescope.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fc", ":NvimTreeCollapse<cr>", { desc = "Collapse file explorer" })
vim.keymap.set("n", "<leader>fC", ":BufferLinePickClose<cr>", { desc = "Choose which buffer to close" })
vim.keymap.set("n", "<leader>fD", ":BufferLineSortByDirectory<cr>", { desc = "Sort by directory" })
vim.keymap.set("n", "<leader>fe", ":NvimTreeFindFile<cr>", { desc = "File explorer on current file" })
vim.keymap.set("n", "<leader>ff", ":NvimTreeToggle<cr>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>fF", Telescope.find_files, { desc = "Find files" })
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
vim.keymap.set("n", "<leader>fr", Telescope.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fT", ":BufferLineSortByExtension<cr>", { desc = "Sort by type (File extension)" })
vim.keymap.set("n", "<leader>fW", ":noautocmd w<cr>", { desc = "Save without formatting (no autocmd)" })
vim.keymap.set("n", "<leader>fx", buf_kill, { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>fX", bind(buf_kill, { desc = "A" }, true), { desc = "Delete Buffer (Force)" })

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
vim.keymap.set("n", "<leader>qd", persistence.stop, { desc = "Don't Save Current Session" })
vim.keymap.set("n", "<leader>ql", bind(persistence.load, "A", { last = true }), { desc = "Restore Last Session" })
vim.keymap.set("n", "<leader>qq", ":qa<cr>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>qs", persistence.load, { desc = "Restore Session" })

-- +search <leader>s
local function grep_in_search_dir()
	vim.ui.input({ prompt = "Which dir (ex: app/)? Relative to " .. vim.loop.cwd() }, function(dir)
		Telescope.live_grep({ search_dirs = { dir } })
	end)
end
local function grep_in_cwd()
	Telescope.live_grep({ cwd = require("telescope.utils").buffer_dir() })
end

whichkey_defaults["<leader>s"] = { name = "+search" }
vim.keymap.set("n", '<leader>s"', Telescope.registers, { desc = "Registers" })
vim.keymap.set("n", "<leader>sa", Telescope.autocommands, { desc = "Auto Commands" })
vim.keymap.set("n", "<leader>sb", Telescope.current_buffer_fuzzy_find, { desc = "Buffer" })
vim.keymap.set("n", "<leader>sc", Telescope.command_history, { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", Telescope.commands, { desc = "Commands" })
vim.keymap.set("n", "<leader>sd", ":Telescope diagnostics bufnr=0<cr>", { desc = "Document diagnostics" })
vim.keymap.set("n", "<leader>sD", Telescope.diagnostics, { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>sf", Telescope.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>sF", grep_in_search_dir, { desc = "Grep (Specify directory)" })
vim.keymap.set("n", "<leader>sg", grep_in_cwd, { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>sG", Telescope.live_grep, { desc = "Grep (root dir)" })
vim.keymap.set("n", "<leader>sh", Telescope.help_tags, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", Telescope.highlights, { desc = "Search Highlight Groups" })
vim.keymap.set("n", "<leader>sk", Telescope.keymaps, { desc = "Key Maps" })
vim.keymap.set("n", "<leader>sK", function()
	vim.cmd("enew")
	vim.cmd(":put = execute('verbose map')")
end, { desc = "Verbose Key Maps" })
vim.keymap.set("n", "<leader>sM", Telescope.man_pages, { desc = "Man Pages" })
vim.keymap.set("n", "<leader>sm", Telescope.marks, { desc = "Jump to Mark" })
vim.keymap.set("n", "<leader>so", Telescope.vim_options, { desc = "Options" })
vim.keymap.set("n", "<leader>sr", Telescope.oldfiles, { desc = "Recent" })
vim.keymap.set("n", "<leader>sR", Telescope.resume, { desc = "Resume" })
vim.keymap.set("n", "<leader>ss", Telescope.lsp_document_symbols, { desc = "Goto Symbol (Document)" })
vim.keymap.set("n", "<leader>sS", Telescope.lsp_dynamic_workspace_symbols, { desc = "Goto Symbol (Workspace)" })
vim.keymap.set("n", "<leader>sw", ":Telescope grep_string word_match='-w'<cr>", { desc = "Word (cwd)" })
vim.keymap.set("n", "<leader>sW", ":Telescope grep_string cwd=false word_match='-w'<cr>", { desc = "Word (root dir)" })

-- +Set/Toggle Session Features <leader>S
whichkey_defaults["<leader>S"] = { name = "+Set/Toggle Session Features" }
vim.keymap.set("n", "<leader>Sc", set_conceallevel, { desc = "Set Concellevel" })
vim.keymap.set(
	"n",
	"<leader>SC",
	bind(Telescope.colorscheme, { desc = "A" }, { enable_preview = true }),
	{ desc = "Colorscheme with preview" }
)
vim.keymap.set("n", "<leader>Sd", toggle_diagnostics, { desc = "Toggle diagnostics" })
vim.keymap.set("n", "<leader>Sf", toggle_autoformatting, { desc = "Toggle auto format" })
if vim.lsp.inlay_hint then
	vim.keymap.set("<leader>Sh", function()
		vim.lsp.inlay_hint(0, nil)
	end, { desc = "Toggle Inlay Hints" })
end
vim.keymap.set("n", "<leader>SH", toggle_hardtime, { desc = "Toggle Hardtime" })
vim.keymap.set("n", "<leader>Si", toggle_illuminate, { desc = "Toggle Illiminate" })
vim.keymap.set("n", "<leader>Sl", bind(toggle, "A", "number"), { desc = "Toggle Line Numbers" })
vim.keymap.set("n", "<leader>Sp", toggle_autopairs, { desc = "Toggle auto pairs" })
vim.keymap.set("n", "<leader>Sr", bind(toggle, "A", "relativenumber"), { desc = "Toggle Relative Line Numbers" })
vim.keymap.set("n", "<leader>Ss", bind(toggle, "A", "spell"), { desc = "Toggle Spelling" })
vim.keymap.set("n", "<leader>St", toggle_treesitter_context, { desc = "Toggle Treesitter Context" })
vim.keymap.set("n", "<leader>ST", toggle_ts_highlights, { desc = "Toggle Treesitter Highlight" })
vim.keymap.set("n", "<leader>Sw", bind(toggle, "A", "wrap"), { desc = "Toggle Word Wrap" })

-- Version Control <leader>v
whichkey_defaults["<leader>v"] = { name = "+version control" }
vim.keymap.set("n", "<leader>vb", ":Telescope git_branches<cr>", { desc = "Checkout branch" })
vim.keymap.set("n", "<leader>vB", gitsigns.blame_line, { desc = "Blame" })
vim.keymap.set("n", "<leader>vC", ":Telescope git_bcommits<cr>", { desc = "Checkout commit(for current file)" })
vim.keymap.set("n", "<leader>vc", ":Telescope git_commits<cr>", { desc = "Checkout commit" })
vim.keymap.set("n", "<leader>vd", ":Gitsigns diffthis HEAD<cr>", { desc = "Git Diff (against head)" })
vim.keymap.set(
	"n",
	"<leader>ve",
	bind(neotreecmd.execute, "A", { source = "git_status", toggle = true }),
	{ desc = "Git explorer" }
)
vim.keymap.set("n", "<leader>vG", ":AdvancedGitSearch<cr>", { desc = "Advanced Git Search" })
vim.keymap.set("n", "<leader>vj", gitsigns.next_hunk, { desc = "Next Hunk" })
vim.keymap.set("n", "<leader>vk", gitsigns.prev_hunk, { desc = "Prev Hunk" })
vim.keymap.set("n", "<leader>vl", ":LazyGit<cr>", { desc = "Lazygit (cwd)" })
vim.keymap.set("n", "<leader>vL", ":LazyGitCurrentFile<cr>", { desc = "Lazygit (Current File)" })
vim.keymap.set("n", "<leader>vo", Telescope.git_status, { desc = "Open changed file" })
vim.keymap.set("n", "<leader>vp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
vim.keymap.set("n", "<leader>vr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
vim.keymap.set("n", "<leader>vs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
vim.keymap.set("n", "<leader>vu", gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk" })
vim.keymap.set("n", "<leader>vU", ":Telescope undo<cr>", { desc = "View Undo History" })

-- Zen Mode <leader>z
whichkey_defaults["<leader>z"] = { name = "+zen" }
vim.keymap.set("n", "<leader>za", ":TZAtaraxis<cr>", { desc = "Zen Ataraxis" })
vim.keymap.set("n", "<leader>zf", ":TZFocus<cr>", { desc = "Zen Focus" })
vim.keymap.set("n", "<leader>zn", ":TZNarrow<cr>", { desc = "Zen Narrow" })
vim.keymap.set("v", "<leader>zn", ":'<,'>TZNarrow<cr>", { desc = "Zen Narrow" })
vim.keymap.set("n", "<leader>zm", ":TZMinimalist<cr>", { desc = "Zen Minimalist" })

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

wk.register(whichkey_defaults)
