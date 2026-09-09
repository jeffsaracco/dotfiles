if executable('jq')
  nnoremap <leader>j <Cmd>setfiletype json<Bar>%!jq .<CR>
endif
