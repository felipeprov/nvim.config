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
		end,
	},
}

