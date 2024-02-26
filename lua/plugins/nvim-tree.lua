return {
    "nvim-tree/nvim-tree.lua",
    config = function()
        vim.keymap.set("n", "<leader>po", vim.cmd.NvimTreeOpen)

        require("nvim-tree").setup {
        }
    end
}
