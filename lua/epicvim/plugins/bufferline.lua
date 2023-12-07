return {
	"akinsho/bufferline.nvim",
	config = function()
		require("bufferline").setup()
		vim.keymap.set("n", "]b", ":BufferLineCycleNext<cr>", { desc = "Next buffer" })
		vim.keymap.set("n", "[b", "BufferLineCycleNext", { desc = "Prev buffer" })
	end,
}
