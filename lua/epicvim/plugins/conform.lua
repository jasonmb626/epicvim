--https://stackoverflow.com/questions/9145432/load-lua-files-by-relative-path
local folderOfThisFile = (...):match("(.-)[^%.]+$")

--https://stackoverflow.com/questions/1426954/split-string-in-lua
local function split(str, sep)
	local result = {}
	local regex = ("([^%s]+)"):format(sep)
	for each in str:gmatch(regex) do
		table.insert(result, each)
	end
	return result
end

local splitpath = split(folderOfThisFile, ".")
table.remove(splitpath)
local parentpath = table.concat(splitpath, ".") -- parentpath is now one directory up from this file

return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local conform = require("conform")
		local format_options = require(parentpath .. ".config.formatting").format_options

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "autopep8" },
			},
			format_on_save = format_options,
		})
		vim.keymap.set({ "n", "v" }, "<leader>cF", function()
			require("conform").format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
				formatters = { "injected" },
			})
		end, { desc = "Format Injected Langs" })
		vim.keymap.set("n", "<leader>Sf", function()
			if vim.g.autoformat ~= nil and vim.g.autoformat == true then
				vim.g.autoformat = false
				require("conform").setup({ format_on_save = false })
				print("Disabled autoformatting")
			else
				vim.g.autoformat = true
				require("conform").setup({
					format_on_save = {
						lsp_fallback = true,
						async = false,
						timeout_ms = 1000,
					},
				})
				print("Enabled autoformatting")
			end
		end, { desc = "Toggle auto format" })
	end,
}
