return {
	"danymat/neogen",
	dependencies = "nvim-treesitter/nvim-treesitter",
	config = function()
		require("neogen").setup({
			enabled = true,
			languages = {
				javascript = {
					template = {
						annotation_convention = "jsdoc",
					},
				},
				typescript = {
					template = {
						annotation_convention = "tsdoc",
					},
				},
				c = {
					template = {
						annotation_convention = "doxygen",  -- or "kernel_doc"
					},
				},
			},
		})

		-- Keymap: Generate doc for function/class
		vim.keymap.set("n", "<leader>df", function()
			require("neogen").generate({ type = "func"})
		end, { desc = "Generate documentation for function" })
		vim.keymap.set("n", "<leader>dd", function()
			require("neogen").generate()
		end, { desc = "Generate documentation" })
		vim.keymap.set("n", "<leader>dc", function()
			require("neogen").generate({ type = "class"})
		end, { desc = "Generate documentation for class" })
		vim.keymap.set("n", "<leader>dt", function()
			require("neogen").generate({ type = "type"})
		end, { desc = "Generate documentation for type" })
		vim.keymap.set("n", "<leader>dF", function()
			require("neogen").generate({ type = "file"})
		end, { desc = "Generate documentation for file" })
	end,
}
