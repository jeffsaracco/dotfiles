set ignorecase

" Telescope

lua << EOF
local actions = require('telescope.actions')
local ts = require("telescope")
ts.setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--glob',
      "!.git/*"
    },
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    prompt_position = "top",
    prompt_prefix = "> ",
    layout_strategy = "horizontal",
    file_ignore_patterns = {
      "vendor/*",
      "bin/*",
      "modabin/*"
    },
    layout_defaults = {
      vertical = {
        mirror = true,
      },
    },
  },
  extensions = {
    frecency = {
      show_scores = true,
      show_unindexed = false,
      ignore_patterns = {"vendor/*", "tmp/*"},
      workspaces = { 
        ["conf"]    = "/Users/jeffsaracco/.config",
        ["data"]    = "/Users/jeffsaracco/.local/share",
      }
    }
  },
}
ts.load_extension("frecency")

local with_preview = {
  winblend = 10,
  show_line = false,
  results_title = false,
  preview_title = false,
  layout_config = {
    preview_width = 0.5,
  },
  hidden = false,
  find_command = {
    "rg", 
    "--files", 
    "--no-ignore",
    "--ignore-case",
    '--glob',
    "!.git/*"
  }
}

function fd()
  local opts = vim.deepcopy(with_preview)
  opts.prompt_prefix = '> '
  require'telescope.builtin'.find_files(opts)
end
EOF


nnoremap <leader>ff :lua fd()<cr>
nnoremap <c-p> :Telescope frecency<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>f\ <cmd>Telescope file_browser<cr>

highlight TelescopeSelection      guifg=#3ede66 gui=bold " selected item
highlight TelescopeSelectionCaret guifg=#CC241D " selection caret
highlight TelescopeMultiSelection guifg=#928374 " multisections
highlight TelescopeNormal         guibg=#00000  " floating windows created by telescope.

" Border highlight groups.
highlight TelescopeBorder         guifg=#ffffff
highlight TelescopePromptBorder   guifg=#ffffff
highlight TelescopeResultsBorder  guifg=#ffffff
highlight TelescopePreviewBorder  guifg=#ffffff

" Used for highlighting characters that you match.
highlight TelescopeMatching       guifg=#9a9c30

" Used for the prompt prefix
highlight TelescopePromptPrefix   guifg=red


" RG
let g:rg_highlight = 'true'
let g:rg_derive_root = 'true'
let g:rg_command = 'rg -S --vimgrep'
