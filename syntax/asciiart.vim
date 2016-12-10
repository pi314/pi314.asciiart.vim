syn match color_start _\v\[(1;)?(3\d)?(4\d)?m_ conceal

syn match blk_text      _\v(\[1;30m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_
syn match r_text        _\v(\[1;31m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_
syn match g_text        _\v(\[1;32m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_
syn match y_text        _\v(\[1;33m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_
syn match b_text        _\v(\[1;34m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_
syn match m_text        _\v(\[1;35m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_
syn match c_text        _\v(\[1;36m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_
syn match w_text        _\v(\[1;37m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_
syn match dim_blk_text  _\v(\[30m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_
syn match dim_r_text    _\v(\[31m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_
syn match dim_g_text    _\v(\[32m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_
syn match dim_y_text    _\v(\[33m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_
syn match dim_b_text    _\v(\[34m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_
syn match dim_m_text    _\v(\[35m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_
syn match dim_c_text    _\v(\[36m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_
syn match dim_w_text    _\v(\[37m)@<=([^]*)(\[(1;)?(3\d)?(4\d)?m|$)@=_

highlight def blk_text      ctermfg=darkgray
highlight def r_text        ctermfg=red
highlight def g_text        ctermfg=green
highlight def y_text        ctermfg=yellow
highlight def b_text        ctermfg=blue
highlight def m_text        ctermfg=magenta
highlight def c_text        ctermfg=cyan
highlight def w_text        ctermfg=white
highlight def dim_blk_text  ctermfg=black
highlight def dim_r_text    ctermfg=darkred
highlight def dim_g_text    ctermfg=darkgreen
highlight def dim_y_text    ctermfg=darkyellow
highlight def dim_b_text    ctermfg=darkblue
highlight def dim_m_text    ctermfg=darkmagenta
highlight def dim_c_text    ctermfg=darkcyan
highlight def dim_w_text    ctermfg=gray
