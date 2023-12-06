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
local mapkey = require(parent_path .. ".util.keymapper").mapkey
local mapkey_cm = require(parent_path .. ".util.keymapper").mapkey_cm
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
mapkey("<A-j>", ":m .+1<cr>==", { desc = "Move down" })
mapkey("<A-k>", ":m .-2<cr>==", { desc = "Move up" })
mapkey("<A-j>", "<esc>:m .+1<cr>==gi", { desc = "Move down" }, "i")
mapkey("<A-k>", "<esc>:m .-2<cr>==gi", { desc = "Move up" }, "i")
mapkey("<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" }, "v")
mapkey("<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" }, "v")

-- Clear search with <esc>
--mapkey("<esc>", ":noh<cr><esc>", "Escape and clear hlsearch", { "i", "n" })

-- +Next, ]
whichkey_defaults["]"] = { name = "+next" }
mapkey_cm("]<tab>", "tabnext", { desc = "Next Tab" })
mapkey_cm("]b", "BufferLineCycleNext", { desc = "Next buffer" })
mapkey("]h", gitsigns.next_hunk, { desc = "Next Hunk" })
mapkey("]q", vim.cmd.cnext, { desc = "Next quickfix" })
mapkey("]d", vim.diagnostic.goto_next, { desc = "jump to next diagnostic in buffer" })

-- +Prev, [
whichkey_defaults["["] = { name = "+prev" }
mapkey_cm("[<tab>", "tabprev", { desc = "Prev Tab" })
mapkey_cm("[b", "BufferLineCyclePrev", { desc = "Prev buffer" })
mapkey("[h", gitsigns.prev_hunk, { desc = "Prev Hunk" })
mapkey("[q", vim.cmd.cprev, { desc = "Prev quickfix" })
mapkey("[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic in buffer" })

-- save file
mapkey("<C-s>", ":w<cr><esc>", "Save file", { "i", "x", "n", "s" })

mapkey("gR", Telescope.lsp_references, { desc = "show definition, references" })
mapkey("gD", vim.lsp.buf.declaration, { desc = "go to declaration" })
mapkey("gd", Telescope.lsp_definitions, { desc = "show lsp definitions" })
mapkey("gi", Telescope.lsp_implementations, { desc = "show lsp implementations" })
mapkey("gt", Telescope.lsp_type_definitions, { desc = "show lsp type definitions" })
mapkey("K", vim.lsp.buf.hover, { desc = "show documentation for what is under cursor" })

-- Pane and Window Navigation
mapkey("<C-h>", "<C-w>h", { desc = "Navigate Left" })
mapkey("<C-j>", "<C-w>j", { desc = "Navigate Down" })
mapkey("<C-k>", "<C-w>k", { desc = "Navigate Up" })
mapkey("<C-l>", "<C-w>l", { desc = "Navigate Right" })
mapkey_cm("<C-h>", "wincmd h", { desc = "Navigate Left" }, "t")
mapkey_cm("<C-j>", "wincmd j", { desc = "Navigate Down" }, "t")
mapkey_cm("<C-k>", "wincmd k", { desc = "Navigate Up" }, "t")
mapkey_cm("<C-l>", "wincmd l", { desc = "Navigate Right" }, "t")
mapkey_cm("<C-h>", "TmuxNavigateLeft", { desc = "Navigate Left" })
mapkey_cm("<C-j>", "TmuxNavigateDown", { desc = "Navigate Down" })
mapkey_cm("<C-k>", "TmuxNavigateUp", { desc = "Navigate Up" })
mapkey_cm("<C-l>", "TmuxNavigateRight", { desc = "Navigate Right" })

-- Indenting
mapkey("<", "<gv", { desc = "Shift Indentation to Left" }, "v")
mapkey(">", ">gv", { desc = "Shift Indentation to Right" }, "v")

-- Comments
mapkey("<C-_>", "gcc", { desc = "Toggle Comments" }, { "n", "v" })

-- Easily return to dashboard
mapkey_cm("<leader>0", "Alpha", { desc = "Intro Dashboard" })

mapkey("<leader>+", "<C-a>", { desc = "Increment Number" })
mapkey("<leader>_", "<C-x>", { desc = "Decrement Number" })

-- Quick Window Management
mapkey_cm("<leader>|", "vsplit", { desc = "Split Vertically" })
mapkey_cm("<leader>-", "split", { desc = "Split Horizontally" })

-- Command history
mapkey("<leader>:", Telescope.command_history, { desc = "Command History" })

-- Plugins, <leader>P
mapkey_cm("<leader>P", "Lazy", { desc = "Lazy (Plugin Manager)" })

