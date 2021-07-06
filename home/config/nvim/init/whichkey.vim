lua << EOF
local which_key = require("which-key")

which_key.setup({
  triggers = "auto"
})

vim.api.nvim_command('echo "Hello, Nvim!"')
EOF
