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

def VerticalResizeWindow(id: number, width: number)
    var cmd = printf('vertical resize %d', width)
    win_execute(id, cmd)
enddef

def DelayedVerticalResizeWindow(timer: number, id: number, width: number)
    VerticalResizeWindow(id, width)
enddef

class LayoutParser
    # The main window, which is the window that is entered.
    var main_id: number
    var id_list: list<number>
    var main_id_pos: number
    var width_list: list<number>
    var total_width: number
    var too_complex: bool

    def new(this.main_id)
    enddef

    def _AddId(id: number)
        this.id_list->add(id)
        if id == this.main_id
            this.main_id_pos = this.id_list->len()
        endif
        var width = winwidth(win_id2win(id))
        this.width_list->add(width)
        this.total_width += width
    enddef

    def Parse(node: list<any>, depth: number)
        if node[0] ==# 'leaf'
            this._AddId(node[1])
        elseif node[0] ==# 'row'
            this._ParseRow(node[1], depth)
        elseif node[0] ==# 'col'
            this._ParseCol(node[1], depth)
        endif
    enddef

    def _ParseCol(node: list<any>, depth: number)
        assert_true(this.main_id_pos == 0)
        var count = node->len()
        var i = 0
        for row in node
            i += 1
            if row[0] ==# 'leaf'
                if i == count || row[1] == this.main_id
                    this._AddId(row[1])
                    break
                endif
            elseif depth < 1
                var parser = LayoutParser.new(this.main_id)
                parser._ParseRow(row[1], depth)
                if i == count || parser.main_id_pos != 0
                    if parser.too_complex
                        this.too_complex = v:true
                        return
                    endif
                    this.main_id_pos = this.id_list->len() + parser.main_id_pos
                    this.id_list->extend(parser.id_list)
                    this.width_list->extend(parser.width_list)
                    this.total_width += parser.total_width
                    break
                endif
            else
                this.too_complex = v:true
                break
            endif
        endfor
    enddef

    def _ParseRow(node: list<any>, depth: number)
        for col in node
            if col[0] ==# 'leaf'
                this._AddId(col[1])
            elseif depth < 1
                this._ParseCol(col[1], depth + 1)
            else
                this.too_complex = v:true
                break
            endif
        endfor
    enddef

    def AdjustWidth()
        const num_sibls = this.id_list->len() - 1
        # If there are no sibling windows, there is no need to adjust.
        if num_sibls < 1 | return | endif
        # The target window shall have a minimum width of 88 columns,
        # while sibling windows shall have a minimum width of 8 columns.
        if this.total_width < (88 + num_sibls * 8) | return | endif
        # If `total_width` allows all windows to have at least 88 columns,
        # then divide `total_width` equally.
        # Otherwise, let target window have 88 columns, and sibling windows
        # divide the remaining width equally.
        const sibl_width = (this.total_width >= 88 + num_sibls * 88)
                         ? float2nr(floor(this.total_width / (num_sibls + 1)))
                         : float2nr(floor((this.total_width - 88) / num_sibls))
        const main_width = this.total_width - num_sibls * sibl_width
        # If there are only 2 windows in a row, then timer is not
        # used to avoid visual inconvenience.
        if num_sibls == 1
            VerticalResizeWindow(this.id_list[0], main_width)
            return
        endif
        var i = 0
        for id in this.id_list
            if id != this.main_id
                VerticalResizeWindow(id, sibl_width)
            else
                VerticalResizeWindow(id, main_width - 1)
                timer_start(0, (timer) => DelayedVerticalResizeWindow(
                    timer, this.main_id, main_width))
            endif
            # Do not adjust the width of the last/right-most in a row.
            i += 1
            if i == num_sibls | break | endif
        endfor
    enddef

endclass

# defcompile LayoutParser

def SetWinWidth()
    var id = win_getid()
    if g:set_win_width_prev_wid != id
        g:set_win_width_prev_wid = id
        g:set_win_width_prev_wid_time = 0
    else
        g:set_win_width_prev_wid_time += 1
    endif
    if g:set_win_width_prev_wid_time == 0
        var node = winlayout()
        var layout = LayoutParser.new(id)
        layout.Parse(node, 0)
        if !layout.too_complex
            layout.AdjustWidth()
        endif
    endif
enddef

nnoremap <silent> <Plug>(SetWinWidth)  :<C-U>call <SID>SetWinWidth()<CR>
nnoremap <silent> <Leader><Leader>w  <Plug>(SetWinWidth)

autocmd WinEnter * execute "normal! \<Plug>(SetWinWidth)"

