function! s:ReplaceMotion(type, ...)
  let reg = empty(s:lastreg) ? '"' : s:lastreg
  let op_mode = 'v'      " default: character
  let marks   = '<>'     " default: visual mode

  if !a:0 " normal mode
    let marks = '[]'
    if a:type == 'line'
      let op_mode = 'V'
      call setreg(reg[:-2], getreg(reg), getregtype(reg))
    endif
  endif

  let ai_back = &autoindent
  exe 'normal! `'.marks[1].'$'
  exe 'normal! `'.marks[0].'"_c'.op_mode.'`'.marks[1]."\<C-R>".reg."\<ESC>"
endfunction

function! s:ReplaceLine(type, ...)
  let reg = empty(s:lastreg) ? '"' : s:lastreg
  exe 'normal! "_d' . (s:lastcnt==1 ? 'd' : s:lastcnt.'j')
  if getregtype(reg)=='V'
    " linewise
    exe 'normal! "'.reg.'P'
  else
    " emulate linewise
    exe "normal! O\<C-R>".reg."\<ESC>"
  endif
endfunction

function! s:SaveReg()
  let s:lastreg = v:register
  let s:lastcnt = v:count1
endfunction

" default mapping
if !hasmapto('<Plug>ReplaceMotion', 'n')
  nmap <silent> <C-K> <Plug>ReplaceMotion
endif
if !hasmapto('<Plug>ReplaceLine', 'n')
  nmap <silent> <C-K><C-K> <Plug>ReplaceLine
endif
if !hasmapto('<Plug>ReplaceVisual', 'v')
  vmap <silent> <C-K> <Plug>ReplaceVisual
endif

" export the plugin mapping
nnoremap <silent> <Plug>ReplaceMotion :<C-U>call <SID>SaveReg()<CR><ESC>:set opfunc=<SID>ReplaceMotion<CR>g@
nnoremap <silent> <Plug>ReplaceLine :<C-U>call <SID>SaveReg()<CR><ESC>:call <SID>ReplaceLine('line')<CR>
vnoremap <silent> <Plug>ReplaceVisual :<C-U>call <SID>SaveReg()<CR><ESC>:call <SID>ReplaceMotion('', 1)<CR>
