lua << EOF
opts = {
    options = {
        theme = 'powerline',
        section_separators = {'', ''},
        component_separators = {'', ''},
        icons_enabled = true,
        },
    sections = {
        lualine_a = {{'mode', upper = true}},
        lualine_b = {{'branch', icon= ''}},
        lualine_c = { 
            {'filename', file_status = true, full_path = true, shorten = true},
            {'diagnostics', sources = { 'nvim_diagnostic' },  color_info = '#ffffff', color_error = '#ff0000', color_warn = 'fff000'},
            {'diff', color_added = '#27e000', color_modified = '#fff000', color_deleted = '#ffffff'},
        },
    lualine_x = { 'location' },
    lualine_y = { 'progress' },
    lualine_z = { 'encoding', 'fileformat', 'filetype', },
    },
inactive_sections = {
    lualine_a = {  },
    lualine_b = {  },
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {  },
    lualine_z = {  },
    },
extensions = { 'fzf', 'fugitive'},
}
require("lualine").setup(opts)
EOF
