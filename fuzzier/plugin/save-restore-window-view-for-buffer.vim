""
" @file Save and restore window view for buffer.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"--------------------------------------------------------------------------------
" Save and restore window view for buffer
"--------------------------------------------------------------------------------
" XBufWin can be disabled.
if !exists('g:xbufwin_off')
    let g:xbufwin_off = 0
endif
"
function! XBufWinRestView()
    if g:xbufwin_off | return | endif
    if &diff | return | endif " Do not interfere with synchronous diff view
    let l:buf = bufnr()
    let l:win = win_getid()
    if exists('b:xbufwin_view')
        if has_key(b:xbufwin_view, l:win)
            let l:view = b:xbufwin_view[l:win]
            call winrestview(l:view) " Restore window view
        elseif has_key(b:xbufwin_view, 'last')
            let l:view = b:xbufwin_view['last']
            call winrestview(l:view) " Restore window view for new window
        endif
    endif
endfunction

function! XBufWinSaveView()
    if g:xbufwin_off | return | endif
    if &diff | return | endif " Do not interfere with synchronous diff view
    let l:win = win_getid()
    let l:view = winsaveview()
    if exists('b:xbufwin_view')
        let b:xbufwin_view[l:win] = l:view " Save window view
    else
        let b:xbufwin_view = { l:win : l:view } " Save window view
    endif
    let b:xbufwin_view['last'] = l:view " Save window view for new window
    "
    let l:keys = keys(b:xbufwin_view)
    for l:win in l:keys
        if l:win =~# 'last' || l:win =~# l:win
            continue
        endif
        if winbufnr(l:win) == -1 " Window does not exist
            unlet b:xbufwin_view[l:win]
        endif
    endfor
endfunction

augroup XBufWin
  autocmd!
  autocmd BufEnter * :call XBufWinRestView()
  autocmd WinScrolled,WinLeave,BufLeave * :call XBufWinSaveView()
augroup END

