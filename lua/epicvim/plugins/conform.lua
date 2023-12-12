return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "autopep8" },
			},
			format_on_save = {
				lsp_fallback = true,
			},
		})
		vim.keymap.set({ "n", "v" }, "<leader>cf", function()
			require("conform").format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format" })
		vim.keymap.set({ "n", "v" }, "<leader>cF", function()
			require("conform").format({
				lsp_fallback = true,
				formatters = { "injected" },
			})
		end, { desc = "Format Injected Langs" })
		vim.keymap.set("n", "<leader>Sf", function()
			if vim.g.autoformat == true then
				vim.g.autoformat = false
				require("conform").setup({ format_on_save = false })
				print("Disabled autoformatting")
			else
				vim.g.autoformat = true
				require("conform").setup({
					format_on_save = {
						lsp_fallback = true,
					},
				})
				print("Enabled autoformatting")
			end
		end, { desc = "Toggle auto format" })
	end,
}
