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
const bin_op_list = [
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
        const pat_lead_sp = '\(\s*\)'
        # anything before the operator
        const pat_lhs = '\(.\{-}\)'
        # the operator, surrounded by spaces
        const pat_op = '\(\s\+' .. bin_op .. '\s\+\)'
        # anything after the operator, and before ';'
        const pat_rhs = '\([^;]*\)'
        # possible trailing ';'
        const pat_colon = '\s*\(;\?\)'
        const pattern = pat_lead_sp
                     .. pat_lhs
                     .. pat_op
                     .. pat_rhs
                     .. pat_colon
        const matches = matchlist(text, pattern)
        if !empty(matches)
            # echo matches
            const sp  = matches[1]
            const lhs = matches[2]
            var op  = matches[3]
            const lt = (op =~# '<')
            const gt = (op =~# '>')
            if lt && !gt
                op = substitute(op, '<', '>', 'g')
            elseif gt && !lt
                op = substitute(op, '>', '<', 'g')
            endif
            const rhs   = matches[4]
            const colon = matches[5]
            const swapped = sp .. rhs .. op .. lhs .. colon
            return swapped
        endif
    endfor
    return ''
enddef

def SwapOperandsRange0(line_num: number)
    const line = getline(line_num)
    const swapped = SwapOperandsString(line)
    if !empty(swapped)
        setline(line_num, swapped)
    endif
enddef

def SwapOperandsRange1(line_num: number, beg_col: number)
    const line = getline(line_num)
    const text = strcharpart(line, beg_col - 1)
    const swapped = SwapOperandsString(text)
    if !empty(swapped)
        const head = strcharpart(line, 0, beg_col - 1)
        const join = head .. swapped
        setline(line_num, join)
    endif
enddef

def SwapOperandsRange2(line_num: number, beg_col: number, end_col: number)
    const line = getline(line_num)
    const text = strcharpart(line, beg_col - 1, end_col - beg_col + 1)
    const swapped = SwapOperandsString(text)
    if !empty(swapped)
        const head = strcharpart(line, 0, beg_col - 1)
        const tail = strcharpart(line, end_col)
        const join = head .. swapped .. tail
        setline(line_num, join)
    endif
enddef

def SwapOperandsLine()
    const pos = getpos('.')
    const line_num = pos[1]
    const line = getline(line_num)
    const swapped = SwapOperandsString(line)
    if !empty(swapped)
        setline(line_num, swapped)
    endif
    repeat#set("\<Plug>(SwapOperandsLine)")
enddef

def SwapOperandsVisual()
    const beg_pos = getpos("'<")
    const end_pos = getpos("'>")
    const beg_line_num = beg_pos[1]
    const beg_col      = beg_pos[2]
    const end_line_num = end_pos[1]
    const end_col      = end_pos[2]
    const mode = visualmode()
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
        # echo beg_pos
        # echo end_pos
        for line_num in range(beg_line_num, end_line_num)
            SwapOperandsRange2(line_num, beg_col, end_col)
        endfor
    endif
enddef

nnoremap <silent> <Plug>(SwapOperandsLine)    :<C-U>call <SID>SwapOperandsLine()<CR>
vnoremap <silent> <Plug>(SwapOperandsVisual)  :<C-U>call <SID>SwapOperandsVisual()<CR>
nnoremap <silent> <Leader>ss  <Plug>(SwapOperandsLine)
vnoremap <silent> <Leader>ss  <Plug>(SwapOperandsVisual)

