return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim", -- optional but recommended
    "sindrets/diffview.nvim",        -- optional: for better diffs
  },
  config = function()
    require("neogit").setup({
      integrations = {
        telescope = true,
        diffview = true,
      },
      signs = {
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
      },
    })

    -- Keymap (VS Code style)
    vim.keymap.set("n", "<leader>gs", "<cmd>Neogit<CR>", {
      desc = "Open Neogit (Git Status)",
    })
  end,
}
