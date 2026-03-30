""
" @file Set font size.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"-------------------------------------------------------------------------------
" GUI Font (console & window)
"-------------------------------------------------------------------------------
function! SetFontSize(size)
    let l:fa = printf(':set guifont=Consolas:h%d', a:size)
    let l:fw = printf(':set guifontwide=Microsoft\ Yahei:h%d', a:size)
    execute l:fa
    execute l:fw
    " echom 'Set font size to ' . a:size
endfunction
"
if has('nvim') && has('gui_running')
    call SetFontSize(12)
else
    call SetFontSize(12)
endif

