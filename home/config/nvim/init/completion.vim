let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('sources', {
      \ '_': ['ale','tabnine'],
      \})

call deoplete#custom#option({
      \ 'auto_complete_delay': 500,
      \ 'auto_completion_start_length': 3,
      \ 'smart_case': v:true,
      \ })
