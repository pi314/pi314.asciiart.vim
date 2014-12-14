" ============================================================================
" File:        asciiart.vim
" Description: A plugin helps you draw asciiarts
" Maintainer:  Pi314 <michael66230@gmail.com>
" Last Change: 2014/12/15
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================
"
vnoremap L :call MoveBlock('L')<CR>
vnoremap H :call MoveBlock('H')<CR>
vnoremap K :call MoveBlock('K')<CR>
vnoremap J :call MoveBlock('J')<CR>

function! MoveBlock (direction) range " {{{
    normal! gv

    if mode() != ''
        return
    endif

    " retrive visual block range
    let minl = line('.')
    let maxl = line('.')
    let minc = col('.')
    let maxc = col('.')
    normal! o
    let newl = line('.')
    let newc = col('.')
    normal! o
    let minl = l:minl < l:newl ? (l:minl) : (l:newl)
    let maxl = l:maxl > l:newl ? (l:maxl) : (l:newl)
    let minc = l:minc < l:newc ? (l:minc) : (l:newc)
    let maxc = l:maxc > l:newc ? (l:maxc) : (l:newc)

    if a:direction ==# 'L'
        let i = l:minl
        while l:i <= l:maxl
            let line = getline(l:i)
            let s1 = strpart(l:line, 0, l:minc-1)
            let s2 = l:line[(l:maxc)]
            if l:s2 == ''
                let l:s2 = ' '
            endif
            let s3 = l:line[(l:minc-1):(l:maxc-1)]
            let s4 = l:line[(l:maxc+1):]
            call setline(l:i, l:s1 . l:s2 . l:s3 . l:s4)
            let l:i = l:i + 1
        endwhile
        let l:minc = l:minc + 1
        let l:maxc = l:maxc + 1
        call cursor(l:minl, l:minc)
        normal! o
        call cursor(l:maxl, l:maxc)

    elseif a:direction ==# 'H'
        if l:minc == 1
            return
        endif

        let i = l:minl
        while l:i <= l:maxl
            let line = getline(l:i)
            let s1 = strpart(l:line, 0, l:minc-2)
            let s2 = l:line[(l:minc-1):(l:maxc-1)]
            let s3 = l:line[(l:minc-2)]
            let s4 = l:line[(l:maxc):]
            let sr = l:s3 . l:s4
            if l:sr =~# ' \+$'
                let l:sr = ''
            endif
            call setline(l:i, l:s1 . l:s2 . l:sr)
            let l:i = l:i + 1
        endwhile

        let l:minc = l:minc - 1
        let l:maxc = l:maxc - 1
        call cursor(l:minl, l:minc)
        normal! o
        call cursor(l:maxl, l:maxc)

    elseif a:direction ==# 'K' || a:direction ==# 'J'

        if l:minl == 1 && a:direction ==# 'K'
            call append(0, '')
            let minl = l:minl + 1
            let maxl = l:maxl + 1
            call cursor(l:minl, l:minc)
            normal! o
            call cursor(l:maxl, l:maxc)

        elseif l:maxl == line('$') && a:direction ==# 'J'
            call append(line('$'), '')

        endif

        " scroll line number - sln
        " .------------------. .------------------.
        " | &&&&& sln, minll | | .---. minl       |
        " | .---. minl       | | | v | minll      |
        " | | ^ |            | | | v |            |
        " | | ^ |            | | | v |            |
        " | | ^ | maxll      | | '---' maxl       |
        " | '---' maxl       | | &&&&& sln, maxll |
        " '------------------' '------------------'

        let minll = l:minl
        let maxll = l:maxl
        if a:direction ==# 'K'  " up
            let sln = l:minl - 1
            let move_dir = 1
            let minll = l:sln
            let maxll = l:maxl - 1
            let edge = l:maxl

        elseif a:direction ==# 'J' " down
            let sln = l:maxl + 1
            let move_dir = -1
            let minll = l:minl + 1
            let maxll = l:sln
            let edge = l:minl

        endif

        " back the scroll line first
        let slc = getline(l:sln)

        let i = l:sln
        while l:minll <= l:i && l:i <= l:maxll
            let thisline = getline(l:i)
            if strlen(l:thisline) < l:maxc
                let l:thisline = l:thisline .repeat(' ', l:maxc - strlen(l:thisline))
            endif
            let lastline = getline(l:i + l:move_dir)
            " put lastline onto thisline
            let s1 = strpart(l:thisline, 0, l:minc - 1)
            let s2 = l:lastline[ (l:minc-1) : (l:maxc-1)]
            let s3 = l:thisline[ (l:maxc) : ]
            call setline(l:i, l:s1 . l:s2 . l:s3)
            let l:i = l:i + l:move_dir

        endwhile

        if strlen(l:slc) < l:maxc
            let l:slc = l:slc .repeat(' ', l:maxc - strlen(l:slc) + 1)
        endif

        let thisline = getline(l:edge)
        let s1 = strpart(l:thisline, 0, l:minc - 1)
        let s2 = l:slc[ (l:minc-1) : (l:maxc-1) ]
        let s3 = l:thisline[ (l:maxc) : ]
        let content = matchstr(l:s1 . l:s2 . l:s3, '^.*[^ ]\( *$\)\@=')
        call setline(l:edge, l:content)

        if a:direction ==# 'K'
            let l:minl = l:minl - 1
            let l:maxl = l:maxl - 1
        elseif a:direction ==# 'J'
            let l:minl = l:minl + 1
            let l:maxl = l:maxl + 1
        endif

        call cursor(l:minl, l:minc)
        normal! o
        call cursor(l:maxl, l:maxc)

    endif

