return {
    "neovim/nvim-lspconfig",
    config = function()
    ----------------------------------------------------------------------
    -- 1. Common on_attach: keymaps etc.
    ----------------------------------------------------------------------
    local function on_attach(client, bufnr)
    end

    ----------------------------------------------------------------------
    -- 2. Set defaults for *all* servers from nvim-lspconfig
    --    (this replaces the old `require('lspconfig').xyz.setup{}` style)
    ----------------------------------------------------------------------
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    vim.lsp.config("*", {
      on_attach = on_attach,
      -- you can add capabilities, flags, etc. here if needed
      capabilities = capabilities,
    })

    ----------------------------------------------------------------------
    -- 3. Optional: extra config for specific servers
    ----------------------------------------------------------------------
    
    ----------------------------------------------------------------------
    -- 4. Enable the servers you want
    --    (they must be installed on your system)
    ----------------------------------------------------------------------
    vim.lsp.enable({
      "lua_ls",
      "ts_ls",
      -- "pyright",
      -- "ts_ls",     -- new name for the TypeScript/JS server in lspconfig 
      -- "clangd",
      -- add more here as you install them
    }) 
    end,
  }