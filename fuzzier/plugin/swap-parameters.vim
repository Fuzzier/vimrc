vim9script

#===============================================================================
# @file
#
# @brief Swap parameters around comma.
#
# @author Wei Tang <gauchyler@uestc.edu.cn>
# @date 2025-08-08
#===============================================================================

# Find the next ')', '>', ']' or ',' from `col`, inclusive.
def FindNextDelim(line: string, col: number): list<number>
    # Find the pattern
    var delim = ')\|-\@<!>\|\]\|,'
    var index = match(line, delim, col - 1)
    echo line[col - 1 :]
    var is_comma = 0
    var char: string
    if index != -1
        char = line[index]
        if char =~ ','
            is_comma = 1
        endif
    endif
    return [index, is_comma]
enddef

def FindNextDelimEx(line_num_: number, col: number, extra_num_lines: number): list<number>
    var line_num = line_num_
    var line = getline(line_num)
    var result = FindNextDelim(line, col)
    # Look for additional lines if not found
    var line_num_cap = line_num + extra_num_lines
    var last_line_num = line('$')
    if line_num_cap > last_line_num
        line_num_cap = last_line_num
    endif
    var index = result[0]
    while index == -1 && line_num < line_num_cap
        line_num += 1
        line = getline(line_num)
        result = FindNextDelim(line, 1)
        index = result[0]
    endwhile
    return result + [line_num]
enddef

# Find the previous '(', '<' or ',' from `col`, inclusive.
def FindPrevDelim(line: string, col_: number): list<number>
    var col = col_
    if col == -1
        col = strlen(line)
    endif
    var delim = '(\|<\|\[\|,'
    # Find the pattern
    var index = -1
    var next = match(line, delim, index + 1)
    while next != -1 && next + 1 <= col
        index = next
        next = match(line, delim, index + 1)
    endwhile
    var is_comma = 0
    var char: string
    if index != -1
        char = line[index]
        if char =~ ','
            is_comma = 1
        endif
    endif
    return [index, is_comma]
enddef

# Find the previous delimiter from `col`, inclusive.
def FindPrevDelimEx(line_num_: number, col: number, extra_num_lines: number): list<number>
    var line_num = line_num_
    var line = getline(line_num)
    var result = FindPrevDelim(line, col)
    # Look for additional lines if not found
    var line_num_cap: number
    if line_num > extra_num_lines
        line_num_cap = line_num - extra_num_lines
    else
        line_num_cap = 1
    endif
    var index = result[0]
    while index == -1 && line_num > line_num_cap
        line_num -= 1
        line = getline(line_num)
        result = FindPrevDelim(line, -1)
        index = result[0]
    endwhile
    return result + [line_num]
enddef

# Find the element from `index`, inclusive.
# For example, the index is the position after ','.
def FindNextElem(line: string, index: number): list<number>
    var len = strlen(line)
    # Skip leading blanks
    var sindex = match(line, '^\s*\zs', index)
    var eindex = sindex
    # Parse element
    var parenth_level = 0
    var chevron_level = 0
    var bracket_level = 0
    var token = line[eindex]
    while eindex < len
        #            \(                \)$
        #              )       >   ]  ,
        if token =~ '\()\|-\@<!>\|\]\|,\)$'
            if parenth_level == 0 && chevron_level == 0 && bracket_level == 0
                break
            else
                token = token[1]
                if token == ')' && parenth_level > 0
                    parenth_level -= 1
                elseif token == '>' && chevron_level > 0
                    chevron_level -= 1
                elseif token == ']' && bracket_level > 0
                    bracket_level -= 1
                endif
            endif
        else
            token = token[1]
            if token == '('
                parenth_level += 1
            elseif token == '<'
                chevron_level += 1
            elseif token == '['
                bracket_level += 1
            endif
        endif
        eindex += 1
        # The token has 2 characters to check operators such as '->'.
        token = line[eindex - 1 : eindex]
    endwhile
    # Skip trailing blanks
    if eindex > sindex
        token = line[sindex : eindex - 1]
        eindex = sindex + match(token, '\zs\s*$')
    endif
    return [sindex, eindex]
enddef

