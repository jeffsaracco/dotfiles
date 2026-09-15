if executable('jq')
  nnoremap <localleader>j <Cmd>setfiletype json<Bar>%!jq .<CR>
endif