endfunction " }}}

vnoremap mf :call CreateFrame()<CR>
function! CreateFrame () range " {{{
    normal! gv

    if mode() != ''
        return
    endif

    " retrive visual block range
    let minl = line('.')
    let maxl = line('.')
    let minc = col('.')
    let maxc = col('.')

    normal! o
    let newl = line('.')
    let newc = col('.')
    normal! o
    let minl = l:minl < l:newl ? (l:minl) : (l:newl)
    let maxl = l:maxl > l:newl ? (l:maxl) : (l:newl)
    let minc = l:minc < l:newc ? (l:minc) : (l:newc)
    let maxc = l:maxc > l:newc ? (l:maxc) : (l:newc)

    if CheckFrame(l:minl, l:maxl, l:minc, l:maxc)
        let i = l:minl + 1
        while l:i < l:maxl
            let line = getline(l:i)
            call setline(l:i, strpart(l:line, 0, (l:minc-1)) .' '. l:line[(l:minc):(l:maxc-2)] .' '. l:line[(l:maxc):])
            let i = l:i + 1
        endwhile

        let t = repeat(' ', l:maxc - l:minc - 1)
        let line = getline(l:minl)
        call setline(l:minl, strpart(l:line, 0, (l:minc-1)) .' '. l:t .' '. l:line[(l:maxc):] )
        let line = getline(l:maxl)
        call setline(l:maxl, strpart(l:line, 0, (l:minc-1)) ." ". l:t ." ". l:line[(l:maxc):] )

    else
        let i = l:minl + 1
        while l:i < l:maxl
            let line = getline(l:i)
            let s1 = strpart(l:line, 0, (l:minc-1))
            let markup1 = ''
            let s2 = l:line[(l:minc):(l:maxc-2)]

            if strlen(l:line) < (l:minc-1)
                let markup1 = repeat(' ', l:minc - 1 - strlen(l:line))
                let s2 = repeat(' ', l:maxc - l:minc - 1)
            endif

            call setline(l:i, l:s1 . l:markup1 .'|'. l:s2 .'|'. l:line[(l:maxc):])
            let i = l:i + 1
        endwhile

        let t = repeat('-', l:maxc - l:minc - 1)
        let line = getline(l:minl)
        call setline(l:minl, strpart(l:line, 0, (l:minc-1)) .'.'. l:t .'.'. l:line[(l:maxc):] )
        let line = getline(l:maxl)
        call setline(l:maxl, strpart(l:line, 0, (l:minc-1)) ."'". l:t ."'". l:line[(l:maxc):] )

    endif

endfunction " }}}

function! CheckFrame (minl, maxl, minc, maxc) " {{{
    let i = a:minl + 1
    while l:i < a:maxl
        let line = getline(l:i)
        if l:line[(a:minc-1)] != '|' || l:line[(a:maxc-1)] != '|'
            return 0

        endif
        let i = l:i + 1
    endwhile

    let line = getline(a:minl)
    if l:line[(a:minc-1)] != '.' || l:line[(a:maxc-1)] != '.'
        return 0
    endif

    let i = a:minc + 1
    while l:i < a:maxc
        if l:line[(l:i-1)] != '-'
            return 0
        endif
        let i = l:i + 1
    endwhile

    let line = getline(a:maxl)
    if l:line[(a:minc-1)] != "'" || l:line[(a:maxc-1)] != "'"
        return 0
    endif

    let i = a:minc + 1
    while l:i < a:maxc
        if l:line[(l:i-1)] != '-'
            return 0
        endif
        let i = l:i + 1
    endwhile

    return 1

endfunction " }}}
