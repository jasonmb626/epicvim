return {
	"chrisgrieser/nvim-spider",
	config = function()
		vim.keymap.set({ "n", "o", "x" }, "<leader>w", ":lua require('spider').motion('w')<cr>", { desc = "Spider-w" })
		vim.keymap.set({ "n", "o", "x" }, "<leader>e", ":lua require('spider').motion('e')<cr>", { desc = "Spider-e" })
		vim.keymap.set({ "n", "o", "x" }, "<leader>b", ":lua require('spider').motion('b')<cr>", { desc = "Spider-b" })
	end,
}
