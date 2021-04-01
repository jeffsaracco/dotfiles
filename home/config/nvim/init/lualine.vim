let g:lualine = {
    \'options' : {
    \  'theme' : 'powerline',
    \  'section_separators' : ['', ''],
    \  'component_separators' : ['', ''],
    \  'icons_enabled' : v:true,
    \},
    \'sections' : {
    \  'lualine_a' : [ ['mode', {'upper': v:true,},], ],
    \  'lualine_b' : [ ['branch', {'icon': '',}, ], ],
    \  'lualine_c' : [
    \       ['filename', {'file_status': v:true, 'full_path': v:true,},],
    \       ['diagnostics', {'sources': [ 'ale', 'nvim_lsp' ],  'color_info': '#ffffff', 'color_error': '#ff0000', 'color_warn': 'fff000',}, ],
    \       ['diff', {'color_added': '#27e000', 'color_modified': '#fff000', 'color_deleted': '#ffffff',}, ],
    \   ],
    \  'lualine_x' : [ 'location'  ],
    \  'lualine_y' : [ 'progress' ],
    \  'lualine_z' : [ 'encoding', 'fileformat', 'filetype',  ],
    \},
    \'inactive_sections' : {
    \  'lualine_a' : [  ],
    \  'lualine_b' : [  ],
    \  'lualine_c' : [ 'filename' ],
    \  'lualine_x' : [ 'location' ],
    \  'lualine_y' : [  ],
    \  'lualine_z' : [  ],
    \},
    \'extensions' : [ 'fzf', 'fugitive', 'nerdtree' ],
    \}
lua require("lualine").setup()
