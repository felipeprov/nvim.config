return {
	"neovim/nvim-lspconfig",
	config = function()
		----------------------------------------------------------------------
		-- 1. Common on_attach: keymaps etc.
		----------------------------------------------------------------------
		local function on_attach(client, bufnr)
		end

		----------------------------------------------------------------------
		-- 2. Set defaults for *all* servers from nvim-lspconfig
		--    (this replaces the old `require('lspconfig').xyz.setup{}` style)
		----------------------------------------------------------------------
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		vim.lsp.config("*", {
			on_attach = on_attach,
			-- you can add capabilities, flags, etc. here if needed
			capabilities = capabilities,
		})

		vim.lsp.config("lua_ls", {
			cmd = { 'lua-language-server' },
			filetypes = { 'lua' },
			root_markers = {
				'.emmyrc.json',
				'.luarc.json',
				'.luarc.jsonc',
				'.luacheckrc',
				'.stylua.toml',
				'stylua.toml',
				'selene.toml',
				'selene.yml',
				'.git',
			},
			settings = {
				Lua = {
					codeLens = { enable = true },
					hint = { enable = true, semicolon = 'Disable' },
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					}
				},
			},
		})

		----------------------------------------------------------------------
		-- 3. Optional: extra config for specific servers
		----------------------------------------------------------------------
		----------------------------------------------------------------------
		-- 4. Enable the servers you want
		--    (they must be installed on your system)
		----------------------------------------------------------------------
		vim.lsp.enable({
			"lua_ls",
			"ts_ls",
			"clangd",
			"cmake"
			-- add more here as you install them
		})
	end,
}
