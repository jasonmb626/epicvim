return {
	"kdheepak/lazygit.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		vim.keymap.set("n", "<leader>vl", ":LazyGit<cr>", { desc = "Lazygit (cwd)" })
		vim.keymap.set("n", "<leader>vL", ":LazyGitCurrentFile<cr>", { desc = "Lazygit (Current File)" })
	end,
}
