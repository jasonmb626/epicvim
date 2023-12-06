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
mapkey("<A-j>", "<cmd>m .+1<cr>==", "Move down")
mapkey("<A-k>", "<cmd>m .-2<cr>==", "Move up")
mapkey("<A-j>", "<esc><cmd>m .+1<cr>==gi", "Move down", "i")
mapkey("<A-k>", "<esc><cmd>m .-2<cr>==gi", "Move up", "i")
mapkey("<A-j>", ":m '>+1<cr>gv=gv", "Move down", "v")
mapkey("<A-k>", ":m '<-2<cr>gv=gv", "Move up", "v")

-- Clear search with <esc>
mapkey("<esc>", "<cmd>noh<cr><esc>", "Escape and clear hlsearch", { "i", "n" })

-- +Next, ]
whichkey_defaults["]"] = { name = "+next" }
mapkey_cm("]<tab>", "tabnext", "Next Tab")
mapkey_cm("]b", "BufferLineCycleNext", "Next buffer")
mapkey("]h", gitsigns.next_hunk, "Next Hunk")
mapkey("]q", vim.cmd.cnext, "Next quickfix")
mapkey("]d", vim.diagnostic.goto_next, "jump to next diagnostic in buffer")

-- +Prev, [
whichkey_defaults["["] = { name = "+prev" }
mapkey_cm("[<tab>", "tabprev", "Prev Tab")
mapkey_cm("[b", "BufferLineCyclePrev", "Prev buffer")
mapkey("[h", gitsigns.prev_hunk, "Prev Hunk")
mapkey("[q", vim.cmd.cprev, "Prev quickfix")
mapkey("[d", vim.diagnostic.goto_prev, "Prev diagnostic in buffer")

-- save file
mapkey("<C-s>", "<cmd>w<cr><esc>", "Save file", { "i", "x", "n", "s" })

mapkey("gR", Telescope.lsp_references, "show definition, references")
mapkey("gD", vim.lsp.buf.declaration, "go to declaration")
mapkey("gd", Telescope.lsp_definitions, "show lsp definitions")
mapkey("gi", Telescope.lsp_implementations, "show lsp implementations")
mapkey("gt", Telescope.lsp_type_definitions, "show lsp type definitions")
mapkey("K", vim.lsp.buf.hover, "show documentation for what is under cursor")

-- Pane and Window Navigation
mapkey("<C-h>", "<C-w>h", "Navigate Left")
mapkey("<C-j>", "<C-w>j", "Navigate Down")
mapkey("<C-k>", "<C-w>k", "Navigate Up")
mapkey("<C-l>", "<C-w>l", "Navigate Right")
mapkey_cm("<C-h>", "wincmd h", "Navigate Left", "t")
mapkey_cm("<C-j>", "wincmd j", "Navigate Down", "t")
mapkey_cm("<C-k>", "wincmd k", "Navigate Up", "t")
mapkey_cm("<C-l>", "wincmd l", "Navigate Right", "t")
mapkey_cm("<C-h>", "TmuxNavigateLeft", "Navigate Left")
mapkey_cm("<C-j>", "TmuxNavigateDown", "Navigate Down")
mapkey_cm("<C-k>", "TmuxNavigateUp", "Navigate Up")
mapkey_cm("<C-l>", "TmuxNavigateRight", "Navigate Right")

-- Indenting
mapkey("<", "<gv", "Shift Indentation to Left", "v")
mapkey(">", ">gv", "Shift Indentation to Right", "v")

-- Comments
mapkey("<C-_>", "gcc", "Toggle Comments", { "n", "v" })

-- Easily return to dashboard
mapkey_cm("<leader>0", "Alpha", "Intro Dashboard")

mapkey("<leader>+", "<C-a>", "Increment Number")
mapkey("<leader>_", "<C-x>", "Decrement Number")

-- Quick Window Management
mapkey_cm("<leader>|", "vsplit", "Split Vertically")
mapkey_cm("<leader>-", "split", "Split Horizontally")

-- Command history
mapkey("<leader>:", Telescope.command_history, "Command History")

-- Plugins, <leader>P
mapkey_cm("<leader>P", "Lazy", "Lazy (Plugin Manager)")

-- spider
mapkey_cm("<leader>w", "lua require('spider').motion('w')", "Spider-w", { "n", "o", "x" })
mapkey_cm("<leader>e", "lua require('spider').motion('e')", "Spider-e", { "n", "o", "x" })
mapkey_cm("<leader>b", "lua require('spider').motion('b')", "Spider-b", { "n", "o", "x" })

-- +Tabs <leader><tab>
whichkey_defaults["<leader><tab>"] = { name = "+tabs" }
mapkey_cm("<leader><tab>$", "tablast", "Last Tab")
mapkey_cm("<leader><tab>0", "tabfirst", "First Tab")
mapkey_cm("<leader><tab>n", "tabnew", "New Tab")
mapkey_cm("<leader><tab>l", "tabnext", "Next Tab")
mapkey_cm("<leader><tab>x", "tabclose", "Close Tab")
mapkey_cm("<leader><tab>h", "tabprevious", "Prev Tab")

-- +Code Actions <leader>c
whichkey_defaults["<leader>c"] = { name = "+code actions" }
local fo_injected = vim.deepcopy(format_options)
fo_injected.formatters = { "injected" }
mapkey("<leader>cd", Telescope.lsp_document_symbols, "Document Symbols")
mapkey("<leader>cf", bind(conform.format, "A", format_options), "Format", { "n", "v" })
mapkey("<leader>cF", bind(conform.format, "A", fo_injected), "Format Injected Langs", { "n", "v" })
mapkey("<leader>cL", lint.try_lint, "Trigger linting for current file")
mapkey_cm("<leader>ci", "LspInfo", "LSP Info")
mapkey("<leader>cI", vim.show_pos, "Inspect Pos")
mapkey_cm("<leader>cm", "Mason", "Mason")
mapkey_cm("<leader>co", "lopen", "Location List")
mapkey_cm("<leader>cq", "copen", "Quickfix List")
mapkey("<leader>cQ", Telescope.quickfix, "Telescope Quickfix")
mapkey("<leader>cr", vim.lsp.buf.rename, "Rename")
mapkey_cm("<leader>cR", "LspRestart", "Restart LSP")
mapkey("<leader>cw", Telescope.lsp_dynamic_workspace_symbols, "Workspace Symbols")
mapkey("<leader>cW", Telescope.diagnostics, "Workspace diagnostics")

-- +Debugging <leader>d
whichkey_defaults["<leader>d"] = { name = "+debug" }
mapkey("<leader>db", dap.step_back, "Step Back")
mapkey("<leader>dc", dap.continue, "Continue")
mapkey("<leader>dC", dap.run_to_cursor, "Run To Cursor")
mapkey("<leader>dd", dap.disconnect, "Disconnect")
mapkey("<leader>de", dapui.eval, "Eval", { "n", "v" })
mapkey("<leader>dg", dap.session, "Get Session")
mapkey("<leader>di", dap.step_into, "Step Into")
mapkey("<leader>do", dap.step_over, "Step Over")
mapkey("<leader>dp", dap.pause, "Pause")
mapkey("<leader>dq", dap.close, "Quit")
mapkey("<leader>dr", dap.repl.toggle, "Toggle Repl")
mapkey("<leader>ds", dap.continue, "Start")
mapkey("<leader>dt", dap.toggle_breakpoint, "Toggle Breakpoint")
mapkey("<leader>du", dap.step_out, "Step Out")
mapkey("<leader>dU", bind(dapui.toggle, "A", { reset = true }), "Toggle UI")

-- +Find/Files <leader>f
-- TODO: There are other bufferline options worth exploring
whichkey_defaults["<leader>f"] = { name = "+files/buffers" }
--local ttopts = {
--	find_files = false,
--	focus = true,
--	update_root = false,
--}
mapkey("<leader>fb", bind(neotreecmd.execute, "A", { source = "buffers", toggle = true }), "Buffer explorer")
mapkey("<leader>fB", Telescope.buffers, "Find Buffers")
mapkey_cm("<leader>fc", "NvimTreeCollapse", "Collapse file explorer")
mapkey_cm("<leader>fC", "BufferLinePickClose", "Choose which buffer to close")
mapkey_cm("<leader>fD", "BufferLineSortByDirectory", "Sort by directory")
mapkey_cm("<leader>fe", "NvimTreeFindFile", "File explorer on current file")
mapkey_cm("<leader>ff", "NvimTreeToggle", "Toggle file explorer")
mapkey("<leader>fF", Telescope.find_files, "Find files")
mapkey_cm("<leader>fh", "BufferLineCyclePrev", "Prev buffer")
mapkey_cm("<leader>fH", "BufferLineCloseLeft", "Close all buffers to the left")
mapkey_cm("<leader>fj", "BufferLinePick", "Jump")
mapkey_cm("<leader>fl", "BufferLineCycleNext", "Next buffer")
mapkey_cm("<leader>fL", "BufferLineCloseRight", "Close all buffers to the right")
mapkey_cm("<leader>fn", "enew", "New File/Buffer")
mapkey_cm("<leader>fo", "e #", "Switch to Other Buffer")
mapkey_cm("<leader>fO", "BufferLineCloseOthers", "Delete other buffers")
mapkey_cm("<leader>fp", "BufferLineTogglePin", "Toggle Pin")
mapkey_cm("<leader>fP", "BufferLineGroupClose ungrouped", "Delete non-pinned buffers")
mapkey("<leader>fr", Telescope.oldfiles, "Recent files")
mapkey_cm("<leader>fT", "BufferLineSortByExtension", "Sort by type (File extension)")
mapkey_cm("<leader>fW", "noautocmd w", "Save without formatting (no autocmd)")
mapkey("<leader>fx", buf_kill, "Delete Buffer")
mapkey("<leader>fX", bind(buf_kill, "A", true), "Delete Buffer (Force)")

-- +Go (actions) <leader>g
whichkey_defaults["<leader>g"] = { name = "+go (actions)" }
mapkey_cm("<leader>ge", "lua require('spider').motion('ge')", "Spider-ge", { "n", "o", "x" })

-- Panes <leader>p
whichkey_defaults["<leader>p"] = { name = "+panes" }
mapkey("<leader>p-", "<C-W>s", { desc = "Split pane below", remap = true })
mapkey("<leader>p|", "<C-W>v", { desc = "Split pane right", remap = true })
mapkey_cm("<leader>pf", "MaximizerToggle", "Maximize/Unmaximize pane")
mapkey("<leader>pw", "<C-W>p", { desc = "Other pane", remap = true })
mapkey("<leader>px", "<C-W>c", { desc = "Delete pane", remap = true })
mapkey("<leader>p-", "<C-W>s", { desc = "Split pane below", remap = true })
mapkey("<leader>p|", "<C-W>v", { desc = "Split pane right", remap = true })

-- +Session <leader>q
whichkey_defaults["<leader>q"] = { name = "+session" }
mapkey("<leader>qd", persistence.stop, "Don't Save Current Session")
mapkey("<leader>ql", bind(persistence.load, "A", { last = true }), "Restore Last Session")
mapkey_cm("<leader>qq", "qa", "Quit all")
mapkey("<leader>qs", persistence.load, "Restore Session")

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
mapkey('<leader>s"', Telescope.registers, "Registers")
mapkey("<leader>sa", Telescope.autocommands, "Auto Commands")
mapkey("<leader>sb", Telescope.current_buffer_fuzzy_find, "Buffer")
mapkey("<leader>sc", Telescope.command_history, "Command History")
mapkey("<leader>sC", Telescope.commands, "Commands")
mapkey_cm("<leader>sd", "Telescope diagnostics bufnr=0", "Document diagnostics")
mapkey("<leader>sD", Telescope.diagnostics, "Workspace diagnostics")
mapkey("<leader>sf", Telescope.find_files, "Find files")
mapkey("<leader>sF", grep_in_search_dir, "Grep (Specify directory)")
mapkey("<leader>sg", grep_in_cwd, "Grep (cwd)")
mapkey("<leader>sG", Telescope.live_grep, "Grep (root dir)")
mapkey("<leader>sh", Telescope.help_tags, "Help Pages")
mapkey("<leader>sH", Telescope.highlights, "Search Highlight Groups")
mapkey("<leader>sk", Telescope.keymaps, "Key Maps")
mapkey("<leader>sK", function()
	vim.cmd("enew")
	vim.cmd(":put = execute('verbose map')")
end, "Verbose Key Maps")
mapkey("<leader>sM", Telescope.man_pages, "Man Pages")
mapkey("<leader>sm", Telescope.marks, "Jump to Mark")
mapkey("<leader>so", Telescope.vim_options, "Options")
mapkey("<leader>sr", Telescope.oldfiles, "Recent")
mapkey("<leader>sR", Telescope.resume, "Resume")
mapkey("<leader>ss", Telescope.lsp_document_symbols, "Goto Symbol (Document)")
mapkey("<leader>sS", Telescope.lsp_dynamic_workspace_symbols, "Goto Symbol (Workspace)")
mapkey_cm("<leader>sw", "Telescope grep_string word_match='-w'", "Word (cwd)")
mapkey_cm("<leader>sW", "Telescope grep_string cwd=false word_match='-w'", "Word (root dir)")

-- +Set/Toggle Session Features <leader>S
whichkey_defaults["<leader>S"] = { name = "+Set/Toggle Session Features" }
mapkey("<leader>Sc", set_conceallevel, "Set Concellevel")
mapkey_cm("<leader>SC", bind(Telescope.colorscheme, "A", { enable_preview = true }), "Colorscheme with preview")
mapkey("<leader>Sd", toggle_diagnostics, "Toggle diagnostics")
mapkey("<leader>Sf", toggle_autoformatting, "Toggle auto format")
if vim.lsp.inlay_hint then
	mapkey("<leader>Sh", function()
		vim.lsp.inlay_hint(0, nil)
	end, "Toggle Inlay Hints")
end
mapkey("<leader>SH", toggle_hardtime, "Toggle Hardtime")
mapkey("<leader>Si", toggle_illuminate, "Toggle Illiminate")
mapkey("<leader>Sl", bind(toggle, "A", "number"), "Toggle Line Numbers")
mapkey("<leader>Sp", toggle_autopairs, "Toggle auto pairs")
mapkey("<leader>Sr", bind(toggle, "A", "relativenumber"), "Toggle Relative Line Numbers")
mapkey("<leader>Ss", bind(toggle, "A", "spell"), "Toggle Spelling")
mapkey("<leader>St", toggle_treesitter_context, "Toggle Treesitter Context")
mapkey("<leader>ST", toggle_ts_highlights, "Toggle Treesitter Highlight")
mapkey("<leader>Sw", bind(toggle, "A", "wrap"), "Toggle Word Wrap")

-- Version Control <leader>v
whichkey_defaults["<leader>v"] = { name = "+version control" }
mapkey_cm("<leader>vb", "Telescope git_branches", "Checkout branch")
mapkey("<leader>vB", gitsigns.blame_line, "Blame")
mapkey_cm("<leader>vC", "Telescope git_bcommits", "Checkout commit(for current file)")
mapkey_cm("<leader>vc", "Telescope git_commits", "Checkout commit")
mapkey_cm("<leader>vd", "Gitsigns diffthis HEAD", "Git Diff (against head)")
mapkey("<leader>ve", bind(neotreecmd.execute, "A", { source = "git_status", toggle = true }), "Git explorer")
mapkey_cm("<leader>vG", "AdvancedGitSearch", "Advanced Git Search")
mapkey("<leader>vj", gitsigns.next_hunk, "Next Hunk")
mapkey("<leader>vk", gitsigns.prev_hunk, "Prev Hunk")
mapkey_cm("<leader>vl", "LazyGit", "Lazygit (cwd)")
mapkey_cm("<leader>vL", "LazyGitCurrentFile", "Lazygit (Current File)")
mapkey("<leader>vo", Telescope.git_status, "Open changed file")
mapkey("<leader>vp", gitsigns.preview_hunk, "Preview Hunk")
mapkey("<leader>vr", gitsigns.reset_hunk, "Reset Hunk")
mapkey("<leader>vs", gitsigns.stage_hunk, "Stage Hunk")
mapkey("<leader>vu", gitsigns.undo_stage_hunk, "Undo Stage Hunk")
mapkey_cm("<leader>vU", "Telescope undo", "View Undo History")

-- Zen Mode <leader>z
whichkey_defaults["<leader>z"] = { name = "+zen" }
mapkey_cm("<leader>za", "TZAtaraxis", "Zen Ataraxis")
mapkey_cm("<leader>zf", "TZFocus", "Zen Focus")
mapkey_cm("<leader>zn", "TZNarrow", "Zen Narrow")
mapkey_cm("<leader>zn", "'<,'>TZNarrow", "Zen Narrow", "v")
mapkey_cm("<leader>zm", "TZMinimalist", "Zen Minimalist")

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
