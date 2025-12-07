return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 25,
      shell = "pwsh",
      open_mapping = [[<C-\>]],
      direction = "float", -- feels like VS Code
      shade_terminals = true,
    })
  end,
}
