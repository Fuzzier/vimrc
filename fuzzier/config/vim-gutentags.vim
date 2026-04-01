""
" @file vim-gutentags settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"---------------------------------------
" ludovicchabant/vim-gutentags
"---------------------------------------
let g:gutentags_enabled = 1
"
" Set the cache directory for tags.
" NOTE: In `LeaderF.vim`, `g:Lf_CacheDirectory` is set to `g:vimrc_path`.
"       Thus, `gutentags` shall generate tags in the following subdirectory
"       for `LeaderF`.
let g:gutentags_cache_dir = expand(g:vimrc_path . '/LeaderF/gtags')
"
let g:gutentags_ctags_extra_args = [
    \ '-I BOOST_NOEXCEPT,BOOST_CONSTEXPR'
    \ ]
"
let g:gutentags_ctags_exclude = [
    \ '.ccls-cache', '.vs', '.svn', '.git', '.hg', 'bak', 'undo'
    \ ]
"
if has('win32')
    let g:gutentags_ctags_executable = g:vimrc_path . '/ctags/uctags.exe'
endif
"
let g:gutentags_ctags_extra_args = [
    \ '--extra=+q',
    \ '--fields=+ainSz',
    \ '--c-kinds=+px',
    \ '--c++-kinds=+px'
    \ ]
"
let g:gutentags_exclude_filetypes = [
    \ 'vim',
    \ 'snippets',
    \ 'leaderf',
    \ 'fugitive',
    \ 'gitcommit'
    \ ]

