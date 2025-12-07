return {
	"neovim/nvim-lspconfig",
	config = function()
		vim.lsp.handlers["textDocument/signatureHelp"] =
		vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
		})
		----------------------------------------------------------------------
		-- 1. Common on_attach: keymaps etc.
		----------------------------------------------------------------------
		local function on_attach(client, bufnr)
			local opts = { buffer = bufnr, silent = true }
			vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
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

		-- Auto-trigger signature help for languages that support it
		local sig_triggers = { ["("] = true, [","] = true, ["<"] = true }

		vim.api.nvim_create_autocmd("InsertCharPre", {
			callback = function()
				local ch = vim.v.char
				if not sig_triggers[ch] then
					return
				end

				-- Only do this in buffers with LSP that supports signature help
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				for _, client in ipairs(clients) do
					if client.server_capabilities.signatureHelpProvider then
						-- Optional: limit to JS/TS if you want
						local ft = vim.bo.filetype
						if ft == "javascript" or ft == "javascriptreact"
							or ft == "typescript" or ft == "typescriptreact" then
							-- call after the char is actually inserted
							vim.defer_fn(function()
								pcall(vim.lsp.buf.signature_help)
							end, 0)
						end
						break
					end
				end
			end,
		})
	end,
}
