return {

	{ "nvimdev/dashboard-nvim", enabled = false },
	{ "echasnovski/mini.starter", enabled = false },
	-- Dashboard. This runs when neovim starts, and is what displays
	-- the "LAZYVIM" banner.
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		enabled = true,
		init = false,
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
      -- stylua: ignore
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file",       "<cmd> Telescope find_files <cr>"),
        dashboard.button("n", " " .. " New file",        "<cmd> ene <BAR> startinsert <cr>"),
        dashboard.button("r", " " .. " Recent files",    "<cmd> Telescope oldfiles <cr>"),
        dashboard.button("g", " " .. " Find text",       "<cmd> Telescope live_grep <cr>"),
        dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
        dashboard.button("l", "󰒲 " .. " Lazy",            "<cmd> Lazy <cr>"),
        dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
      }
			for _, button in ipairs(dashboard.section.buttons.val) do
				button.opts.hl = "AlphaButtons"
				button.opts.hl_shortcut = "AlphaShortcut"
			end
			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.opts.hl = "AlphaButtons"
			dashboard.section.footer.opts.hl = "AlphaFooter"
			dashboard.opts.layout[1].val = 8
			return dashboard
		end,
		config = function(_, dashboard)
			-- close Lazy and re-open when the dashboard is ready
			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					once = true,
					pattern = "AlphaReady",
					callback = function()
						require("lazy").show()
					end,
				})
			end

			require("alpha").setup(dashboard.opts)

			vim.api.nvim_create_autocmd("User", {
				once = true,
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					dashboard.section.footer.val = "⚡ Neovim loaded "
						.. stats.loaded
						.. "/"
						.. stats.count
						.. " plugins in "
						.. ms
						.. "ms"
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},
}
