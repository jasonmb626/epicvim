return {
	"akinsho/bufferline.nvim",
	config = function()
		require("bufferline").setup()
		vim.keymap.set("n", "]b", ":BufferLineCycleNext<cr>", { desc = "Next buffer" })
		vim.keymap.set("n", "[b", "BufferLineCycleNext", { desc = "Prev buffer" })
		vim.keymap.set("n", "<leader>fC", ":BufferLinePickClose<cr>", { desc = "Choose which buffer to close" })
		vim.keymap.set("n", "<leader>fD", ":BufferLineSortByDirectory<cr>", { desc = "Sort by directory" })
		vim.keymap.set("n", "<leader>fh", ":BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
		vim.keymap.set("n", "<leader>fH", ":BufferLineCloseLeft<cr>", { desc = "Close all buffers to the left" })
		vim.keymap.set("n", "<leader>fj", ":BufferLinePick<cr>", { desc = "Jump to specific buffer" })
		vim.keymap.set("n", "<leader>fl", ":BufferLineCycleNext<cr>", { desc = "Next buffer" })
		vim.keymap.set("n", "<leader>fL", ":BufferLineCloseRight<cr>", { desc = "Close all buffers to the right" })
		vim.keymap.set("n", "<leader>fO", ":BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
		vim.keymap.set("n", "<leader>fp", ":BufferLineTogglePin<cr>", { desc = "Toggle Pin" })
		vim.keymap.set("n", "<leader>fP", ":BufferLineGroupClose ungrouped<cr>", { desc = "Close non-pinned buffers" })
		vim.keymap.set("n", "<leader>fT", ":BufferLineSortByExtension<cr>", { desc = "Sort by type (File extension)" })
	end,
}
