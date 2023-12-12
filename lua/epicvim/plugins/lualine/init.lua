local components = require("epicvim.plugins.lualine.components")

local function setup_lualine()
	local nordtheme = require("lualine.themes.nord")
	if #vim.api.nvim_list_uis() == 0 then
		local log = require("structlog")
		local logger = log.get_logger("epic_logger")
		logger:debug("headless mode detected, skipping running setup for lualine")
		return
	end

	local status_ok, lualine = pcall(require, "lualine")
	if not status_ok then
		return
	end

	lualine.setup({
		style = "epicvim",
		options = {
			theme = nordtheme,
			globalstatus = true,
			icons_enabled = true,
			component_separators = {},
			disabled_filetypes = { statusline = { "alpha" } },
		},
		sections = {
			lualine_a = {
				"fileformat",
				"encoding",
			},
			lualine_b = {
				components.branch,
			},
			lualine_c = {
				components.diff,
				components.python_env,
			},
			lualine_x = {
				components.diagnostics,
				components.lsp,
				components.spaces,
				{ "filetype" },
			},
			lualine_y = { components.location },
			lualine_z = {
				components.progress,
			},
		},
		--[[inactive_sections = {
			lualine_a = {
				components.mode,
			},
			lualine_b = { components.branch },
			lualine_c = { components.diff, components.python_env },
			lualine_x = {
				components.diagnostics,
				components.lsp,
				components.spaces,
				{ "filetype" },
			},
			lualine_y = { components.location },
			lualine_z = { components.progress },
		},]]
		tabline = {},
		extensions = {},
	})
end

return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	config = setup_lualine,
}
