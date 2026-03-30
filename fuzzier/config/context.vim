""
" @file context.vim settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"---------------------------------------
" wellle/context.vim
"---------------------------------------
let g:context_enabled = 1
let g:context_max_height = 5
let g:context_max_join_parts = 5
let g:context_add_autocmds = 1
let g:context_extend_regex = '^\s*\([]{})]\|end\|else\|case\>\|default\>\|public\s*:\|private\s*:\|protected\s*:\)'
let g:context_skip_regex = '^\s*\($\|#\|//\|/\*\|\*\($\|/s\|\/\)\|public\s*:\|private\s*:\|protected\s*:\)'
let g:context_filetype_blacklist = [ 'leaderf' ]
let g:context_buftype_blacklist  = [ 'nofile' ]

