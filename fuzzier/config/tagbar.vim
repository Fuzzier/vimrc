""
" @file tagbar settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"---------------------------------------
" preservim/tagbar
"---------------------------------------
" Set hotkey to toggle taglist window
nnoremap <silent> <F11>  :TagbarToggle<CR>
"
if has('win32')
    let g:tagbar_ctags_bin = g:vimrc_path . '/ctags/uctags.exe'
endif
"
let g:tagbar_autofocus = 1
"
let g:tagbar_autoclose = 1
"
" Do not echo tag information in status line.
let g:tagbar_silent = 0
"
" Do not sort by name.
let g:tagbar_sort = 0
" Show absolute line numbers.
let g:tagbar_show_linenumbers = 1
"
" let g:tagbar_iconchars = ['+', '-']
"
" Do no generate tags upon file save.
let g:tagbar_no_autocmds = 1
"
" Prevent tagbar from using python to launch 'ctags'.
" There is a bug that the launching will fail with error code `129`.
" Fallback to call `system()` to launch 'ctags'.
let g:tagbar_python = 0
"
" let g:tagbar_type_cpp = {
"     \ 'ctagsargs' : [
"     \ '--extra=+f',
"     \ '-f', '-',
"     \ '--format=2',
"     \ '--excmd=pattern',
"     \ '--fields=nksSafet',
"     \ '--sort=no',
"     \ '--append=no',
"     \ '-V',
"     \ '--language-force=c++',
"     \ '--c++-kinds=hdpgetncsufmv',
"     \ '--file-scope=yes',
"     \ '-I', 'BOOST_NOEXCEPT,BOOST_CONSTEXPR,NSFX_OVERRIDE,NSFX_FINAL'
"     \ ]}
"
nnoremap <silent> <Leader>tg  :Tagbar<CR>

