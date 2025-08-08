vim9script

#===============================================================================
# @file
#
# @brief Swap operands around binary operator.
#
# @author Wei Tang <gauchyler@uestc.edu.cn>
# @date 2025-08-08
#===============================================================================

# Supported binary operators
var bin_op_list = [
    '=',
    '+', '-', '\*', '\/', '%',
    '+=', '-=', '\*=', '\/=', '%=',
    '==', '!=',
    '===', '<=>',
    '<', '>', '<=', '>=',
    '>>', '<<', '<<=', '>>=',
    '&', '|', '\^',
    '&=', '|=', '\^=',
    '&&', '||',
]

def SwapOperandsString(text: string): string
    for bin_op in bin_op_list
        # zero or more spaces
        var pat_lead_sp = '\(\s*\)'
        # anything before the operator
        var pat_lhs = '\(.\{-}\)'
        # the operator, surrounded by spaces
        var pat_op = '\(\s\+' .. bin_op .. '\s\+\)'
        # anything after the operator, and before ';'
        var pat_rhs = '\([^;]*\)'
        # possible trailing ';'
        var pat_colon = '\s*\(;\?\)'
        var pattern = pat_lead_sp
                   .. pat_lhs
                   .. pat_op
                   .. pat_rhs
                   .. pat_colon
        var matches = matchlist(text, pattern)
        if !empty(matches)
            # echom matches
            var sp    = matches[1]
            var lhs   = matches[2]
            var op    = matches[3]
            var rhs   = matches[4]
            var colon = matches[5]
            var swapped = sp .. rhs .. op .. lhs .. colon
            return swapped
        endif
    endfor
    return ''
enddef

def SwapOperandsRange0(line_num: number)
    var line = getline(line_num)
    var swapped = SwapOperandsString(line)
    if !empty(swapped)
        setline(line_num, swapped)
    endif
enddef

def SwapOperandsRange1(line_num: number, beg_col: number)
    var line = getline(line_num)
    var text = strcharpart(line, beg_col - 1)
    var swapped = SwapOperandsString(text)
    if !empty(swapped)
        var head = strcharpart(line, 0, beg_col - 1)
        var join = head .. swapped
        setline(line_num, join)
    endif
enddef

def SwapOperandsRange2(line_num: number, beg_col: number, end_col: number)
    var line = getline(line_num)
    var text = strcharpart(line, beg_col - 1, end_col - beg_col + 1)
    var swapped = SwapOperandsString(text)
    if !empty(swapped)
        var head = strcharpart(line, 0, beg_col - 1)
        var tail = strcharpart(line, end_col)
        var join = head .. swapped .. tail
        setline(line_num, join)
    endif
enddef

def SwapOperandsLine()
    var pos = getpos('.')
    var line_num = pos[1]
    var line = getline(line_num)
    var swapped = SwapOperandsString(line)
    if !empty(swapped)
        setline(line_num, swapped)
    endif
    repeat#set(":call SwapOperandsLine()\<CR>")
enddef

def SwapOperandsVisual()
    var beg_pos = getpos("'<")
    var end_pos = getpos("'>")
    var beg_line_num = beg_pos[1]
    var beg_col      = beg_pos[2]
    var end_line_num = end_pos[1]
    var end_col      = end_pos[2]
    var mode = visualmode()
    # For each line.
    if mode == 'v' || mode == 'V'
        if beg_line_num == end_line_num
            SwapOperandsRange2(beg_line_num, beg_col, end_col)
        else
            for line_num in range(beg_line_num, end_line_num)
                if line_num == beg_line_num
                    SwapOperandsRange1(line_num, beg_col)
                elseif line_num == end_line_num
                    SwapOperandsRange2(line_num, 1, end_col)
                else
                    SwapOperandsRange0(line_num)
                endif
            endfor
        endif
    else # mode == '<CTRL-V>'
        echom beg_pos
        echom end_pos
        for line_num in range(beg_line_num, end_line_num)
            SwapOperandsRange2(line_num, beg_col, end_col)
        endfor
    endif
enddef

nnoremap <Leader>ss  :<C-U>call <SID>SwapOperandsLine()<CR>
vnoremap <Leader>ss  :<C-U>call <SID>SwapOperandsVisual()<CR>

