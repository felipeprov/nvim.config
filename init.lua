vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.g.mapleader = " "
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shell = "pwsh.exe"
vim.opt.shellcmdflag = "-NoLogo -NoProfile -Command"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

-- LSP keymaps: override Neovim defaults when an LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
    end

    -- What you care about:
    map("gd", vim.lsp.buf.definition,      "LSP: go to definition")
    map("gD", vim.lsp.buf.declaration,     "LSP: go to declaration")
    map("gi", vim.lsp.buf.implementation,  "LSP: go to implementation") -- nicer than `gri`
    --map("gr", vim.lsp.buf.references,      "LSP: references")
    map("K",  vim.lsp.buf.hover,           "LSP: hover")
    map("<leader>rn", vim.lsp.buf.rename,  "LSP: rename")
    map("<leader>ca", vim.lsp.buf.code_action, "LSP: code action")
  end,
})

require('config.lazy')

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show error" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Send to loclist" })

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})

--vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>", { desc = "Toggle terminal" })
---- Next buffer
--vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
---- Previous buffer
--vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
