local components = require("epicvim.plugins.lualine.components")

local M = {}
M.config = function() end

M.setup = function()
	local nordtheme = require("lualine.themes.nord")
	if #vim.api.nvim_list_uis() == 0 then
		local log = require("structlog")
		local logger = log.get_logger("epicvim")
		logger:debug("headless mode detected, skipping running setup for lualine")
		-- logger:info("A log message")
		-- logger:warn("A log message with keyword arguments", { warning = "something happened" })
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
				components.mode,
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
				components.filetype,
			},
			lualine_y = { components.location },
			lualine_z = {
				components.progress,
			},
		},
		inactive_sections = {
			lualine_a = {
				components.mode,
			},
			lualine_b = { components.branch },
			lualine_c = { components.diff, components.python_env },
			lualine_x = {
				components.diagnostics,
				components.lsp,
				components.spaces,
				components.filetype,
			},
			lualine_y = { components.location },
			lualine_z = { components.progress },
		},
		tabline = {},
		extensions = {},
	})
end

return M