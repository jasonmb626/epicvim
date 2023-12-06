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
--https://stackoverflow.com/questions/9145432/load-lua-files-by-relative-path

local folder_this_file = get_revised_cwd(...)
local parent_path = get_parent_path(folder_this_file)

local conform = require("conform")
local hardtime = require("hardtime")
local nvim_autopairs = require("nvim-autopairs")
local illuminate_engine = require("illuminate.engine")

local format_options = require(parent_path .. ".config.formatting").format_options

local M = {}

M.toggle_illuminate = function()
	local paused = illuminate_engine.is_paused()
	paused = not paused
	illuminate_engine.toggle()
	if paused then
		print("Illuminate paused")
	else
		print("Illuminate started")
	end
end

M.set_conceallevel = function()
	vim.ui.select({ 0, 1, 2, 3 }, {}, function(selection)
		vim.opt.conceallevel = selection
		print("Set conceallevel to " .. selection)
	end)
end

M.toggle_treesitter_context = function()
	require("treesitter-context").toggle()
	print("Treesitter context toggled")
end

M.toggle_hardtime = function()
	local status = hardtime.is_plugin_enabled
	status = not status
	if status then
		hardtime.enable()
		print("Hardtime enabled")
	else
		hardtime.disable()
		print("Hardtime disabled")
	end
end

M.toggle_ts_highlights = function()
	if vim.b.ts_highlight then
		vim.treesitter.stop()
		print("Disabled Treesitter Highlight")
	else
		vim.treesitter.start()
		print("Enabled Treesitter Highlight")
	end
end

M.toggle_diagnostics = function()
	local status = vim.diagnostic.is_disabled()
	if status == false then
		vim.diagnostic.disable()
		print("Diagnostics disabled")
	else
		vim.diagnostic.enable()
		print("Diagnostics enabled")
	end
end

M.toggle_autopairs = function()
	if vim.g.autopairs ~= nil and vim.g.autopairs == true then
		vim.g.autopairs = false
		nvim_autopairs.enable()
		print("Autopairs enabled")
	else
		vim.g.autopairs = true
		nvim_autopairs.disable()
		print("Autopairs disabled")
	end
end

M.toggle_autoformatting = function()
	if vim.g.autoformat ~= nil and vim.g.autoformat == true then
		vim.g.autoformat = false
		conform.setup({ format_on_save = false })
		print("Disabled autoformatting")
	else
		vim.g.autoformat = true
		conform.setup({ format_on_save = format_options })
		print("Enabled autoformatting")
	end
end

M.toggle = function(feature)
	local tbl = vim.opt
	local status = tbl[feature]:get()
	status = not status
	tbl[feature] = status
	if feature == "number" and status == false then
		tbl["relativenumber"] = false
	end
	if status then
		print(feature .. " enabled")
	else
		print(feature .. " disabled")
	end
end

return M
