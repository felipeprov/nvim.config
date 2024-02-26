return  {
    'nvim-orgmode/orgmode',
    dependencies = {
        'nvim-treesitter/nvim-treesitter'
    },
    event = 'VeryLazy',
    config = function()
        require('orgmode').setup_ts_grammar()

        require('nvim-treesitter.configs').setup({
            highlight = {
                enable = true,
            },
            ensure_installed = {'org'}
        })

        require('orgmode').setup({
            org_agenda_files = 'D:/0.Configuration/orgmode/**/*',
            org_default_notes_files = 'D:/0.Configuration/orgmode/refile.org',
        })
    end
}
