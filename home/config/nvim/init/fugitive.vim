augroup fugitive_config
  autocmd!
  autocmd BufReadPost fugitive://* setlocal bufhidden=delete
  autocmd BufReadPost .git/index setlocal nolist
augroup END
