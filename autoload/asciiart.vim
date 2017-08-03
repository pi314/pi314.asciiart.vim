let s:state = 'IDLE'


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


function! asciiart#toggle_conceal () " {{{
    if &conceallevel == 3
        setlocal conceallevel=0
    else
        setlocal conceallevel=3
    endif
endfunction " }}}


function! asciiart#toggle_wrap () " {{{
    if &wrap
        setlocal nowrap
    else
        setlocal wrap
    endif
endfunction " }}}


function! asciiart#select_tool (tool) " {{{
    " recover buffered lines
    call asciiart#canvas#restore_lines()

    if a:tool == 'RECTANGLE'
        let s:state = 'RECTANGLE'
        call asciiart#rectangle#reset()
    else
        if s:state == 'RECTANGLE'
            call asciiart#rectangle#reset()
        endif

        let s:state = 'IDLE'
    endif
endfunction " }}}


function! asciiart#show_menu () " {{{
    let l:key = '<nokey>'
    try
        let l:more = &more
        set nomore
        while v:true
            redraw!
            for l:idx in range(len(s:menu_items))
                echo (l:idx == s:menu_cursor ? '> ' : '  ') . asciiart#utility#parse_menu_desciption(s:menu_items[(l:idx)]['desc'])
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


function! asciiart#tool_trigger () " {{{
    if s:state == 'RECTANGLE'
        call asciiart#rectangle#trigger()
    else
        call asciiart#select_tool('NONE')
    endif
endfunction " }}}


function! asciiart#tool_cancel () " {{{
    if s:state == 'RECTANGLE'
        call asciiart#rectangle#cancel()
    endif
endfunction " }}}
