return {
    "nvim-tree/nvim-tree.lua",
    config = function()
        vim.keymap.set("n", "<leader>po", vim.cmd.NvimTreeOpen)

        local function my_on_attach(bufnr)
            local api = require("nvim-tree.api")
            local function opts(desc)
                return {
                    desc = "nvim-tree: " .. desc,
                    buffer = bufnr,
                    silent = true,
                    noremap = true,
                    nowait = true,

                }
            end

            api.config.mappings.default_on_attach(bufnr)

            -- custom
            vim.keymap.set('n', '<C-z>', api.node.open.vertical, opts('Open:  Vertical Split'))
        end

        require("nvim-tree").setup {
            diagnostics = {
                enable = true
            },
            on_attach = my_on_attach
        }
    end
}
