if not vim.g.vscode then
	local getconf_ok, getconf_output = pcall(vim.fn.system, { "getconf", "GNU_LIBC_VERSION" })
	if getconf_ok and getconf_output:find("glibc") then
		vim.g.platform = "glibc"
	end
	local ldd_ok, ldd_output = pcall(vim.fn.system, { "ldd", "--version" })
	if ldd_ok then
		if ldd_output:find("musl") then
			vim.g.platform = "musl"
		elseif ldd_output:find("GLIBC") or ldd_output:find("glibc") or ldd_output:find("GNU") then
			vim.g.platform = "glibc"
		end
	end

	require("epicvim.config.options") -- make sure mapleader and global plugin configs set first
	require("epicvim.setup_lazy")
	require("epicvim.config.autocmds")
	require("epicvim.config.keymaps") -- make sure keymaps is last. We really do want these to override anything else
	-- vim.cmd([[ colorscheme moonfly ]])
	if not vim.g.vscode then
		vim.cmd([[ colorscheme nightfly ]])
	end
end
