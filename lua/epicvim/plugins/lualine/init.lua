local lualine_setup = require("epicvim.plugins.lualine.setup")
local config = function()
	lualine_setup.setup()
end

return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	config = config,
}
