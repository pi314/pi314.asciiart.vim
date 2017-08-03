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

let s:NONE = 'NONE'
let s:RECTANGLE = 'RECTANGLE'
let s:IDLE = 'IDLE'
let s:state = s:IDLE

let s:menu_items = [
        \ {
            \ 'desc': 'Toggle wrap (&wrap={&wrap})',
            \ 'map': "\<Plug>AsciiartToggleWrap",
        \},
        \ {
            \ 'desc': 'Toggle conceal (&conceallevel={&conceallevel})',
            \ 'map': "\<Plug>AsciiartToggleConceal",
        \ },
        \ {
            \ 'desc': 'Select rectangle-drawing tool',
            \ 'map': "\<Plug>AsciiartSelectRectangle",
        \ },
        \ ]
let s:menu_cursor = 0
let s:buffer = {}
let s:cvs_anchor = [-1, -1]
let s:cvs_last_cursor = [-1, -1]


function! s:parse_menu_desciption (desc) " {{{
    return substitute(a:desc, '\v\{([^}]+)\}', '\=eval(submatch(1))', 'g')
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
    try
        let l:more = &more
        set nomore
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
            elseif l:key == char2nr("\<C-c>")
                break
            endif
        endwhile
    finally
        let &more = l:more
        redraw!
    endtry
endfunction " }}}
nnoremap <silent> <Plug>AsciiartShowMenu :call <SID>show_menu()<CR>


function! s:select_tool (tool) " {{{
    " recover buffered lines
    for l:line in keys(s:buffer)
        call setline(l:line, s:buffer[(l:line)])
    endfor
    let s:buffer = {}

    if a:tool == s:RECTANGLE
        let s:state = s:RECTANGLE
    else
        let s:state = s:IDLE
        augroup asciiart
            autocmd! asciiart InsertEnter
            autocmd! asciiart CursorMoved
        augroup end
    endif
endfunction " }}}
execute 'nnoremap <silent> <Plug>AsciiartSelectRectangle :call <SID>select_tool("'. s:RECTANGLE .'")<CR>'
execute 'nnoremap <silent> <Plug>AsciiartCancelTool :call <SID>select_tool("'. s:NONE .'")<CR>'


function! s:trigger_tool () " {{{
    if s:state == s:RECTANGLE
        call s:trigger_rectangle()
    else
        call s:select_tool(s:NONE)
    endif
endfunction " }}}
nnoremap <silent> <Plug>AsciiartTriggertool :call <SID>trigger_tool()<CR>


function! s:trigger_rectangle () " {{{
    let s:cvs_anchor = getpos('.')[1:2]
    let s:cvs_last_cursor = copy(s:cvs_anchor)

    augroup asciiart
        autocmd! asciiart InsertEnter
        autocmd asciiart InsertEnter * call <SID>select_tool(s:NONE)

        autocmd! asciiart CursorMoved
        autocmd asciiart CursorMoved * call <SID>cursor_moved()
    augroup end
endfunction " }}}


function! s:store_lines (row1, row2) " {{{
    let l:min = min([a:row1, a:row2])
    let l:max = max([a:row1, a:row2])

    for l:line in range(l:min, l:max)
        if !has_key(s:buffer, l:line)
            let s:buffer[(l:line)] = getline('.')
        endif
    endfor
endfunction " }}}


function! s:restore_lines (row1, row2) " {{{
    let l:min = min([a:row1, a:row2])
    let l:max = max([a:row1, a:row2])

    for l:line in range(l:min, l:max)
        call setline(l:line, s:buffer[(l:line)])
        unlet s:buffer[(l:line)]
    endfor
endfunction " }}}


function! s:cursor_moved () " {{{
    if s:state == s:IDLE
        execute 'normal! '. a:key
        return

    elseif s:state == s:RECTANGLE
        let l:current_cursor = getpos('.')[1:2]

        if abs(s:cvs_anchor[0] - l:current_cursor[0]) < abs(s:cvs_anchor[0] - s:cvs_last_cursor[0])
            " rectangle range shrinked
            call s:restore_lines(l:current_cursor[0], s:cvs_last_cursor[0])
        endif

        call s:store_lines(s:cvs_anchor[0], l:current_cursor[0])

        let l:rng = sort([s:cvs_anchor[0], l:current_cursor[0]], 'n')
        for l:line in range(l:rng[0], l:rng[1])
            call setline(l:line, repeat('-', 50))
        endfor

        let s:cvs_last_cursor = getpos('.')[1:2]
    endif
endfunction " }}}
" nnoremap <silent> j :call <SID>cursor_move('j')<CR>
" nnoremap <silent> k :call <SID>cursor_move('k')<CR>
" nnoremap <silent> h :call <SID>cursor_move('h')<CR>
" nnoremap <silent> l :call <SID>cursor_move('l')<CR>


nmap <buffer> <LocalLeader>w <Plug>AsciiartToggleWrap
nmap <buffer> <LocalLeader>c <Plug>AsciiartToggleConceal
nmap <buffer> <LocalLeader>m <Plug>AsciiartShowMenu
nmap <buffer> <LocalLeader>r <Plug>AsciiartSelectRectangle
nmap <buffer> <CR>           <Plug>AsciiartTriggertool
nmap <buffer> <C-c>          <Plug>AsciiartCancelTool
