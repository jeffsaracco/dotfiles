nnoremap \ <Cmd>NvimTreeToggle<CR>
nnoremap \| <Cmd>NvimTreeFindFile<CR>

lua << EOF
local function on_attach(bufnr)
  local api = require('nvim-tree.api')
  local function opts(desc)
    return {
      desc = 'nvim-tree: ' .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 's', api.node.open.vertical, opts('Open vertical split'))
  vim.keymap.set('n', 'i', api.node.open.horizontal, opts('Open horizontal split'))
  vim.keymap.set('n', 't', api.node.open.tab, opts('Open tab'))
  vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent'))
  vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close parent'))
  vim.keymap.set('n', 'H', api.filter.dotfiles.toggle, opts('Toggle dotfiles'))
  vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
  vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
  vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
  vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
  vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
  vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
  vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
  vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy name'))
  vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy relative path'))
  vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy absolute path'))
  vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
  vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
end

require('nvim-tree').setup({
  on_attach = on_attach,
  disable_netrw = true,
  hijack_netrw = true,
  renderer = {
    group_empty = true,
    highlight_git = 'name',
    root_folder_label = false,
  },
  diagnostics = { enable = true },
  update_focused_file = { enable = true },
  filters = { dotfiles = false },
  git = { enable = true, timeout = 500 },
  view = { width = 30, side = 'left' },
  actions = {
    open_file = {
      quit_on_open = true,
      window_picker = { enable = false },
    },
  },
})
EOF
