-----------------------------  Define some helper functions --------------------------------------
--              These are for allowing imports to be based on relative path
--https://stackoverflow.com/questions/72921364/whats-the-lua-equivalent-of-pythons-endswith
local function endswith(str, suffix)
	return str:sub(-#suffix) == suffix
end

--https://stackoverflow.com/questions/1426954/split-string-in-lua
local function split(str, sep)
	local result = {}
	local regex = ("([^%s]+)"):format(sep)
	for each in str:gmatch(regex) do
		table.insert(result, each)
	end
	return result
end

local function get_parent_path(cwd)
	local splitpath = split(cwd, ".")
	table.remove(splitpath)
	return table.concat(splitpath, ".") -- this is now one directory up from cwd in lua format
end

local function get_revised_cwd(dotdotdot)
	-- if file ends in init.lua return dotdotdot otherwise go up one "dot"
	local filename = debug.getinfo(1, "S").source
	if endswith(filename, "init.lua") then
		return dotdotdot
	else
		return get_parent_path(dotdotdot)
	end
end

-----------------------------  Start of actual config --------------------------------------------
local folder_this_file = get_revised_cwd(...)
local parent_path = get_parent_path(folder_this_file)

local ensure_installed = require(parent_path .. ".config.mason_ensure_installed")

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
			ensure_installed = ensure_installed.lsp,
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		})

		mason_tool_installer.setup({
			ensure_installed = ensure_installed.tools,
		})
	end,
}
