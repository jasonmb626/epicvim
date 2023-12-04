local whichkey_defaults = require("epicvim.config.keymaps")

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

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		defaults = whichkey_defaults,
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.register(opts.defaults)
	end,
}
