let g:ale_linters = {
\   'javascript': ['eslint'],
\   'go': ['gofmt', 'gopls'],
\   'ruby': ['solargraph', 'rubocop'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'vim': [ 'remove_trailing_lines', 'trim_whitespace' ],
\   'go': ['gofmt'],
\   'ruby': ['remove_trailing_lines', 'rubocop', 'trim_whitespace'],
\}


" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

let g:ale_sign_column_always = 0

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

let g:ale_open_list = 1
" Set this if you want to.
" This can be useful if you are combining ALE with
" some other plugin which sets quickfix errors, etc.
let g:ale_keep_list_window_open = 0

let g:ale_list_window_size = 8

" Disable Ale until save
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
" You can disable this option too
" " if you don't want linters to run on opening a file
let g:ale_lint_on_enter = 0

" Change highlights so not so ugly
highlight ALEWarning ctermbg=DarkMagenta
highlight ALEError ctermbg=DarkMagenta
