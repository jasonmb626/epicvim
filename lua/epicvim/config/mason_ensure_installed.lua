--https://stackoverflow.com/questions/9145432/load-lua-files-by-relative-path
local pathOfThisFile = ...
local folderOfThisFile = (...):match("(.-)[^%.]+$")
local templates = require(folderOfThisFile .. ".mason_ensure_installed_templates")
local M = {}

--M.lsp = extend_array(templates.lsp.base, templates.lsp.python)
--M.tools = extend_array(templates.tools.base, templates.tools.python)

-- Set a base
M.lsp = vim.deepcopy(templates.lsp.base)
M.tools = vim.deepcopy(templates.tools.base)

-- Set the project-specific lsps, formatters, and debuggers you want actually installed below.
vim.list_extend(M.lsp, templates.lsp.python)
vim.list_extend(M.tools, templates.tools.python)

return M
