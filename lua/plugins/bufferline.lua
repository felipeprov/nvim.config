return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional but recommended
  },
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers",
        numbers = "none",
        diagnostics = "nvim_lsp",
        separator_style = "slant", -- VSCode-like
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = false,

        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
        },
      },
    })

    -- Keymaps (clean + intuitive)
    local map = vim.keymap.set

    map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
    map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
    map("n", "<leader>q", "<cmd>bdelete<CR>", { desc = "Close buffer" })
    map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
    map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })


    -- Quick jump to buffers 1–9 (VS Code style)
    for i = 1, 9 do
      map("n", "<leader>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<CR>", {
        desc = "Go to buffer " .. i,
      })
    end
  end,
}
