return {
	{
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},
	-- Core DAP
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- JS adapter bridge
			"mxsdev/nvim-dap-vscode-js",

			-- Actual VSCode JS debugger
			{
				"microsoft/vscode-js-debug",
				version = "1.x", -- keep in sync with nvim-dap-vscode-js docs
				build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
			},
		},
		config = function()
			local dap = require("dap")

			local mason = vim.fn.stdpath("data")
			local codelldb_path = mason .. "\\mason\\packages\\codelldb\\extension\\adapter\\codelldb.exe"
			local liblldb_path  = mason .. "\\mason\\packages\\codelldb\\extension\\lldb\\bin\\liblldb.dll"

			------------------------------------------------------------------
			-- Basic keymaps
			------------------------------------------------------------------
			local map = vim.keymap.set
			local opts = { noremap = true, silent = true }

			map("n", "<F5>",  function() dap.continue() end, opts)
			map("n", "<F10>", function() dap.step_over() end, opts)
			map("n", "<F11>", function() dap.step_into() end, opts)
			map("n", "<F12>", function() dap.step_out() end, opts)

			opts.desc = "Toggle breakpoint"
			map("n", "<leader>db", function() dap.toggle_breakpoint() end, opts)

			opts.desc = "Toggle breakpoint with condition"
			map("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, opts)

			opts.desc = "Open REPL"
			map("n", "<leader>dr", function() dap.repl.open() end, opts)
			opts.desc = "Run last"
			map("n", "<leader>dl", function() dap.run_last() end, opts)

			local js_debug_path = vim.fn.stdpath("data") .. "\\mason\\bin\\js-debug-adapter.cmd"

			dap.adapters["pwa-node"] = {
				type = "server",
				host = "::1",
				port = "${port}",
				executable = {
					command = js_debug_path,
					args = { "${port}" },
				},
			}

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = codelldb_path,
					args = { "--port", "${port}" },
					-- On some setups this helps it find liblldb:
					env = {
						LLDB_LIB_PATH = liblldb_path,
					},
				},
			}

			-- configurations for JS / TS
			for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch current file",
						program = "${file}",
						cwd = vim.fn.getcwd(),
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach to process",
						processId = require("dap.utils").pick_process,
						cwd = vim.fn.getcwd(),
					},
				}
			end

			-- configurations for c, cpp and rust
			for _, lang in ipairs({ "c", "cpp", "rust" }) do
				dap.configurations[lang] = {
					{
						name = "Launch (codelldb)",
						type = "codelldb",
						request = "launch",
						program = function()
							-- adjust if your exe is in build/ or has .exe
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "\\provengine.exe", "file")
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
						args = {},
						-- If you want to break on main reliably:
						-- initCommands = { "breakpoint set -n main" },
					},
				}
			end

		end,
	},
	-- ui
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup({
				controls = {
					enabled = true,
				},

				floating = { border = "single" },
				layouts = {
					{
						position = "bottom",
						size = 20,
						elements = {
							{ id = "scopes", size = 0.65 },     -- Variables
							{ id = "stacks", size = 0.35 },     -- Call stack
						},
					},
				},
			})

			-- Auto-open/close
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Keybinds
			vim.keymap.set("n", "<leader>du", dapui.toggle, { noremap = true, silent = true, desc = "Toggle DAP UI" })
			vim.keymap.set("n", "<leader>de", dapui.eval,   { noremap = true, silent = true, desc = "Eval under cursor" })
		end
}
}

