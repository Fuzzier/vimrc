""
" @file Swap buffers between windows.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"-------------------------------------------------------------------------------
" Swap buffers between windows.
"-------------------------------------------------------------------------------
function! WinBufSwap(dir)
    " Disable XBufWin temporarily
    let g:xbufwin_off = 1
    " This window
    let thiswin  = winnr()
    let thisbuf  = winbufnr(thiswin)
    let thisview = winsaveview()
    " Next window
    let nextwin  = winnr(a:dir)
    let nextbuf  = winbufnr(nextwin)
    " Move to next window
    exec nextwin . ' wincmd w'
    let nextview = winsaveview()
    " 1. Change buffer in next window
    " 2. Restore view in next window
    " 3. Move back to this window
    " 4. Change buffer in this window
    " 5. Restore view in this window
    " 6. Move to next window
    let cmd =
        \ 'buffer ' .   thisbuf   . '|' .
        \ 'call winrestview(' .   string(thisview) . ')|' .
        \ thiswin   . ' wincmd w' . '|' .
        \ 'buffer ' .   nextbuf   . '|' .
        \ 'call winrestview(' .   string(nextview) . ')|' .
        \ nextwin   . ' wincmd w'
    " Swap buffer
    exec cmd
    let g:xbufwin_off = 0
    call repeat#set(":call WinBufSwap('" . a:dir ."')\<CR>")
endfunction
"
command! WL :call WinBufSwap('l')
command! WH :call WinBufSwap('h')
command! WJ :call WinBufSwap('j')
command! WK :call WinBufSwap('k')

