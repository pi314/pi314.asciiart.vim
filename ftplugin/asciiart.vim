" ============================================================================
" File:        asciiart.vim
" Description: A plugin helps you draw asciiarts
" Maintainer:  Pi314 <michael66230@gmail.com>
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================

setlocal conceallevel=3
setlocal nowrap


function! s:toggle_wrap () " {{{
    if &wrap
        setlocal nowrap
    else
        setlocal wrap
    endif
endfunction " }}}
nnoremap <silent> <Plug>AsciiartToggleWrap :call <SID>toggle_wrap()<CR>


function! s:toggle_conceal () " {{{
    if &conceallevel == 3
        setlocal conceallevel=0
    else
        setlocal conceallevel=3
    endif
endfunction " }}}
nnoremap <silent> <Plug>AsciiartToggleConceal :call <SID>toggle_conceal()<CR>


nmap <buffer> <LocalLeader>w <Plug>AsciiartToggleWrap
nmap <buffer> <LocalLeader>c <Plug>AsciiartToggleConceal