# Find the element before `index`, exclusive.
# For example, the index is the position of ','.
def FindPrevElem(line: string, index: number): list<number>
    var len = strlen(line)
    var eindex = index
    if eindex == -1 || eindex > len
        eindex = len
    endif
    # Skip trailing blanks
    var token: string
    if eindex > 0
        token = line[0 : eindex - 1]
        eindex = match(token, '\zs\s*$')
    endif
    var sindex = eindex
    # Parse element
    var parenth_level = 0
    var chevron_level = 0
    var bracket_level = 0
    while sindex > 0
        token = line[sindex - 1]
        if token =~ '(\|<\|\[\|,'
            if parenth_level == 0 && chevron_level == 0 && bracket_level == 0
                break
            elseif token == '(' && parenth_level > 0
                parenth_level -= 1
            elseif token == '<' && chevron_level > 0
                chevron_level -= 1
            elseif token == '[' && bracket_level > 0
                bracket_level -= 1
            endif
        elseif token == ')'
            parenth_level += 1
        elseif token == '>'
            if sindex > 1 && line[sindex - 2] == '-'
            else
                chevron_level += 1
            endif
        elseif token == ']'
            bracket_level += 1
        endif
        sindex -= 1
    endwhile
    # Skip leading blanks
    if sindex < eindex
        token = line[sindex : eindex - 1]
        sindex += match(token, '^\s*\zs')
    endif
    return [sindex, eindex]
enddef

def SwapParams(line_num: number, index: number, cursor: number)
    # Find lhs
    var lhs_line_num = line_num
    var lhs_line = getline(lhs_line_num)
    var lhs_pos = FindPrevElem(lhs_line, index)
    var s0 = lhs_pos[0]
    var e0 = lhs_pos[1]
    # If not found, try previous line
    if s0 >= e0
        lhs_line_num -= 1
        lhs_line = getline(lhs_line_num)
        lhs_pos = FindPrevElem(lhs_line, -1)
        s0 = lhs_pos[0]
        e0 = lhs_pos[1]
    endif
    var lhs = lhs_line[s0 : e0 - 1]
    # echo lhs
    # Find rhs
    var rhs_line_num = line_num
    var rhs_line = getline(rhs_line_num)
    var rhs_pos = FindNextElem(rhs_line, index + 1)
    var s1 = rhs_pos[0]
    var e1 = rhs_pos[1]
    # If not found, try next line
    if s1 >= e1
        rhs_line_num += 1
        rhs_line = getline(rhs_line_num)
        rhs_pos = FindNextElem(rhs_line, 0)
        s1 = rhs_pos[0]
        e1 = rhs_pos[1]
    endif
    var rhs = rhs_line[s1 : e1 - 1]
    # echo rhs
    # Swap lhs and rhs
    var line: string
    if lhs_line_num == rhs_line_num
        line  = lhs_line[0 : s0 - 1]
        line ..= rhs
        line ..= lhs_line[e0 : s1 - 1]
        # The column of the new rhs
        var rhs_col = strlen(line) + 1
        line ..= lhs
        line ..= lhs_line[e1 : ]
        # echo line
        setline(lhs_line_num, line)
        if cursor == 1
            setpos('.', [0, lhs_line_num, rhs_col, 0])
        else
            setpos('.', [0, lhs_line_num, s0 + 1, 0])
        endif
    else
        line  = lhs_line[0 : s0 - 1]
        line ..= rhs
        line ..= lhs_line[e0 : ]
        # echo line
        setline(lhs_line_num, line)
        line  = rhs_line[0 : s1 - 1]
        line ..= lhs
        line ..= rhs_line[e1 : ]
        # echo line
        setline(rhs_line_num, line)
        if cursor == 1
            setpos('.', [0, rhs_line_num, s1 + 1, 0])
        else
            setpos('.', [0, lhs_line_num, s0 + 1, 0])
        endif
    endif
enddef

def MoveParamToRight()
    var pos = getpos('.')
    var line_num = pos[1]
    var col = pos[2]
    var num_lines = 1
    var delim_pos = FindNextDelimEx(line_num, col, 1)
    var is_comma = delim_pos[1]
    if is_comma
        var index = delim_pos[0]
        line_num = delim_pos[2]
        SwapParams(line_num, index, 1)
    endif
    repeat#set("\<Plug>(MoveParamToRight)")
enddef

def MoveParamToLeft()
    var pos = getpos('.')
    var line_num = pos[1]
    var col = pos[2]
    var num_lines = 1
    var delim_pos = FindPrevDelimEx(line_num, col, 1)
    var is_comma = delim_pos[1]
    if is_comma
        var index = delim_pos[0]
        line_num = delim_pos[2]
        SwapParams(line_num, index, 0)
    endif
    repeat#set("\<Plug>(MoveParamToLeft)")
enddef

nnoremap <silent> <Plug>(MoveParamToRight) :<C-U>call <SID>MoveParamToRight()<CR>
nnoremap <silent> <Plug>(MoveParamToLeft)  :<C-U>call <SID>MoveParamToLeft()<CR>

nnoremap <silent> g> <Plug>(MoveParamToRight)
nnoremap <silent> g< <Plug>(MoveParamToLeft)

