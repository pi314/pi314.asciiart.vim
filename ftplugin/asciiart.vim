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

let s:menu_items = [
        \ {
            \ 'desc': 'Toggle wrap (&wrap={&wrap})',
            \ 'map': "\<Plug>AsciiartToggleWrap",
        \},
        \ {
            \ 'desc': 'Toggle conceal (&conceallevel={&conceallevel})',
            \ 'map': "\<Plug>AsciiartToggleConceal",
        \ },
        \ ]
let s:menu_cursor = 0


function! s:parse_menu_desciption (desc) " {{{
    return substitute(a:desc, '\v\{([^}]+)\}', '\=exists(submatch(1)) ? eval(submatch(1)) : ""', 'g')
endfunction " }}}


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


function! s:show_menu () " {{{
    let l:key = '<nokey>'
    while v:true
        redraw!
        for l:idx in range(len(s:menu_items))
            echo (l:idx == s:menu_cursor ? '> ' : '  ') . s:parse_menu_desciption(s:menu_items[(l:idx)]['desc'])
        endfor
        echo ''

        let l:key = getchar()
        if l:key == char2nr('j')
            let s:menu_cursor = (s:menu_cursor + 1) % len(s:menu_items)
        elseif l:key == char2nr('k')
            let s:menu_cursor = (s:menu_cursor + len(s:menu_items) - 1) % len(s:menu_items)
        elseif l:key == char2nr("\<CR>")
            redraw!
            if has_key(s:menu_items[(s:menu_cursor)], 'map')
                call feedkeys(s:menu_items[(s:menu_cursor)]['map'])
            endif
            break
        endif
    endwhile
endfunction " }}}
nnoremap <silent> <Plug>AsciiartShowMenu :call <SID>show_menu()<CR>


nmap <buffer> <LocalLeader>w <Plug>AsciiartToggleWrap
nmap <buffer> <LocalLeader>c <Plug>AsciiartToggleConceal
nmap <buffer> <LocalLeader>m <Plug>AsciiartShowMenu
