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
			vim.keymap.set("n", "<leader>db", require("dap").step_back, { desc = "Step Back" })
			vim.keymap.set("n", "<leader>dc", require("dap").continue, { desc = "Continue" })
			vim.keymap.set("n", "<leader>dC", require("dap").run_to_cursor, { desc = "Run To Cursor" })
			vim.keymap.set("n", "<leader>dd", require("dap").disconnect, { desc = "Disconnect" })
			vim.keymap.set({ "n", "v" }, "<leader>de", require("dapui").eval, { desc = "Eval" })
			vim.keymap.set("n", "<leader>dg", require("dap").session, { desc = "Get Session" })
			vim.keymap.set("n", "<leader>di", require("dap").step_into, { desc = "Step Into" })
			vim.keymap.set("n", "<leader>do", require("dap").step_over, { desc = "Step Over" })
			vim.keymap.set("n", "<leader>dp", require("dap").pause, { desc = "Pause" })
			vim.keymap.set("n", "<leader>dq", require("dap").close, { desc = "Quit" })
			vim.keymap.set("n", "<leader>dr", require("dap").repl.toggle, { desc = "Toggle Repl" })
			vim.keymap.set("n", "<leader>ds", require("dap").continue, { desc = "Start" })
			vim.keymap.set("n", "<leader>dt", require("dap").toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>du", require("dap").step_out, { desc = "Step Out" })
			vim.keymap.set("n", "<leader>dU", function()
				require("dapui").toggle({ reset = true })
			end, { desc = "Toggle UI" })
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
