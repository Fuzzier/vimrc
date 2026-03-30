""
" @file Reduce/increase window width by several columns.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"-------------------------------------------------------------------------------
" Reduce/increase window width by 10 columns.
"-------------------------------------------------------------------------------
function! AdjustWinWidth(n)
    if a:n >= 0
        let cmd = ":vertical resize +" . a:n
    else
        let cmd = ":vertical resize " . a:n
    endif
    exec cmd
    call repeat#set(":call AdjustWinWidth(" . a:n . ")\<CR>")
endfunction

nnoremap <C-w><C-d> :call AdjustWinWidth(-10)<CR>
nnoremap <C-w><C-a> :call AdjustWinWidth(10)<CR>

