return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		-- aids in installing additional tools beyond what lspconfig can
		-- DAPs, Linters, Formatters
		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"tsserver",
				"html",
				"cssls",
				"tailwindcss",
				"emmet_ls",
				-- "pyright",
				"pylsp",
				"lua_ls",
			},
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"debugpy",
				"isort", -- python formatter
				"autopep8", -- python formatter
				"black", -- python formatter
				"eslint_d", -- js linter
				"prettier", -- prettier formatter
			},
		})
	end,
	vim.keymap.set("n", "<leader>cm", ":Mason<cr>", { desc = "Mason" }),
}
