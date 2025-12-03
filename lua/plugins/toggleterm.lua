return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 15,
      shell = "pwsh",
      open_mapping = [[<C-\>]],
      direction = "horizontal", -- feels like VS Code
      shade_terminals = true,
    })
  end,
}
