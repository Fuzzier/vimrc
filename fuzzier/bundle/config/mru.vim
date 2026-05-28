""
" @file mru.vim settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"---------------------------------------
" vim-scripts/mru.vim
"---------------------------------------
" Remove :MANPAGER.
" :M<Tab> expands directly to :MRU
if !has('nvim')
    autocmd VimEnter * if exists(":MANPAGER") | delcommand MANPAGER | endif
endif

