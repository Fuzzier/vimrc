""
" @file vim-easy-align settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"---------------------------------------
" junegunn/vim-easy-align
"---------------------------------------
" Set hotkeys.
nmap <silent> ga <Plug>(EasyAlign)
xmap <silent> ga <Plug>(EasyAlign)

" '/': Align C++-style comment.
" 'c': Align backslash (line continuity).
" '=': Align =, +, -, *, /, &, |, ^
let binary_ops = [
    \ '&=', '|=', '\^=',
    \ '==', '!=', '<=', '>=',
    \ '+=', '-=', '\*=', '\/=', '%=',
    \ '&&', '||',
    \ '&', '|', '\^',
    \ '=', '!', '<', '[^-]>',
    \ '+', '-[^>]', '\*', '\/', '%',
    \ '?', ':'
    \ ]
let binary_ops_pattern = join(binary_ops, '\|')

let g:easy_align_delimiters = {
    \  '/': { 'pattern'        : '/[/*]\+<\{,1}',
    \         'delimiter_align': 'l',
    \         'ignore_groups'  : [] },
    \
    \  'c': { 'pattern'        : '\\',
    \         'delimiter_align': 'l',
    \         'left_margin'    : ' ' },
    \
    \  'a': { 'pattern'        : binary_ops_pattern,
    \         'delimiter_align': 'r',
    \         'left_margin'    : ' ' }
    \ }

unlet binary_ops
unlet binary_ops_pattern

