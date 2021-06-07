set ignorecase

let $FZF_DEFAULT_OPTS='--color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54 --layout=reverse --margin=2,5'

let g:fzf_mru_relative = 1
let g:fzf_mru_no_sort = 1

nnoremap <leader>ff :Files<cr>
nnoremap <c-p> :FZFMru<CR>
nnoremap <leader>fb :BCommits<cr>


" RG
let g:rg_highlight = 'true'
let g:rg_derive_root = 'true'
let g:rg_command = 'rg -S --vimgrep'
