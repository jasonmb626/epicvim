--Shamelessy stolen from LunarVim

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

local branch = ""

-- if lvim.colorscheme == "lunar" then
if true then
	branch = "%#SLGitIcon#%*" .. "%#SLBranchName#"
end

return {
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
			added = " ",
			modified = " ",
			removed = " ",
		},
		padding = { left = 2, right = 1 },
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
		cond = function()
			return vim.o.columns > 100
		end,
	},
	diagnostics = {
		"diagnostics",
		sources = { "nvim_diagnostic" },
		symbols = {
			error = " ",
			warn = " ",
			info = " ",
			hint = " ",
		},
		cond = function()
			return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
		end,
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
				table.insert(buf_client_names, "%#SLCopilot#" .. " %*")
			end

			-- add formatter
			local buf_formatters = {}
			local supported_formatters = require("conform").list_formatters(0)
			for _, supported_formatter in ipairs(supported_formatters) do
				--local supported_formatters = formatters.list_registered(buf_ft)
				table.insert(buf_formatters, supported_formatter.name)
			end

			-- add linter

			local buf_linters = {}
			local supported_linters = {}
			if type(require("lint")["get_running"]) == "function" then
				supported_linters = require("lint").get_running()
			else
				supported_linters = { "u/k" }
			end
			vim.list_extend(buf_linters, supported_linters)

			local lsp_str = ""
			if #buf_client_names == 0 then
				lsp_str = "󱓓 n/a"
			else
				lsp_str = "󱓓 " .. table.concat(buf_client_names, ", ")
			end

			local format_str = ""
			if #buf_formatters == 0 then
				format_str = "󰣟 n/a"
			else
				format_str = "󰣟 " .. table.concat(buf_formatters, ", ")
			end

			local lint_str = ""
			if #buf_linters == 0 then
				lint_str = "󱇀 n/a"
			else
				lint_str = "󱇀 " .. table.concat(buf_linters, ", ")
			end

			local full_lsp_str = lsp_str .. " " .. format_str .. " " .. lint_str
			return full_lsp_str
		end,
		color = { gui = "bold" },
		cond = function()
			return vim.o.columns > 100
		end,
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
			return "󰌒 " .. shiftwidth
		end,
		padding = 1,
	},
	encoding = {
		"o:encoding",
		fmt = string.upper,
		color = {},
		cond = function()
			return vim.o.columns > 100
		end,
	},
	filetype = {
		"filetype", --[[cond = nil, padding = { left = 1, right = 1 }]]
	},
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
