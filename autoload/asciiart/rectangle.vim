function! asciiart#rectangle#reset () " {{{
    let s:state = 'IDLE'
    let s:anchor1 = [-1, -1]
    let s:anchor2 = [-1, -1]
    let s:last_cursor = [-1, -1]
    let s:top_corner = ['.', '+']
    let s:bot_corner = ['''', '+']
    let s:shape = 0

    augroup asciiart
        autocmd! asciiart InsertEnter
        autocmd! asciiart CursorMoved
    augroup end
    call asciiart#canvas#restore_lines()

    silent! nunmap <buffer> o
    silent! nunmap <buffer> O
    silent! nunmap <buffer> <Space>
    silent! nunmap <buffer> H
    silent! nunmap <buffer> J
    silent! nunmap <buffer> K
    silent! nunmap <buffer> L
endfunction " }}}


function! asciiart#rectangle#trigger () " {{{
    if s:state == 'IDLE'
        let s:anchor1 = getpos('.')[1:2]
        let s:last_cursor = copy(s:anchor1)
        augroup asciiart
            autocmd! asciiart InsertEnter
            autocmd asciiart InsertEnter * :call asciiart#rectangle#reset()

            autocmd! asciiart CursorMoved
            autocmd asciiart CursorMoved * :call asciiart#rectangle#cursor_moved()
        augroup end

        nnoremap <buffer> <silent> o :call asciiart#rectangle#switch_anchor_o()<CR>
        nnoremap <buffer> <silent> O :call asciiart#rectangle#switch_anchor_O()<CR>
        nnoremap <buffer> <silent> <Space> :call asciiart#rectangle#change_skin()<CR>
        nnoremap <buffer> H :call asciiart#rectangle#shift_rectangle( 0, -1)<CR>
        nnoremap <buffer> J :call asciiart#rectangle#shift_rectangle( 1,  0)<CR>
        nnoremap <buffer> K :call asciiart#rectangle#shift_rectangle(-1,  0)<CR>
        nnoremap <buffer> L :call asciiart#rectangle#shift_rectangle( 0,  1)<CR>

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

    let s:anchor2 = getpos('.')[1:2]
    call s:draw_rectangle()

    let s:last_cursor = getpos('.')[1:2]
endfunction " }}}


function! s:draw_rectangle () " {{{
    let l:row_rng = sort([s:anchor1[0], s:anchor2[0]], 'n')
    let l:col_rng = sort([s:anchor1[1], s:anchor2[1]], 'n')

    call asciiart#canvas#set_store_range(s:anchor1[0], s:anchor2[0])

    for l:line in range(l:row_rng[0], l:row_rng[1])
        let l:str = asciiart#canvas#getline(l:line)
        let l:str1 = strpart(l:str, 0, l:col_rng[0] - 1)
        let l:str1 .= repeat(' ', (l:col_rng[0] - 1) - strlen(l:str1))
        if l:line == l:row_rng[0]
            let l:str2 = s:top_corner[(s:shape)]
            let l:str3 = repeat('-', l:col_rng[1] - l:col_rng[0] - 1)
            let l:str4 = l:col_rng[0] == l:col_rng[1] ? '' : s:top_corner[(s:shape)]
        elseif l:line == l:row_rng[1]
            let l:str2 = s:bot_corner[(s:shape)]
            let l:str3 = repeat('-', l:col_rng[1] - l:col_rng[0] - 1)
            let l:str4 = l:col_rng[0] == l:col_rng[1] ? '' : s:bot_corner[(s:shape)]
        else
            let l:str2 = '|'
            let l:str3 = strpart(l:str, l:col_rng[0], l:col_rng[1] - l:col_rng[0] - 1)
            let l:str3 .= repeat(' ', (l:col_rng[1] - l:col_rng[0] - 1) - strlen(l:str3))
            let l:str4 = l:col_rng[0] == l:col_rng[1] ? '' : '|'
        endif
        let l:str5 = strpart(l:str, l:col_rng[1])
        call setline(l:line, l:str1 . l:str2 . l:str3 . l:str4 . l:str5)
    endfor
endfunction " }}}


function! asciiart#rectangle#cancel () " {{{
    if s:state == 'IDLE'
        call asciiart#select_tool('NONE')
    elseif s:state == 'ANCHOR_SET'
        call asciiart#rectangle#reset()
    endif
endfunction " }}}


function! asciiart#rectangle#switch_anchor_o () " {{{
    let [s:anchor2[0], s:anchor1[0]] = [s:anchor1[0], s:anchor2[0]]
    let [s:anchor2[1], s:anchor1[1]] = [s:anchor1[1], s:anchor2[1]]
    call cursor(s:anchor2[0], s:anchor2[1])
endfunction " }}}


function! asciiart#rectangle#switch_anchor_O () " {{{
    let [s:anchor2[1], s:anchor1[1]] = [s:anchor1[1], s:anchor2[1]]
    call cursor(s:anchor2[0], s:anchor2[1])
endfunction " }}}


function! asciiart#rectangle#change_skin () " {{{
    let s:shape = (s:shape + len(s:top_corner)) % len(s:top_corner)
endfunction " }}}


function! asciiart#rectangle#shift_rectangle (d_row, d_col) " {{{
    let l:row_rng = sort([s:anchor1[0], s:anchor2[0]], 'n')
    let l:col_rng = sort([s:anchor1[1], s:anchor2[1]], 'n')

    if l:row_rng[0] + a:d_row < 1 || l:col_rng[0] + a:d_col < 1
        return
    endif

    if l:row_rng[1] + a:d_row > line('$')
        for l:i in range(l:row_rng[1] + a:d_row - line('$'))
            call append('$', '')
        endfor
    endif

    let s:anchor1[0] += a:d_row
    let s:anchor1[1] += a:d_col
    let s:anchor2[0] += a:d_row
    let s:anchor2[1] += a:d_col

    call s:draw_rectangle()

    call cursor(s:anchor2[0], s:anchor2[1])
endfunction " }}}
