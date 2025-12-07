local tokyo = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = 'night'
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd("colorscheme tokyonight")
  end,
}

local vscode = {
  "Mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("vscode").setup({
      transparent = true,
      italic_comments = true,
    })
    require("vscode").load()
    vim.cmd([[
      hi Normal guibg=NONE ctermbg=NONE
      hi NormalNC guibg=NONE ctermbg=NONE
      hi SignColumn guibg=NONE ctermbg=NONE
      hi LineNr guibg=NONE ctermbg=NONE
      hi CursorLineNr guibg=NONE ctermbg=NONE

      hi NormalFloat guibg=NONE ctermbg=NONE
      hi FloatBorder guibg=NONE ctermbg=NONE

      hi Pmenu guibg=NONE ctermbg=NONE
      hi PmenuSel guibg=NONE ctermbg=NONE

      hi StatusLine guibg=NONE ctermbg=NONE
      hi StatusLineNC guibg=NONE ctermbg=NONE
    ]])
  end,
}

return vscode
