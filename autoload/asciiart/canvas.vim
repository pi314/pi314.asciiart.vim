let s:buffer = {}


function! asciiart#canvas#store_lines (row1, row2) " {{{
    let l:min = min([a:row1, a:row2])
    let l:max = max([a:row1, a:row2])

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
