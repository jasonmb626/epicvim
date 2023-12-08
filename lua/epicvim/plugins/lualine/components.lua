--Shamelessy stolen from LunarVim
local conditions = require("epicvim.plugins.lualine.conditions")
local colors = require("epicvim.plugins.lualine.colors")
local icons = require("epicvim.config.icons")

local function env_cleanup(venv)
	if string.find(venv, "/") then
		local final_venv = venv
		for w in venv:gmatch("([^/]+)") do
			final_venv = w
		end
		venv = final_venv
	end
	return venv
end

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

local branch = icons.git.Branch

-- if lvim.colorscheme == "lunar" then
if true then
	branch = "%#SLGitIcon#" .. icons.git.Branch .. "%*" .. "%#SLBranchName#"
end

return {
	mode = {
		function()
			return " " .. icons.ui.Target .. " "
		end,
		padding = { left = 0, right = 0 },
		color = {},
		cond = nil,
	},
	branch = {
		"b:gitsigns_head",
		icon = branch,
		color = { gui = "bold" },
	},
	filename = {
		"filename",
		color = {},
		cond = nil,
	},
	diff = {
		"diff",
		source = diff_source,
		symbols = {
			added = icons.git.LineAdded .. " ",
			modified = icons.git.LineModified .. " ",
			removed = icons.git.LineRemoved .. " ",
		},
		padding = { left = 2, right = 1 },
		diff_color = {
			added = { fg = colors.green },
			modified = { fg = colors.yellow },
			removed = { fg = colors.red },
		},
		cond = nil,
	},
	python_env = {
		function()
			if vim.bo.filetype == "python" then
				local venv = os.getenv("CONDA_DEFAULT_ENV") or os.getenv("VIRTUAL_ENV")
				if venv then
					local nvim_web_devicons = require("nvim-web-devicons")
					local py_icon, _ = nvim_web_devicons.get_icon(".py")
					return string.format(" " .. py_icon .. " (%s)", env_cleanup(venv))
				end
			end
			return ""
		end,
		color = { fg = colors.green },
		cond = conditions.hide_in_width,
	},
	diagnostics = {
		"diagnostics",
		sources = { "nvim_diagnostic" },
		symbols = {
			error = icons.diagnostics.BoldError .. " ",
			warn = icons.diagnostics.BoldWarning .. " ",
			info = icons.diagnostics.BoldInformation .. " ",
			hint = icons.diagnostics.BoldHint .. " ",
		},
		-- cond = conditions.hide_in_width,
	},
	treesitter = {
		function()
			return icons.ui.Tree
		end,
		color = function()
			local buf = vim.api.nvim_get_current_buf()
			local ts = vim.treesitter.highlighter.active[buf]
			return { fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.red }
		end,
		cond = conditions.hide_in_width,
	},
	lsp = {
		function()
			local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })

			local buf_client_names = {}
			local copilot_active = false

			-- add clients
			for _, client in ipairs(buf_clients) do
				if client.name ~= "null-ls" and client.name ~= "copilot" then
					table.insert(buf_client_names, client.name)
				end

				if client.name == "copilot" then
					copilot_active = true
				end
			end

			if copilot_active then
				table.insert(buf_client_names, "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*")
			end

			-- TODO: Add an icon to indicate formatter. Recommend nerd font entry f08df
			-- add formatter
			local buf_formatters = {}
			local supported_formatters = require("conform").list_formatters(0)
			for _, supported_formatter in ipairs(supported_formatters) do
				--local supported_formatters = formatters.list_registered(buf_ft)
				table.insert(buf_formatters, supported_formatter.name)
			end

			-- add linter

			-- TODO: Add an icon to indicate linters. Maybe nerd font f11c0
			local buf_linters = {}
			local supported_linters = require("lint").get_running()
			vim.list_extend(buf_linters, supported_linters)

			local lsp_str = ""
			if #buf_client_names == 0 then
				lsp_str = icons.lsp.lsp .. " n/a"
			else
				lsp_str = icons.lsp.lsp .. " " .. table.concat(buf_client_names, ", ")
			end

			local format_str = ""
			if #buf_formatters == 0 then
				format_str = icons.lsp.formatter .. " n/a"
			else
				format_str = icons.lsp.formatter .. " " .. table.concat(buf_formatters, ", ")
			end

			local lint_str = ""
			if #buf_linters == 0 then
				lint_str = icons.lsp.linter .. " n/a"
			else
				lint_str = icons.lsp.linter .. " " .. table.concat(buf_linters, ", ")
			end

			local full_lsp_str = lsp_str .. " " .. format_str .. " " .. lint_str
			return full_lsp_str
		end,
		color = { gui = "bold" },
		cond = conditions.hide_in_width,
	},
	location = { "location" },
	progress = {
		"progress",
		fmt = function()
			return "%P/%L"
		end,
		color = {},
	},

	spaces = {
		function()
			local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
			return icons.ui.Tab .. " " .. shiftwidth
		end,
		padding = 1,
	},
	encoding = {
		"o:encoding",
		fmt = string.upper,
		color = {},
		cond = conditions.hide_in_width,
	},
	filetype = { "filetype", cond = nil, padding = { left = 1, right = 1 } },
	scrollbar = {
		function()
			local current_line = vim.fn.line(".")
			local total_lines = vim.fn.line("$")
			local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
			local line_ratio = current_line / total_lines
			local index = math.ceil(line_ratio * #chars)
			return chars[index]
		end,
		padding = { left = 0, right = 0 },
		color = "SLProgress",
		cond = nil,
	},
}
