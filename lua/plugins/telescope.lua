return {
  "nvim-telescope/telescope.nvim",
  tag = "v0.2.0",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        prompt_prefix = "   ",
        selection_caret = "➤ ",
        path_display = { "smart" },

        -- Use ripgrep for live_grep, etc. (if installed)
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },

        layout_strategy = "flex",
        layout_config = {
          horizontal = { preview_width = 0.55 },
          vertical = { width = 0.9, height = 0.9 },
        },

        sorting_strategy = "ascending",
        scroll_strategy = "limit",
        wrap_results = true,
        dynamic_preview_title = true,

        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "dist/",
          "build/",
          "yarn.lock",
          "package%-lock.json",
        },
      },

      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          -- you can tweak this if you want to search hidden, etc.
        },
        buffers = {
          sort_mru = true,
          ignore_current_buffer = true,
        },
      },
    })

    --------------------------------------------------------------------
    -- Keymaps (minimal but powerful)
    --------------------------------------------------------------------
    local map = vim.keymap.set
    local opts = { silent = true, noremap = true }

    -- Files / search
    map("n", "<leader>ff", builtin.find_files,  vim.tbl_extend("force", opts, { desc = "Telescope: Find files" }))
    map("n", "<leader>fa", builtin.live_grep,   vim.tbl_extend("force", opts, { desc = "Telescope: Live grep" }))
    map("n", "<leader>fb", builtin.buffers,     vim.tbl_extend("force", opts, { desc = "Telescope: Buffers" }))
    map("n", "<leader>fh", builtin.help_tags,   vim.tbl_extend("force", opts, { desc = "Telescope: Help tags" }))
    map("n", "<leader>fr", builtin.oldfiles,    vim.tbl_extend("force", opts, { desc = "Telescope: Recent files" }))
    map("n", "<leader>fk", builtin.keymaps,    vim.tbl_extend("force", opts, { desc = "Telescope: Keymaps" }))

    -- LSP-related (works great with your LSP setup)
    map("n", "<leader>fd", builtin.diagnostics, vim.tbl_extend("force", opts, { desc = "Telescope: Diagnostics" }))
    map("n", "<leader>fs", builtin.lsp_document_symbols,
      vim.tbl_extend("force", opts, { desc = "Telescope: Document symbols" }))
    map("n", "<leader>fS", builtin.lsp_workspace_symbols,
      vim.tbl_extend("force", opts, { desc = "Telescope: Workspace symbols" }))

    -- Git (only if you're in a git repo)
    map("n", "<leader>fgf", builtin.git_files,  vim.tbl_extend("force", opts, { desc = "Telescope: Git files" }))
    map("n", "<leader>fgc", builtin.git_commits,vim.tbl_extend("force", opts, { desc = "Telescope: Git commits" }))

    -- Resume last picker
    map("n", "<leader>f.", builtin.resume,      vim.tbl_extend("force", opts, { desc = "Telescope: Resume last" }))
  end,
}
