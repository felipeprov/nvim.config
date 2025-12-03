return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")

    wk.setup({
      plugins = {
        marks = true,
        registers = true,
        spelling = { enabled = true },
      },
      win = {
        border = "rounded",
      },
    })

    -- Optional: register top-level prefixes so the which-key menu looks clean
    wk.add( {
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "lsp" },
    })
  end,
}
