set ignorecase

" FZF
map <leader>F   :FzfPreviewGitStatus<CR>
map <leader>f   :FzfPreviewProjectFiles<CR>
nnoremap <c-p> :FzfPreviewProjectMruFiles<CR>

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let $FZF_DEFAULT_OPTS='--color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54 --layout=reverse  --margin=2,5'

" RG
let g:rg_highlight = 'true'
let g:rg_derive_root = 'true'
let g:rg_command = 'rg -S --vimgrep'

set grepprg=rg\ --vimgrep

command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --glob "!.git/*" -g "!vendor/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
