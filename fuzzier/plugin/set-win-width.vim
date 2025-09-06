vim9script

#===============================================================================
# @file
#
# @brief Automatically adjust window width.
#
# @author Wei Tang <gauchyler@uestc.edu.cn>
# @date 2025-08-08
#===============================================================================

# The previous window id
g:set_win_width_prev_wid = 0
g:set_win_width_prev_wid_time = 0

def CalcTotalWidth(node: list<any>): number
    var total_width: number = 0
    var id: number
    if node[0] ==# 'leaf'
        id = node[1]
        total_width += winwidth(win_id2win(id))
    elseif node[0] ==# 'col'
        var ch = node[1]
        total_width += CalcTotalWidth(ch[0])
    elseif node[0] ==# 'row'
        for ch in node[1]
            total_width += CalcTotalWidth(ch)
        endfor
    endif
    return total_width
enddef

def ContainsWin(node: list<any>, id: number): bool
    var succ: bool
    if node[0] ==# 'leaf'
        succ = (node[1] == id)
    else
        for ch in node[1]
            succ = ContainsWin(ch, id)
            if succ | break | endif
        endfor
    endif
    return succ
enddef

def VerticalResizeWindow(id: number, width: number)
    var cmd = printf('vertical resize %d', width)
    win_execute(id, cmd)
enddef

def DelayedVerticalResizeWindow(timer: number, id: number, width: number)
    VerticalResizeWindow(id, width)
enddef

def SetWinWidthForRow(node: list<any>, id: number, total_width: number): bool
    # assert_true(node[0] ==# 'row')
    const num_sibls = len(node[1]) - 1
    # The target window shall have a minimum width of 88 columns,
    # while sibling windows shall have a minimum width of 8 columns.
    var ok = (total_width >= (88 + num_sibls * 8))
    # If there are no sibling windows, there is no need to adjust.
    if ok && (num_sibls > 0)
        ok = v:false
        for ch in node[1]
            if ch[0] ==# 'leaf'
                if ch[1] == id
                    ok = v:true
                endif
            elseif ch[0] ==# 'col'
                for gc in ch[1]
                    if gc[0] ==# 'leaf'
                        if gc[1] == id
                            ok = v:true
                        endif
                    elseif gc[0] ==# 'row'
                        # Do not search for target window in `gc[1]` row,
                        # since the layout is too complex to adjust.
                    endif
                endfor
            endif
        endfor
    endif
    if ok
        # If `total_width` allows all windows to have at least 88 columns,
        # then divide `total_width` equally.
        # Otherwise, let target window have 88 columns, and sibling windows
        # divide the remaining width equally.
        const sibl_width = (total_width >= 88 + num_sibls * 88)
                         ? float2nr(floor(total_width / (num_sibls + 1)))
                         : float2nr(floor((total_width - 88) / num_sibls))
        const main_width = total_width - num_sibls * sibl_width
        var count = 0
        var wid: number
        var cmd: string
        for ch in node[1]
            wid = 0
            if ch[0] ==# 'leaf'
                wid = ch[1]
            elseif ch[0] ==# 'col'
                for gc in ch[1]
                    if gc[0] ==# 'leaf'
                        wid = gc[1]
                        if wid == id | break | endif
                    endif
                endfor
            endif
            if wid == id
                var width = winwidth(win_id2win(id))
                # Adjust active window width if its width is not `main_width`.
                if width != main_width
                    # If there are only 2 windows in a row, then timer is not
                    # used to avoid visual inconvenience.
                    if num_sibls == 1
                        VerticalResizeWindow(id, main_width)
                    # Timer is used to force the `context` plugin to adjust
                    # its width in the sibling window accordingly.
                    else
                        VerticalResizeWindow(id, main_width - 1)
                        timer_start(0, (timer) =>
                            DelayedVerticalResizeWindow(timer, id, main_width))
                    endif
                endif
                count += 1
            elseif wid != 0
                VerticalResizeWindow(wid, sibl_width)
                count += 1
            endif
            # Do not adjust the width of the last window in the row.
            if count == num_sibls
                break
            endif
        endfor
    endif
    return ok
enddef

def SetWinWidthForCol(node: list<any>, id: number, total_width: number)
    assert_true(node[0] ==# 'col')
    for ch in node[1]
        if ch[0] ==# 'leaf'
            if ch[1] == id
                break
            endif
        elseif ch[0] ==# 'row'
            if SetWinWidthForRow(ch, id, total_width)
                break
            endif
        endif
    endfor
enddef

def SetWinWidth()
    var node = winlayout()
    var id = win_getid()
    if g:set_win_width_prev_wid != id
        g:set_win_width_prev_wid = id
        g:set_win_width_prev_wid_time = 0
    else
        g:set_win_width_prev_wid_time += 1
    endif
    if g:set_win_width_prev_wid_time == 0
        var total_width = CalcTotalWidth(node)
        if node[0] ==# 'leaf'
            # No need to resize the only window.
        elseif node[0] ==# 'col'
            SetWinWidthForCol(node, id, total_width)
        elseif node[0] ==# 'row'
            SetWinWidthForRow(node, id, total_width)
        endif
    endif
enddef

nnoremap <silent> <Plug>(SetWinWidth)  :<C-U>call <SID>SetWinWidth()<CR>
nnoremap <silent> <Leader><Leader>w  <Plug>(SetWinWidth)

autocmd WinEnter * execute "normal! \<Plug>(SetWinWidth)"

