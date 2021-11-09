lua <<EOF
vim.g.kommentary_create_default_mappings = false

require 'kommentary.config' 

vim.api.nvim_set_keymap("n", "<leader>/", "<Plug>kommentary_line_default", {})
vim.api.nvim_set_keymap("x", "<leader>/", "<Plug>kommentary_visual_default", {})
EOF
