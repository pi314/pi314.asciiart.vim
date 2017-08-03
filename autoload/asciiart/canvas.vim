let s:buffer = {}

function! asciiart#canvas#store_lines (row1, row2) " {{{
    let l:min = min([a:row1, a:row2])
    let l:max = max([a:row1, a:row2])

    for l:line in range(l:min, l:max)
        if !has_key(s:buffer, l:line)
            let s:buffer[(l:line)] = getline('.')
        endif
    endfor
endfunction " }}}


function! asciiart#canvas#restore_lines (row1, row2) " {{{
    let l:min = min([a:row1, a:row2])
    let l:max = max([a:row1, a:row2])

    for l:line in range(l:min, l:max)
        if has_key(s:buffer, l:line)
            call setline(l:line, s:buffer[(l:line)])
            unlet s:buffer[(l:line)]
        endif
    endfor
endfunction " }}}


function! asciiart#canvas#restore_all_lines () " {{{
    for l:line in keys(s:buffer)
        call setline(l:line, s:buffer[(l:line)])
    endfor
    let s:buffer = {}
endfunction " }}}
