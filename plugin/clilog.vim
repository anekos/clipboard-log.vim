if exists('g:loaded_clilog')
  finish
endif
let g:loaded_clilog = 1
let s:save_cpo = &cpo
set cpo&vim

command! Clilog  call clilog#toggle()

let &cpo = s:save_cpo
unlet s:save_cpo
