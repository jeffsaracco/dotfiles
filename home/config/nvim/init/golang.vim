let g:go_fmt_command = 'gofmt'
let g:go_addtags_transform = 'snakecase'
let g:go_list_type = 'quickfix'
let g:go_def_mode = 'gopls'
let g:go_decls_includes = 'func,type'

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1

function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

augroup go_config
  autocmd!
  autocmd FileType go setlocal noexpandtab nolist
  autocmd FileType go command! -buffer -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd FileType go command! -buffer -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd FileType go command! -buffer -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd FileType go command! -buffer -bang AT call go#alternate#Switch(<bang>0, 'tabe')
  autocmd FileType go nmap <buffer> <leader>r <Plug>(go-run)
  autocmd FileType go nnoremap <buffer> <leader>b <Cmd>call <SID>build_go_files()<CR>
  autocmd FileType go nmap <buffer> <leader>t <Plug>(go-test)
  autocmd FileType go nmap <buffer> <Leader>c <Plug>(go-coverage-toggle)
  autocmd FileType go nnoremap <buffer> <leader>d <Cmd>GoDecls<CR>
  autocmd FileType go nnoremap <buffer> <leader>D <Cmd>GoDeclsDir<CR>
augroup END
