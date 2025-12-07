vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.numberwidth = 4
vim.opt.mouse = "a"
vim.opt.winborder = "rounded"
vim.g.mapleader = " "
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shell = "pwsh.exe"
--vim.opt.shell = "kitty"
vim.opt.shellcmdflag = "-NoLogo -NoProfile -Command"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes:1"
vim.opt.wrap = false

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

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Send to loclist" })

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})


-- Make all LSP floating windows use rounded borders by default
local orig_floating_preview = vim.lsp.util.open_floating_preview

---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_floating_preview(contents, syntax, opts, ...)
end

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      higroup = "Visual",      -- what highlight group to use
      timeout = 200,           -- time in ms the highlight stays
      on_visual = true,        -- highlight visual-mode yanks too
    })
  end,
})

vim.opt.makeprg = "cmake --build build -j"
vim.keymap.set("n", "<leader>hs", "<Cmd>LspClangdSwitchSourceHeader<CR>", { desc = "Switch header/source" })

vim.api.nvim_set_hl(0, "BufferLineSeparator",           { fg = "#1e1e1e", bg = "NONE" })
vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible",    { fg = "#1e1e1e", bg = "NONE" })
vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected",   { fg = "#1e1e1e", bg = "NONE" })

