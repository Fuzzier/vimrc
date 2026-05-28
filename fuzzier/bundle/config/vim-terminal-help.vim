""
" @file vim-terminal-help settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"---------------------------------------
" skywind3000/vim-terminal-help
"---------------------------------------
" Disable default mappings.
" * 'termwinkey' remains unchanged.
let g:terminal_default_mapping = 0
" The key to toggle terminal window.
let g:terminal_key = '<Leader>to'
" Initialize working dir: 0 for unchanged, 1 for file path and 2 for project root.
let g:terminal_cwd = 2
" Set to 'term' to kill term session when exiting vim.
let g:terminal_kill = 'term'
" Set to 1 to close window if process finished.
let g:terminal_close = 1

