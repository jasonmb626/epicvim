return {
	"windwp/nvim-autopairs",
	event = { "InsertEnter" },
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	config = function()
		-- import nvim-autopairs
		local autopairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")

		-- configure autopairs
		autopairs.setup({
			check_ts = true, -- enable treesitter
			ts_config = {
				lua = { "string" }, -- don't add pairs in lua string treesitter nodes
				javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
				java = false, -- don't check treesitter on java
			},
		})

		local ts_conds = require("nvim-autopairs.ts-conds")

		-- press % => %% only while inside a comment or string
		autopairs.add_rules({
			Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
			Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
		})

		-- import nvim-autopairs completion functionality
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")

		-- import nvim-cmp plugin (completions plugin)
		local cmp = require("cmp")

		-- make autopairs and completion work together
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		vim.keymap.set("n", "<leader>Sp", function()
			if vim.g.autopairs == true then
				vim.g.autopairs = false
				require("nvim-autopairs").enable()
				print("Autopairs enabled")
			else
				vim.g.autopairs = true
				require("nvim-autopairs").disable()
				print("Autopairs disabled")
			end
		end, { desc = "Toggle auto pairs" })
	end,
}
