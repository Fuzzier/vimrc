""
" @file tcomment_vim settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"---------------------------------------
" tomtom/tcomment_vim
"---------------------------------------
" Disable default maps.
let g:tcomment_maps = 0
" let g:tcomment_mapleader1 = ''
" let g:tcomment_mapleader2 = ''
" let g:tcomment_opleader1 = ''
" let g:tcomment_mapleader_uncomment_anyway = ''
" let g:tcomment_mapleader_comment_anyway = ''
"
" Toggle comment via motion.
nmap <silent> gc  <Plug>TComment_gc
xmap <silent> gc  <Plug>TComment_gc
" Toggle comment for current line.
nmap <silent> gcc <Plug>TComment_gcc

