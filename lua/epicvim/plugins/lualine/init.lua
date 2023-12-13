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
			disabled_filetypes = { statusline = { "alpha" } },
			section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = {
				"fileformat",
				"encoding",
				components.spaces,
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
				{ "filetype" },
			},
			lualine_y = { components.location },
			lualine_z = {
				components.progress,
			},
		},
		tabline = {},
		extensions = {},
	})
end

return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	config = setup_lualine,
}
