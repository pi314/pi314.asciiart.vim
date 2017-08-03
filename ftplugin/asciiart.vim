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


nnoremap <silent> <Plug>AsciiartToggleWrap :call asciiart#toggle_wrap()<CR>
nnoremap <silent> <Plug>AsciiartToggleConceal :call asciiart#toggle_conceal()<CR>
nnoremap <silent> <Plug>AsciiartShowMenu :call asciiart#show_menu()<CR>
nnoremap <silent> <Plug>AsciiartToolTrigger :call asciiart#tool_trigger()<CR>
nnoremap <silent> <Plug>AsciiartSelectRectangle :call asciiart#select_tool('rectangle')<CR>
nnoremap <silent> <Plug>AsciiartToolCancel :call asciiart#tool_cancel()<CR>


nmap <buffer> <LocalLeader>w <Plug>AsciiartToggleWrap
nmap <buffer> <LocalLeader>c <Plug>AsciiartToggleConceal
nmap <buffer> <LocalLeader>m <Plug>AsciiartShowMenu
nmap <buffer> <LocalLeader>r <Plug>AsciiartSelectRectangle
nmap <buffer> <CR>           <Plug>AsciiartToolTrigger
nmap <buffer> <C-c>          <Plug>AsciiartToolCancel
