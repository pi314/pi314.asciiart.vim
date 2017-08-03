function! asciiart#rectangle#reset () " {{{
    let s:state = 'IDLE'
    let s:anchor = [-1, -1]
    let s:last_cursor = [-1, -1]

    augroup asciiart
        autocmd! asciiart InsertEnter
        autocmd! asciiart CursorMoved
    augroup end
    call asciiart#canvas#restore_lines()

    silent! nunmap <buffer> o
    silent! nunmap <buffer> O
endfunction " }}}


function! asciiart#rectangle#trigger () " {{{
    if s:state == 'IDLE'
        let s:anchor = getpos('.')[1:2]
        let s:last_cursor = copy(s:anchor)
        augroup asciiart
            autocmd! asciiart InsertEnter
            autocmd asciiart InsertEnter * :call asciiart#rectangle#reset()

            autocmd! asciiart CursorMoved
            autocmd asciiart CursorMoved * :call asciiart#rectangle#cursor_moved()
        augroup end

        nnoremap <buffer> <silent> o :call asciiart#rectangle#switch_anchor_o()<CR>
        nnoremap <buffer> <silent> O :call asciiart#rectangle#switch_anchor_O()<CR>

        let s:state = 'ANCHOR_SET'
    elseif s:state == 'ANCHOR_SET'
        call asciiart#canvas#commit_lines()
        call asciiart#rectangle#reset()
    endif
endfunction " }}}


function! asciiart#rectangle#cursor_moved () " {{{
    if getchar(1)
        return
    endif

    let l:current_cursor = getpos('.')[1:2]

    if abs(s:anchor[0] - l:current_cursor[0]) < abs(s:anchor[0] - s:last_cursor[0])
        " rectangle range shrinked
        call asciiart#canvas#restore_lines(l:current_cursor[0], s:last_cursor[0])
    endif

    call asciiart#canvas#store_lines(s:anchor[0], l:current_cursor[0])

    let l:row_rng = sort([s:anchor[0], l:current_cursor[0]], 'n')
    let l:col_rng = sort([s:anchor[1], l:current_cursor[1]], 'n')
    for l:line in range(l:row_rng[0], l:row_rng[1])
        let l:str = asciiart#canvas#getline(l:line)
        let l:str1 = strpart(l:str, 0, l:col_rng[0] - 1)
        if l:line == l:row_rng[0]
            let l:str2 = '.'
            let l:str3 = repeat('-', l:col_rng[1] - l:col_rng[0] - 1)
            let l:str4 = l:col_rng[0] == l:col_rng[1] ? '' : '.'
        elseif l:line == l:row_rng[1]
            let l:str2 = ''''
            let l:str3 = repeat('-', l:col_rng[1] - l:col_rng[0] - 1)
            let l:str4 = l:col_rng[0] == l:col_rng[1] ? '' : ''''
        else
            let l:str2 = '|'
            let l:str3 = strpart(l:str, l:col_rng[0], l:col_rng[1] - l:col_rng[0] - 1)
            let l:str4 = l:col_rng[0] == l:col_rng[1] ? '' : '|'
        endif
        let l:str5 = strpart(l:str, l:col_rng[1])
        call setline(l:line, l:str1 . l:str2 . l:str3 . l:str4 . l:str5)
    endfor

    let s:last_cursor = getpos('.')[1:2]
endfunction " }}}


function! asciiart#rectangle#cancel () " {{{
    if s:state == 'IDLE'
        call asciiart#select_tool('NONE')
    elseif s:state == 'ANCHOR_SET'
        call asciiart#rectangle#reset()
    endif
endfunction " }}}


function! asciiart#rectangle#switch_anchor_o () " {{{
    let l:current_cursor = getpos('.')[1:2]
    let [l:current_cursor[0], s:anchor[0]] = [s:anchor[0], l:current_cursor[0]]
    let [l:current_cursor[1], s:anchor[1]] = [s:anchor[1], l:current_cursor[1]]
    call cursor(l:current_cursor[0], l:current_cursor[1])
endfunction " }}}


function! asciiart#rectangle#switch_anchor_O () " {{{
    let l:current_cursor = getpos('.')[1:2]
    let [l:current_cursor[1], s:anchor[1]] = [s:anchor[1], l:current_cursor[1]]
    call cursor(l:current_cursor[0], l:current_cursor[1])
endfunction " }}}
