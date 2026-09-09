lua << EOF
local opts = {
  options = {
    theme = 'powerline',
    component_separators = { left = '|', right = '|' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      { 'mode', fmt = string.upper },
    },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = {
      { 'filename', path = 2 },
    },
    lualine_x = { 'location' },
    lualine_y = { 'progress' },
    lualine_z = { 'encoding', 'fileformat', 'filetype' },
  },
  extensions = { 'fzf', 'fugitive' },
}

require('lualine').setup(opts)
EOF
