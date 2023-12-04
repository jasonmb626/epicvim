return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			opts = {},
			config = function(_, opts)
				-- setup dap config by VsCode launch.json file
				-- require("dap.ext.vscode").load_launchjs()
				local dap = require("dap")
				local dapui = require("dapui")
				dapui.setup(opts)
				dap.listeners.after.event_initialized["dapui_config"] = function()
					dapui.open({})
				end
				dap.listeners.before.event_terminated["dapui_config"] = function()
					dapui.close({})
				end
				dap.listeners.before.event_exited["dapui_config"] = function()
					dapui.close({})
				end
			end,
		},
		config = function()
			local dap = require("dap")
			dap.adapters["local-lua"] = {
				type = "executable",
				command = "node",
				args = {
					"/home/dev/git/local-lua-debugger-vscode/extension/debugAdapter.js",
				},
				enrich_config = function(config, on_config)
					if not config["extensionPath"] then
						local c = vim.deepcopy(config)
						-- 💀 If this is missing or wrong you'll see
						-- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
						c.extensionPath = "/home/dev/git/local-lua-debugger-vscode/"
						on_config(c)
					else
						on_config(config)
					end
				end,
			}
			dap.configurations.lua = {
				{
					name = "Current file (local-lua-dbg, nlua)",
					type = "local-lua",
					request = "launch",
					cwd = "${workspaceFolder}",
					program = {
						lua = "nlua.lua",
						file = "${file}",
					},
					verbose = true,
					args = {},
				},
			}
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function(_, opts)
			local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(path)
		end,
	},
}
