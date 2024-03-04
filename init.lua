-- Author: Felipe provenzano
require("config.colors")
require("config.editor")
require("config.lazy_config")
require("config.remap")

-- setup my plugins
require("lazy").setup({
    { import = "plugins" }
})

-- setup my colors/transparency
--ColorMyVim()
