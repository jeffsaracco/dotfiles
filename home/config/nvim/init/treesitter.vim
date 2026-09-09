lua << EOF
local parsers = {
  'bash',
  'css',
  'diff',
  'embedded_template',
  'git_config',
  'git_rebase',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'go',
  'gomod',
  'gosum',
  'gotmpl',
  'gowork',
  'html',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'query',
  'regex',
  'ruby',
  'vim',
  'vimdoc',
}

if vim.env.DOTFILES_NVIM_INSTALL_TOOLS == '1' then
  require('nvim-treesitter').install(parsers):wait(300000)
end
vim.treesitter.language.register('gotmpl', 'gohtml')

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('TreesitterStart', { clear = true }),
  pattern = {
    'bash', 'css', 'eruby', 'gitcommit', 'gitrebase', 'go', 'gohtml',
    'gomod', 'gosum', 'gotmpl', 'gowork', 'html', 'javascript', 'json',
    'lua', 'markdown', 'ruby', 'vim',
  },
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
EOF
