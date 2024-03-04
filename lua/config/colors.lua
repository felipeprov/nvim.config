--- Set the background transparent for me
--- Set the colorscheme to rose-pine
function ColorMyVim(color)
    color = color or "tokyonight-night"
    vim.cmd.colorscheme(color)

    --    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    --    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    --    vim.api.nvim_set_hl(0, "NormalSB", { bg = "none" })
    --    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
end
