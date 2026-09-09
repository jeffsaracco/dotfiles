let mapleader = ","
let maplocalleader = ";"

cnoreabbrev <expr> W getcmdtype() ==# ':' && getcmdline() ==# 'W' ? 'w' : 'W'
cnoreabbrev <expr> Wq getcmdtype() ==# ':' && getcmdline() ==# 'Wq' ? 'wq' : 'Wq'
cnoreabbrev <expr> WQ getcmdtype() ==# ':' && getcmdline() ==# 'WQ' ? 'wq' : 'WQ'
cnoreabbrev <expr> Q getcmdtype() ==# ':' && getcmdline() ==# 'Q' ? 'q' : 'Q'

nnoremap Y y$
nnoremap <leader>s :%s/
xnoremap <leader>s :s/

nnoremap <leader>v <Cmd>vsplit<CR>
nnoremap <leader>w <C-w>w
nnoremap <leader>= <C-w>=
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

nnoremap <leader>rv <Cmd>source $MYVIMRC<CR>
nnoremap <leader>i mzgg=G`z
nnoremap <silent> <F7> mzgg=G`z<Cmd>delmarks z<CR><Cmd>echo "Reformatted."<CR>

inoremap jj <Esc>
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
xnoremap <Tab> >gv
xnoremap <S-Tab> <gv

nnoremap <leader>g <Cmd>Git blame<CR>
nnoremap <silent> <leader>lg <Cmd>LazyGit<CR>

cmap <C-A> <C-B>

nnoremap <silent> <D-C> <Cmd>let @+ = expand('%')<Bar>echo 'Copied: '.expand('%')<CR>
nnoremap <leader>C <Cmd>let @+ = expand('%').':'.line('.')<Bar>echo 'Copied: '.expand('%').':'.line('.')<CR>
nnoremap <silent> <Space> <Cmd>nohlsearch<Bar>echo<CR>
nnoremap <silent> <Leader>tc <Cmd>Colors<CR>
