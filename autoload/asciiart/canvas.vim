let s:buffer = {}


function! asciiart#canvas#store_lines (...) " {{{
    if a:0 == 1
        let l:min = a:1
        let l:max = a:1
    elseif a:0 == 2
        let l:min = min([a:1, a:2])
        let l:max = max([a:1, a:2])
    endif

    for l:line in range(l:min, l:max)
        if !has_key(s:buffer, l:line)
            let s:buffer[(l:line)] = getline(l:line)
        endif
    endfor
endfunction " }}}


function! asciiart#canvas#restore_lines (...) " {{{
    if a:0 == 0
        let l:min = min(keys(s:buffer))
        let l:max = max(keys(s:buffer))
    elseif a:0 == 1
        let l:min = a:1
        let l:max = a:1
    elseif a:0 == 2
        let l:min = min([a:1, a:2])
        let l:max = max([a:1, a:2])
    else
        echom 'invalid argument'
        return
    endif

    for l:line in range(l:min, l:max)
        if has_key(s:buffer, l:line)
            call setline(l:line, s:buffer[(l:line)])
            unlet s:buffer[(l:line)]
        endif
    endfor
endfunction " }}}


function! asciiart#canvas#commit_lines (...) " {{{
    if a:0 == 0
        let l:min = min(keys(s:buffer))
        let l:max = max(keys(s:buffer))
    elseif a:0 == 2
        let l:min = min([a:1, a:2])
        let l:max = max([a:1, a:2])
    else
        echom 'invalid argument'
        return
    endif

    for l:line in range(l:min, l:max)
        if has_key(s:buffer, l:line)
            unlet s:buffer[(l:line)]
        endif
    endfor
endfunction " }}}


function! asciiart#canvas#getline (line) " {{{
    return get(s:buffer, a:line, '')
endfunction " }}}


function! asciiart#canvas#set_store_range (row1, row2) " {{{
    call asciiart#canvas#store_lines(a:row1, a:row2)

    let [l:row1, l:row2] = sort([a:row1, a:row2], 'n')
    for l:row in keys(s:buffer)
        if l:row < l:row1 || l:row2 < l:row
            call asciiart#canvas#restore_lines(l:row)
        endif
    endfor
endfunction " }}}
