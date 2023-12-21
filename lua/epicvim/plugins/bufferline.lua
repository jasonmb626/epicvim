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
		vim.keymap.set("n", "<M-h>", ":BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
		vim.keymap.set("n", "<M-l>", ":BufferLineCycleNext<cr>", { desc = "Next buffer" })
		vim.keymap.set("n", "<M-u>", function()
			require("bufferline").go_to(1, true)
		end, { desc = "Jump to 1st buffer" })
		vim.keymap.set("n", "<M-i>", function()
			require("bufferline").go_to(2, true)
		end, { desc = "Jump to 2nd buffer" })
		vim.keymap.set("n", "<M-o>", function()
			require("bufferline").go_to(3, true)
		end, { desc = "Jump to 3rd buffer" })
		vim.keymap.set("n", "<M-p>", function()
			require("bufferline").go_to(4, true)
		end, { desc = "Jump to 4th buffer" })
		vim.keymap.set("n", "<leader>f<", ":BufferLineMovePrev<cr>", { desc = "Move buffer backward in bufferline." })
		vim.keymap.set("n", "<leader>f>", ":BufferLineMoveNext<cr>", { desc = "Move buffer forward in bufferline." })
	end,
}
