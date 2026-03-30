""
" @file vim-highlighter settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"---------------------------------------
" azabiong/vim-highlighter
"---------------------------------------
" Turn highlighting on or off using only the HiSet key.
let HiSetToggle = 1
" The directory to store highlight (*.hl) files.
let HiKeywords = g:vimrc_path . '/hl'
" Jump forward/backward highlights of the same pattern
nnoremap gj <Cmd>Hi><CR>
nnoremap gk <Cmd>Hi<<CR>
" Jump forward/backward the nearest highlights
nnoremap gl <Cmd>Hi}<CR>
nnoremap gh <Cmd>Hi{<CR>

