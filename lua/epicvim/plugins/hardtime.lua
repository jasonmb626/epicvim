return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	opts = { enabled = false },
	config = function()
		vim.keymap.set("n", "<leader>SH", function()
			local status = require("hardtime").is_plugin_enabled
			status = not status
			if status then
				require("hardtime").enable()
				print("Hardtime enabled")
			else
				require("hardtime").disable()
				print("Hardtime disabled")
			end
		end, { desc = "Toggle Hardtime" })
	end,
}
