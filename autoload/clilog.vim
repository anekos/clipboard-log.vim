if exists('g:loaded_clilog_autoload')
  finish
endif
let g:loaded_clilog_autoload = 1
let s:save_cpo = &cpo
set cpo&vim

let g:clilog_watch_interval = 200
let g:clilog_register = '*'

let s:enabled = v:false
let s:timer = v:null
let s:previous_register_value = v:null
let s:target_buffer = v:null

function! s:clipboard_content() abort
  return getreg(g:clilog_register)
endfunction

function! clilog#watch(...) abort
  let l:current = s:clipboard_content()
  if s:previous_register_value == l:current
    return
  endif
  call appendbufline(s:target_buffer, '$', l:current)
  let s:previous_register_value = l:current
endfunction

function! clilog#toggle() abort
  let s:enabled = !s:enabled
  if s:enabled
    let s:target_buffer = bufnr('%')
    let s:previous_register_value = s:clipboard_content()
    let s:timer = timer_start(g:clilog_watch_interval, function('clilog#watch'), {'repeat': -1})
    echomsg 'Clilog: enabled'
  else
    call timer_stop(s:timer)
    echomsg 'Clilog: disabled'
  endif
endfunction

command! CtrlPGrep  call ctrlp#grep#prompt()

let &cpo = s:save_cpo
unlet s:save_cpo
