local default_opts = {
	noremap = true,
	silent = true,
}

--- @param opts (table|string|nil)
--- @return table
--- set noremap & silent = true by default
local get_opts = function(opts)
	local all_opts = nil
	if opts == nil or type(opts) == "string" then
		all_opts = {}
	else
		all_opts = opts
	end
	if type(opts) == "string" then
		all_opts["desc"] = opts
	end
	for k, v in pairs(default_opts) do
		all_opts[k] = all_opts[k] or v
	end
	return all_opts
end

--- @param vimmode (table|string|nil)
--- @return table
--- if mode not given assume n = normal mode
local get_mode = function(vimmode)
	if vimmode == nil then
		return { "n" }
	elseif type(vimmode) == "string" then
		return { vimmode }
	else
		return vimmode
	end
end

--- @param command (function|string)
--- @return string|function
local get_cmd_string = function(command)
	if type(command) == "string" then
		return [[<cmd>]] .. command .. [[<CR>]]
	end
	return command
end

--- @param keymaps string String
--- @param command (function|string)
--- @param vimmode (table|string|nil)
--- @param options (table|string|nil)
--- @return nil
local mapkey = function(keymaps, command, options, vimmode)
	local mode = get_mode(vimmode)
	local lhs = keymaps
	local rhs = command
	local opts = get_opts(options)
	vim.keymap.set(mode, lhs, rhs, opts)
end

--- @param keymaps string String
--- @param command (function|string)
--- @param vimmode (table|string|nil)
--- @param options (table|string|nil)
--- @return nil
local mapkey_cm = function(keymaps, command, options, vimmode)
	local rhs = get_cmd_string(command)
	local mode = get_mode(vimmode)
	for _, v in ipairs(mode) do
		if mode[v] ~= nil and mode[v] ~= "i" then -- don't let any "command mode" bindings be added in insert mode
			mode.insert(mode[v])
		end
	end
	mapkey(keymaps, rhs, options, mode)
end

return { mapkey = mapkey, mapkey_cm = mapkey_cm }