-- spider
mapkey_cm("<leader>w", "lua require('spider').motion('w')", { desc = "Spider-w" }, { "n", "o", "x" })
mapkey_cm("<leader>e", "lua require('spider').motion('e')", { desc = "Spider-e" }, { "n", "o", "x" })
mapkey_cm("<leader>b", "lua require('spider').motion('b')", { desc = "Spider-b" }, { "n", "o", "x" })

-- +Tabs <leader><tab>
whichkey_defaults["<leader><tab>"] = { name = "+tabs" }
mapkey_cm("<leader><tab>$", "tablast", { desc = "Last Tab" })
mapkey_cm("<leader><tab>0", "tabfirst", { desc = "First Tab" })
mapkey_cm("<leader><tab>n", "tabnew", { desc = "New Tab" })
mapkey_cm("<leader><tab>l", "tabnext", { desc = "Next Tab" })
mapkey_cm("<leader><tab>x", "tabclose", { desc = "Close Tab" })
mapkey_cm("<leader><tab>h", "tabprevious", { desc = "Prev Tab" })

-- +Code Actions <leader>c
whichkey_defaults["<leader>c"] = { name = "+code actions" }
local fo_injected = vim.deepcopy(format_options)
fo_injected.formatters = { "injected" }
mapkey("<leader>cd", Telescope.lsp_document_symbols, { desc = "Document Symbols" })
mapkey("<leader>cf", bind(conform.format, "A", format_options), { desc = "Format" }, { "n", "v" })
mapkey("<leader>cF", bind(conform.format, "A", fo_injected), { desc = "Format Injected Langs" }, { "n", "v" })
mapkey("<leader>cL", lint.try_lint, { desc = "Trigger linting for current file" })
mapkey_cm("<leader>ci", "LspInfo", { desc = "LSP Info" })
mapkey("<leader>cI", vim.show_pos, { desc = "Inspect Pos" })
mapkey_cm("<leader>cm", "Mason", { desc = "Mason" })
mapkey_cm("<leader>co", "lopen", { desc = "Location List" })
mapkey_cm("<leader>cq", "copen", { desc = "Quickfix List" })
mapkey("<leader>cQ", Telescope.quickfix, { desc = "Telescope Quickfix" })
mapkey("<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
mapkey_cm("<leader>cR", "LspRestart", { desc = "Restart LSP" })
mapkey("<leader>cw", Telescope.lsp_dynamic_workspace_symbols, { desc = "Workspace Symbols" })
mapkey("<leader>cW", Telescope.diagnostics, { desc = "Workspace diagnostics" })

-- +Debugging <leader>d
whichkey_defaults["<leader>d"] = { name = "+debug" }
mapkey("<leader>db", dap.step_back, { desc = "Step Back" })
mapkey("<leader>dc", dap.continue, { desc = "Continue" })
mapkey("<leader>dC", dap.run_to_cursor, { desc = "Run To Cursor" })
mapkey("<leader>dd", dap.disconnect, { desc = "Disconnect" })
mapkey("<leader>de", dapui.eval, { desc = "Eval" }, { "n", "v" })
mapkey("<leader>dg", dap.session, { desc = "Get Session" })
mapkey("<leader>di", dap.step_into, { desc = "Step Into" })
mapkey("<leader>do", dap.step_over, { desc = "Step Over" })
mapkey("<leader>dp", dap.pause, { desc = "Pause" })
mapkey("<leader>dq", dap.close, { desc = "Quit" })
mapkey("<leader>dr", dap.repl.toggle, { desc = "Toggle Repl" })
mapkey("<leader>ds", dap.continue, { desc = "Start" })
mapkey("<leader>dt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
mapkey("<leader>du", dap.step_out, { desc = "Step Out" })
mapkey("<leader>dU", bind(dapui.toggle, "A", { reset = true }), { desc = "Toggle UI" })

-- +Find/Files <leader>f
-- TODO: There are other bufferline options worth exploring
whichkey_defaults["<leader>f"] = { name = "+files/buffers" }
--local ttopts = {
--	find_files = false,
--	focus = true,
--	update_root = false,
--}
mapkey("<leader>fb", bind(neotreecmd.execute, "A", { source = "buffers", toggle = true }), { desc = "Buffer explorer" })
mapkey("<leader>fB", Telescope.buffers, { desc = "Find Buffers" })
mapkey_cm("<leader>fc", "NvimTreeCollapse", { desc = "Collapse file explorer" })
mapkey_cm("<leader>fC", "BufferLinePickClose", { desc = "Choose which buffer to close" })
mapkey_cm("<leader>fD", "BufferLineSortByDirectory", { desc = "Sort by directory" })
mapkey_cm("<leader>fe", "NvimTreeFindFile", { desc = "File explorer on current file" })
mapkey_cm("<leader>ff", "NvimTreeToggle", { desc = "Toggle file explorer" })
mapkey("<leader>fF", Telescope.find_files, { desc = "Find files" })
mapkey_cm("<leader>fh", "BufferLineCyclePrev", { desc = "Prev buffer" })
mapkey_cm("<leader>fH", "BufferLineCloseLeft", { desc = "Close all buffers to the left" })
mapkey_cm("<leader>fj", "BufferLinePick", { desc = "Jump" })
mapkey_cm("<leader>fl", "BufferLineCycleNext", { desc = "Next buffer" })
mapkey_cm("<leader>fL", "BufferLineCloseRight", { desc = "Close all buffers to the right" })
mapkey_cm("<leader>fn", "enew", { desc = "New File/Buffer" })
mapkey_cm("<leader>fo", "e #", { desc = "Switch to Other Buffer" })
mapkey_cm("<leader>fO", "BufferLineCloseOthers", { desc = "Delete other buffers" })
mapkey_cm("<leader>fp", "BufferLineTogglePin", { desc = "Toggle Pin" })
mapkey_cm("<leader>fP", "BufferLineGroupClose ungrouped", { desc = "Delete non-pinned buffers" })
mapkey("<leader>fr", Telescope.oldfiles, { desc = "Recent files" })
mapkey_cm("<leader>fT", "BufferLineSortByExtension", { desc = "Sort by type (File extension)" })
mapkey_cm("<leader>fW", "noautocmd w", { desc = "Save without formatting (no autocmd)" })
mapkey("<leader>fx", buf_kill, { desc = "Delete Buffer" })
mapkey("<leader>fX", bind(buf_kill, { desc = "A" }, true), { desc = "Delete Buffer (Force)" })

-- +Go (actions) <leader>g
whichkey_defaults["<leader>g"] = { name = "+go (actions)" }
mapkey_cm("<leader>ge", "lua require('spider').motion('ge')", { desc = "Spider-ge" }, { "n", "o", "x" })

-- Panes <leader>p
whichkey_defaults["<leader>p"] = { name = "+panes" }
mapkey("<leader>p-", "<C-W>s", { desc = "Split pane below", remap = true })
mapkey("<leader>p|", "<C-W>v", { desc = "Split pane right", remap = true })
mapkey_cm("<leader>pf", "MaximizerToggle", { desc = "Maximize/Unmaximize pane" })
mapkey("<leader>pw", "<C-W>p", { desc = "Other pane", remap = true })
mapkey("<leader>px", "<C-W>c", { desc = "Delete pane", remap = true })
mapkey("<leader>p-", "<C-W>s", { desc = "Split pane below", remap = true })
mapkey("<leader>p|", "<C-W>v", { desc = "Split pane right", remap = true })

-- +Session <leader>q
whichkey_defaults["<leader>q"] = { name = "+session" }
mapkey("<leader>qd", persistence.stop, { desc = "Don't Save Current Session" })
mapkey("<leader>ql", bind(persistence.load, "A", { last = true }), { desc = "Restore Last Session" })
mapkey_cm("<leader>qq", "qa", { desc = "Quit all" })
mapkey("<leader>qs", persistence.load, { desc = "Restore Session" })

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
mapkey('<leader>s"', Telescope.registers, { desc = "Registers" })
mapkey("<leader>sa", Telescope.autocommands, { desc = "Auto Commands" })
mapkey("<leader>sb", Telescope.current_buffer_fuzzy_find, { desc = "Buffer" })
mapkey("<leader>sc", Telescope.command_history, { desc = "Command History" })
mapkey("<leader>sC", Telescope.commands, { desc = "Commands" })
mapkey_cm("<leader>sd", "Telescope diagnostics bufnr=0", { desc = "Document diagnostics" })
mapkey("<leader>sD", Telescope.diagnostics, { desc = "Workspace diagnostics" })
mapkey("<leader>sf", Telescope.find_files, { desc = "Find files" })
mapkey("<leader>sF", grep_in_search_dir, { desc = "Grep (Specify directory)" })
mapkey("<leader>sg", grep_in_cwd, { desc = "Grep (cwd)" })
mapkey("<leader>sG", Telescope.live_grep, { desc = "Grep (root dir)" })
mapkey("<leader>sh", Telescope.help_tags, { desc = "Help Pages" })
mapkey("<leader>sH", Telescope.highlights, { desc = "Search Highlight Groups" })
mapkey("<leader>sk", Telescope.keymaps, { desc = "Key Maps" })
mapkey("<leader>sK", function()
	vim.cmd("enew")
	vim.cmd(":put = execute('verbose map')")
end, { desc = "Verbose Key Maps" })
mapkey("<leader>sM", Telescope.man_pages, { desc = "Man Pages" })
mapkey("<leader>sm", Telescope.marks, { desc = "Jump to Mark" })
mapkey("<leader>so", Telescope.vim_options, { desc = "Options" })
mapkey("<leader>sr", Telescope.oldfiles, { desc = "Recent" })
mapkey("<leader>sR", Telescope.resume, { desc = "Resume" })
mapkey("<leader>ss", Telescope.lsp_document_symbols, { desc = "Goto Symbol (Document)" })
mapkey("<leader>sS", Telescope.lsp_dynamic_workspace_symbols, { desc = "Goto Symbol (Workspace)" })
mapkey_cm("<leader>sw", "Telescope grep_string word_match='-w'", { desc = "Word (cwd)" })
mapkey_cm("<leader>sW", "Telescope grep_string cwd=false word_match='-w'", { desc = "Word (root dir)" })

-- +Set/Toggle Session Features <leader>S
whichkey_defaults["<leader>S"] = { name = "+Set/Toggle Session Features" }
mapkey("<leader>Sc", set_conceallevel, { desc = "Set Concellevel" })
mapkey_cm(
	"<leader>SC",
	bind(Telescope.colorscheme, { desc = "A" }, { enable_preview = true }),
	{ desc = "Colorscheme with preview" }
)
mapkey("<leader>Sd", toggle_diagnostics, { desc = "Toggle diagnostics" })
mapkey("<leader>Sf", toggle_autoformatting, { desc = "Toggle auto format" })
if vim.lsp.inlay_hint then
	mapkey("<leader>Sh", function()
		vim.lsp.inlay_hint(0, nil)
	end, { desc = "Toggle Inlay Hints" })
end
mapkey("<leader>SH", toggle_hardtime, { desc = "Toggle Hardtime" })
mapkey("<leader>Si", toggle_illuminate, { desc = "Toggle Illiminate" })
mapkey("<leader>Sl", bind(toggle, "A", "number"), { desc = "Toggle Line Numbers" })
mapkey("<leader>Sp", toggle_autopairs, { desc = "Toggle auto pairs" })
mapkey("<leader>Sr", bind(toggle, "A", "relativenumber"), { desc = "Toggle Relative Line Numbers" })
mapkey("<leader>Ss", bind(toggle, "A", "spell"), { desc = "Toggle Spelling" })
mapkey("<leader>St", toggle_treesitter_context, { desc = "Toggle Treesitter Context" })
mapkey("<leader>ST", toggle_ts_highlights, { desc = "Toggle Treesitter Highlight" })
mapkey("<leader>Sw", bind(toggle, "A", "wrap"), { desc = "Toggle Word Wrap" })

-- Version Control <leader>v
whichkey_defaults["<leader>v"] = { name = "+version control" }
mapkey_cm("<leader>vb", "Telescope git_branches", { desc = "Checkout branch" })
mapkey("<leader>vB", gitsigns.blame_line, { desc = "Blame" })
mapkey_cm("<leader>vC", "Telescope git_bcommits", { desc = "Checkout commit(for current file)" })
mapkey_cm("<leader>vc", "Telescope git_commits", { desc = "Checkout commit" })
mapkey_cm("<leader>vd", "Gitsigns diffthis HEAD", { desc = "Git Diff (against head)" })
mapkey("<leader>ve", bind(neotreecmd.execute, "A", { source = "git_status", toggle = true }), { desc = "Git explorer" })
mapkey_cm("<leader>vG", "AdvancedGitSearch", { desc = "Advanced Git Search" })
mapkey("<leader>vj", gitsigns.next_hunk, { desc = "Next Hunk" })
mapkey("<leader>vk", gitsigns.prev_hunk, { desc = "Prev Hunk" })
mapkey_cm("<leader>vl", "LazyGit", { desc = "Lazygit (cwd)" })
mapkey_cm("<leader>vL", "LazyGitCurrentFile", { desc = "Lazygit (Current File)" })
mapkey("<leader>vo", Telescope.git_status, { desc = "Open changed file" })
mapkey("<leader>vp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
mapkey("<leader>vr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
mapkey("<leader>vs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
mapkey("<leader>vu", gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk" })
mapkey_cm("<leader>vU", "Telescope undo", { desc = "View Undo History" })

-- Zen Mode <leader>z
whichkey_defaults["<leader>z"] = { name = "+zen" }
mapkey_cm("<leader>za", "TZAtaraxis", { desc = "Zen Ataraxis" })
mapkey_cm("<leader>zf", "TZFocus", { desc = "Zen Focus" })
mapkey_cm("<leader>zn", "TZNarrow", { desc = "Zen Narrow" })
mapkey_cm("<leader>zn", "'<,'>TZNarrow{desc = ", " }Zen Narrow", "v")
mapkey_cm("<leader>zm", "TZMinimalist", { desc = "Zen Minimalist" })

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
