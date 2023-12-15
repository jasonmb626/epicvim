return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = function()
			local dashboard = require("alpha.themes.dashboard")
			--https://www.asciiart.eu/text-to-ascii-art
			--Font Colossal
			--Slash frame 1 3
			local logo = [[
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//   8888888888 8888888b. 8888888 .d8888b.  888     888 8888888 888b     d888   //
//   888        888   Y88b  888  d88P  Y88b 888     888   888   8888b   d8888   //
//   888        888    888  888  888    888 888     888   888   88888b.d88888   //
//   8888888    888   d88P  888  888        Y88b   d88P   888   888Y88888P888   //
//   888        8888888P"   888  888         Y88b d88P    888   888 Y888P 888   //
//   888        888         888  888    888   Y88o88P     888   888  Y8P  888   //
//   888        888         888  Y88b  d88P    Y888P      888   888   "   888   //
//   8888888888 888       8888888 "Y8888P"      Y8P     8888888 888       888   //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
]]
			dashboard.section.header.val = vim.split(logo, "\n")
			dashboard.section.buttons.val = {
				dashboard.button("f", " " .. " Find file", "<cmd> Telescope find_files <cr>"),
				dashboard.button("n", " " .. " New file", "<cmd> ene <BAR> startinsert <cr>"),
				dashboard.button("r", " " .. " Recent files", "<cmd> Telescope oldfiles <cr>"),
				dashboard.button(
					"p",
					" " .. " Recent Projects",
					"<cmd> lua require('telescope').extensions.project.project({})<cr>"
				),
				dashboard.button("g", " " .. " Find text", "<cmd> Telescope live_grep <cr>"),
				dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
				dashboard.button("l", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"),
				dashboard.button(
					"c",
					" " .. " Configuration",
					"<cmd>lua vim.api.nvim_command('edit ' .. vim.call('stdpath', 'config'))<cr>"
				),
				dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"),
			}
			for _, button in ipairs(dashboard.section.buttons.val) do
				button.opts.hl = "markdownH4"
				-- button.opts.hl_shortcut = "Error"
				button.opts.hl_shortcut = "@warning"
			end
			-- to get a list of available hl options type :hl
			dashboard.section.header.opts.hl = "@type"
			return dashboard
		end,
		config = function(_, dashboard)
			require("alpha").setup(dashboard.opts)
			-- Disable folding on alpha buffer
			vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])
		end,
	},
}
