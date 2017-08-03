function! asciiart#rectangle#reset () " {{{
    let s:cvs_anchor = [-1, -1]
    let s:cvs_last_cursor = [-1, -1]
endfunction " }}}


function! asciiart#rectangle#select () " {{{
endfunction " }}}


function! asciiart#rectangle#trigger () " {{{
    let s:cvs_anchor = getpos('.')[1:2]
    let s:cvs_last_cursor = copy(s:cvs_anchor)

    augroup asciiart
        autocmd! asciiart InsertEnter
        autocmd asciiart InsertEnter * call <SID>select_tool(s:NONE)

        autocmd! asciiart CursorMoved
        autocmd asciiart CursorMoved * call asciiart#rectangle#cursor_moved()
    augroup end
endfunction " }}}


function! asciiart#rectangle#cursor_moved () " {{{
    let l:current_cursor = getpos('.')[1:2]

    if abs(s:cvs_anchor[0] - l:current_cursor[0]) < abs(s:cvs_anchor[0] - s:cvs_last_cursor[0])
        " rectangle range shrinked
        call asciiart#canvas#restore_lines(l:current_cursor[0], s:cvs_last_cursor[0])
    endif

    call asciiart#canvas#store_lines(s:cvs_anchor[0], l:current_cursor[0])

    let l:rng = sort([s:cvs_anchor[0], l:current_cursor[0]], 'n')
    for l:line in range(l:rng[0], l:rng[1])
        call setline(l:line, repeat('-', 50))
    endfor

    let s:cvs_last_cursor = getpos('.')[1:2]
endfunction " }}}
