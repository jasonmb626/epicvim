-- Move Lines
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("i", "<A-j>", "<esc>:m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "<A-k>", "<esc>:m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- +Next, ]
vim.keymap.set("n", "]<tab>", ":tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "jump to next diagnostic in buffer" })

-- +Prev, [
vim.keymap.set("n", "[<tab>", ":tabprev<cr>", { desc = "Prev Tab" })
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Prev quickfix" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic in buffer" })

-- save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", ":w<cr><esc>", { desc = "Save file" })

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "go to declaration" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "show documentation for what is under cursor" })

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

-- +Tabs <leader><tab>
vim.keymap.set("n", "<leader><tab>$", ":tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>0", ":tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab>n", ":tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>l", ":tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>x", ":tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>h", ":tabprevious<cr>", { desc = "Prev Tab" })

-- +Code Actions <leader>c
vim.keymap.set("n", "<leader>ci", ":LspInfo<cr>", { desc = "LSP Info" })
vim.keymap.set("n", "<leader>cI", vim.show_pos, { desc = "Inspect Pos" })
vim.keymap.set("n", "<leader>co", ":lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>cq", ":copen<cr>", { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
--TODO is this built into neovim?
vim.keymap.set("n", "<leader>cR", ":LspRestart<cr>", { desc = "Restart LSP" })

-- +Find/Files <leader>f
-- TODO: There are other bufferline options worth exploring
vim.keymap.set("n", "<leader>fn", ":enew<cr>", { desc = "New File/Buffer" })
vim.keymap.set("n", "<leader>fo", ":e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>fW", ":noautocmd w<cr>", { desc = "Save without formatting (no autocmd)" })
vim.keymap.set("n", "<leader>fx", require("epicvim.util.buffer").buf_kill, { desc = "Close Buffer" })
vim.keymap.set("n", "<leader>fX", function()
	require("epicvim.util.buffer").buf_kill(true)
end, { desc = "Close Buffer (Force)" })
-- +Go (actions) <leader>g

-- Panes <leader>p
vim.keymap.set("n", "<leader>p-", "<C-W>s", { desc = "Split pane below", remap = true })
vim.keymap.set("n", "<leader>p|", "<C-W>v", { desc = "Split pane right", remap = true })
vim.keymap.set("n", "<leader>pf", ":MaximizerToggle<cr>", { desc = "Maximize/Unmaximize pane" })
vim.keymap.set("n", "<leader>pw", "<C-W>p", { desc = "Other pane", remap = true })
vim.keymap.set("n", "<leader>px", "<C-W>c", { desc = "Delete pane", remap = true })
vim.keymap.set("n", "<leader>p-", "<C-W>s", { desc = "Split pane below", remap = true })
vim.keymap.set("n", "<leader>p|", "<C-W>v", { desc = "Split pane right", remap = true })

-- +Session <leader>q
vim.keymap.set("n", "<leader>qq", ":qa<cr>", { desc = "Quit all" })

-- +search <leader>s
vim.keymap.set("n", "<leader>sK", function()
	vim.cmd("enew")
	vim.cmd(":put = execute('verbose map')")
end, { desc = "Verbose Key Maps" })
vim.keymap.set("n", "<leader>sx", ":noh<cr><esc>", { desc = "Clear hlsearch" })

-- +Set/Toggle Session Features <leader>S
vim.keymap.set("n", "<leader>Sc", function()
	vim.ui.select({ 0, 1, 2, 3 }, {}, function(selection)
		vim.o.conceallevel = selection
		print("Set conceallevel to " .. selection)
	end)
end, { desc = "Set Concellevel" })
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
if vim.lsp.inlay_hint then
	vim.keymap.set("<leader>Sh", function()
		vim.lsp.inlay_hint(0, nil)
	end, { desc = "Toggle Inlay Hints" })
end
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
