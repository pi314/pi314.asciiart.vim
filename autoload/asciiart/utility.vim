function! asciiart#utility#parse_menu_desciption (desc) " {{{
    return substitute(a:desc, '\v\{([^}]+)\}', '\=eval(submatch(1))', 'g')
endfunction " }}}
