local M = {}
local components = require("epicvim.plugins.lualine.components")

local use_icons = true

M.styles = {
	lvim = nil,
	default = nil,
	none = nil,
}

M.styles.base = {
	active = true,
	style = "epicvim",
	options = {
		icons_enabled = nil,
		component_separators = nil,
		section_separators = nil,
		theme = nil,
		disabled_filetypes = { statusline = { "alpha" } },
		globalstatus = true,
	},
	sections = {
		lualine_a = nil,
		lualine_b = nil,
		lualine_c = nil,
		lualine_x = nil,
		lualine_y = nil,
		lualine_z = nil,
	},
	inactive_sections = {
		lualine_a = nil,
		lualine_b = nil,
		lualine_c = nil,
		lualine_x = nil,
		lualine_y = nil,
		lualine_z = nil,
	},
	tabline = nil,
	extensions = nil,
	on_config_done = nil,
}

M.styles.none = {
	style = "none",
	options = {
		theme = "auto",
		globalstatus = true,
		icons_enabled = use_icons,
		component_separators = {},
		section_separators = {},
		disabled_filetypes = {},
	},
	sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
}

M.styles.epicvim = {
	style = "epicvim",
	options = {
		theme = "auto",
		globalstatus = true,
		icons_enabled = use_icons,
		component_separators = {},
		section_separators = {},
		disabled_filetypes = { "alpha" },
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
	tabline = {},
	extensions = {},
}

function M.get_style(style)
	local style_keys = vim.tbl_keys(M.styles)
	if not vim.tbl_contains(style_keys, style) then
		local log = require("structlog")
		local logger = log.get_logger("epic_logger")
		logger:error(
			"Invalid lualine style"
				.. string.format('"%s"', style)
				.. "options are: "
				.. string.format('"%s"', table.concat(style_keys, '", "'))
		)
		logger:debug('"lvim" style is applied.')
		style = "lvim"
	end

	return vim.deepcopy(M.styles[style])
end

return M
