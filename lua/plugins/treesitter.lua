return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/playground"
	},
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = {"c",
                                "lua",
                                "cpp",
                                "vim",
                                "vimdoc",
                                "org",
                                "c_sharp" },
			sync_install = false,
			highlight = {
                enable = true,
--                disable = {'org'},
--                additional_vim_regex_highlighting = { 'org' }
            },
			indent = { enable = true },
		})
	end
}

