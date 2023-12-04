local templates = {}

templates.lsp = {}
templates.tools = {}

-- base configuration
templates.lsp.base = {
	"lua_ls", -- may need to edit neovim config files whenever so make lua always
}
templates.tools.base = {}

-- Language specific configurations
templates.lsp.typescript = {
	"tsserver",
	"html",
	"cssls",
	"emmet_ls",
}

templates.lsp.python = {
	-- "pyright", --We're getting this from pip3
}

templates.tools.python = {
	"debugpy",
	"isort", -- python formatter
	"black", -- python formatter
	"pylint", -- python linter
}

templates.tools.typescript = {
	"eslint_d", -- js linter
	"prettier", -- prettier formatter
}

return templates
