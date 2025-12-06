return {
	-- Completion engine
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",     -- LSP source
			"hrsh7th/cmp-path",         -- filesystem paths
			"L3MON4D3/LuaSnip",         -- snippet engine (required)
			"saadparwaiz1/cmp_luasnip", -- snippet source
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local context = require("cmp.config.context")
			local neogen = require('neogen')
			local types = require("cmp.types")

			require("luasnip.loaders.from_vscode").lazy_load() -- optional

			cmp.setup({
				enabled = function()
					-- allow in command-line mode
					if vim.api.nvim_get_mode().mode == "c" then
						return true
					end

					-- disable in comments (including JSDoc)
					if context.in_treesitter_capture("comment") 
						or context.in_syntax_group("Comment") then
						return false
					end

					return true
				end,
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered({
						border = "rounded",
					}),
					documentation = cmp.config.window.bordered({
						border = "rounded",
					}),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- confirm completion
					["<Tab>"] = cmp.mapping(function(fallback)
						if neogen.jumpable() then
							neogen.jump_next()
						elseif cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if neogen.jumpable() then
							neogen.jump_prev()
						elseif cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				sources = {
					{
						name = "nvim_lsp",
						entry_filter = function(entry, ctx)
							-- hide plain text items coming from LSP
							local kind = entry:get_kind()
							local kind_text = types.lsp.CompletionItemKind.Text
							return kind ~= kind_text
						end,
					},
					{ name = "luasnip" },
					{ name = "path" },
				},
			})

			cmp.setup.filetype("cmake", {
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "buffer" },
				}),
			})
		end,
	},
}
