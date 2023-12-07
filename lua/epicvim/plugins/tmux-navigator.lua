return {
	"christoomey/vim-tmux-navigator", -- tmux & split window navigation
	config = function()
		vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<cr>", { desc = "Navigate Left" })
		vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<cr>", { desc = "Navigate Down" })
		vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<cr>", { desc = "Navigate Up" })
		vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<cr>", { desc = "Navigate Right" })
	end,
}
