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
setlocal conceallevel=3
setlocal nowrap

let s:STATUS_NORMAL = 0
let s:STATUS_DRAW_LINE = 1
let s:status = s:STATUS_NORMAL

vnoremap L :call PressDir('L')<CR>
vnoremap H :call PressDir('H')<CR>
vnoremap K :call PressDir('K')<CR>
vnoremap J :call PressDir('J')<CR>

function! PressDir (direction) range " {{{
    if s:status == s:STATUS_NORMAL
        call MoveBlock(a:direction)
    endif
endfunction " }}}

function! GetSelectRegion () " {{{
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
    return [l:minl, l:maxl, l:minc, l:maxc]

endfunction " }}}

function! MoveBlock (direction) range " {{{

    let region = GetSelectRegion()
    let minl = l:region[0]
    let maxl = l:region[1]
    let minc = l:region[2]
    let maxc = l:region[3]

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

vnoremap mf :call MakeFrame()<CR>
function! MakeFrame () range " {{{
    let region = GetSelectRegion()
    let minl = l:region[0]
    let maxl = l:region[1]
    let minc = l:region[2]
    let maxc = l:region[3]

    let cf = CheckFrame(l:minl, l:maxl, l:minc, l:maxc)
    if l:cf == 0
        let corners = ".'-"
        let edges = '-|'

    elseif l:cf == 1
        let corners = "+++"
        let edges = '-|'

    else
        let corners = '   '
        let edges = '  '

    endif

    if l:minl == l:maxl && l:minc == l:maxc
        let line = getline(l:minl)
        call setline(l:minl, strpart(l:line, 0, (l:minc-1)) . l:edges[0] . l:line[ (l:maxc) : ])

    elseif l:minl == l:maxl
        let line = getline(l:minl)
        let s1 = strpart(l:line, 0, (l:minc-1))
        let s2 = l:line[ (l:maxc) : ]
        call setline(l:minl, l:s1 . l:corners[2] . repeat(l:edges[0], l:maxc - l:minc - 1) . l:corners[2] . l:s2)

    elseif l:minc == l:maxc
        let line = getline(l:minl)
        call setline(l:minl, strpart(l:line, 0, l:minc-1) . l:corners[0] . l:line[ (l:maxc) : ])

        let i = l:minl + 1
        while l:i < l:maxl
            let line = getline(l:i)
            call setline(l:i, strpart(l:line, 0, l:minc-1) . l:edges[1] . l:line[ (l:maxc) : ])
            let i = l:i + 1
        endwhile

        let line = getline(l:maxl)
        call setline(l:maxl, strpart(l:line, 0, l:minc-1) . l:corners[1] . l:line[ (l:maxc) : ])

    else
        let i = l:minl + 1
        while l:i < l:maxl
            let line = getline(l:i)
            if strlen(l:line) < (l:maxc-1)
                let l:line = l:line . repeat(' ', l:maxc - strlen(l:line) - 1)
            endif
            let s1 = strpart(l:line, 0, (l:minc-1))
            let s2 = l:line[(l:minc):(l:maxc-2)]
            call setline(l:i, l:s1 . l:edges[1] . l:s2 . l:edges[1] . l:line[(l:maxc):])
            let i = l:i + 1
        endwhile

        let t = repeat(l:edges[0], l:maxc - l:minc - 1)
        let line = getline(l:minl)
        call setline(l:minl, strpart(l:line, 0, (l:minc-1)) . l:corners[0] . l:t . l:corners[0] . l:line[(l:maxc):] )
        let line = getline(l:maxl)
        call setline(l:maxl, strpart(l:line, 0, (l:minc-1)) . l:corners[1] . l:t . l:corners[1] . l:line[(l:maxc):] )

    endif

endfunction " }}}

function! CheckFrame (minl, maxl, minc, maxc) " {{{
    if a:minl == a:maxl && a:minc == a:maxc
        let line = getline(a:minl)
        if l:line[(a:minc-1)] == '-'
            return 2
        endif
        return 0

    elseif a:minl == a:maxl
        let line = getline(a:minl)
        let vertice = l:line[(a:minc-1)] . l:line[(a:maxc-1)]
        if l:vertice == '++'
            return 2

        elseif l:vertice == '--'
            return 1

        endif

        return 0
    endif

    let i = a:minl + 1
    while l:i < a:maxl
        let line = getline(l:i)
        if l:line[(a:minc-1)] != '|' || l:line[(a:maxc-1)] != '|'
            return 0

        endif
        let i = l:i + 1
    endwhile

    let top_line = getline(a:minl)
    let bot_line = getline(a:maxl)
    let i = a:minc + 1
    while l:i < a:maxc
        if l:top_line[(l:i-1)] != '-' || l:bot_line[(l:i-1)] != '-'
            return 0
        endif
        let i = l:i + 1
    endwhile

    let corners = l:top_line[(a:minc-1)] . l:top_line[(a:maxc-1)] . l:bot_line[(a:minc-1)] . l:bot_line[(a:maxc-1)]
    if l:corners == '++++'
        return 2
    elseif l:corners == "..''"
        return 1
    else
        return 0
    endif

endfunction " }}}

command! -nargs=0 NewFrame call NewFrame()
function! NewFrame () " {{{
    " 80 x 24
    call append('.', '.'.repeat('-', 78).'.')
    let mid_line = '|'.repeat(' ', 78).'|'
    let cln = line('.')
    let i = 1
    while l:i < 23
        call append(l:cln + l:i, l:mid_line)
        let l:i = l:i + 1
    endwhile
    call append(l:cln + 23, "'".repeat('-', 78)."'")
endfunction " }}}

vnoremap <leader>y :call YankBlock()<CR>
let s:yank_buffer = []
function! YankBlock () range " {{{
    let region = GetSelectRegion()
    let minl = l:region[0]
    let maxl = l:region[1]
    let minc = l:region[2]
    let maxc = l:region[3]

    let s:yank_buffer = []
    for i in range(l:minl, l:maxl)
        let line = getline(i)
        call add(s:yank_buffer, strpart( l:line, l:minc-1, l:maxc-l:minc+1 ) )
    endfor
    normal! vv

endfunction " }}}

nnoremap <leader>p :call PasteBlock()<CR>
function! PasteBlock () " {{{
    let row = line('.')
    let col = col('.')
    for i in range(0, len(s:yank_buffer) - 1)
        let line = getline(l:row + i)
        if strlen(l:line) < (l:col - 1)
            let l:line = l:line . repeat(' ', l:col - 1 - strlen(l:line))
        endif
        let s1 = strpart(l:line, 0, l:col - 1)
        let s2 = s:yank_buffer[i]
        let s3 = l:line[ (l:col - 1 + strlen(l:s2) ) : ]
        cal setline(l:row + i, l:s1 . l:s2 . l:s3)
    endfor

endfunction " }}}

nnoremap <leader>w :call ToggleWrap()<CR>
function! ToggleWrap () " {{{
    if &wrap
        setlocal nowrap
    else
        setlocal wrap
    endif
endfunction " }}}

nnoremap <leader>c :call ToggleConceal()<CR>
function! ToggleConceal () " {{{
    if &conceallevel == 3
        setlocal conceallevel=0
    else
        setlocal conceallevel=3
    endif
endfunction " }}}
