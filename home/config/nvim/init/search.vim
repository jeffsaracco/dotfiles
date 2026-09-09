let g:fzf_mru_relative = 1
let g:fzf_mru_no_sort = 1

nnoremap <leader>ff <Cmd>Files<CR>
nnoremap <leader>fh <Cmd>History<CR>
nnoremap <C-p> <Cmd>FZFMru<CR>
nnoremap <leader>fb <Cmd>BCommits<CR>

let g:rg_highlight = 'true'
let g:rg_derive_root = 'true'
let g:rg_command = 'rg -S --vimgrep'
