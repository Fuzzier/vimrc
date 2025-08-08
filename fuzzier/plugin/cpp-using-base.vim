vim9script

#===============================================================================
# @file
#
# @brief Declare type alias for base type.
#
# @author Wei Tang <gauchyler@uestc.edu.cn>
# @date 2025-08-08
#
# For test purpose.
#===============================================================================

def CppUsingBase()
    var line_num = line('.')
    var line = getline(line_num)
    var last_line_num = line('$')
    if line =~# 'class\|struct'
        # Search downward for ': public Xxx'
        while line_num <= last_line_num
            line = getline(line_num)
            if line =~ ':\s*[^:]\+'
                break
            else
                line_num += 1
            endif
        endwhile
    else
        # Search upward for ': public Xxx'
        while line_num > 0
            line = getline(line_num)
            if line =~ ':\s*[^:]\+'
                break
            else
                line_num -= 1
            endif
        endwhile
    endif
    # echo line_num
    if line_num > 0
        var pat = ':\s*\(public\|protected\|private\)\?\s*\zs.*\ze'
        var base_type = matchstr(line, pat)
        # echo base_type
        # Search downward for '{'
        while line_num < last_line_num
            if line =~ '{'
                break
            else
                line_num += 1
                line = getline(line_num)
            endif
        endwhile
        if line_num <= last_line_num
            line = 'using Base = ' .. base_type .. ';'
            append(line_num, line)
            setpos('.', [0, line_num + 1, 1, 0])
            normal! ==
            append(line_num + 1, '')
        endif
    endif
    repeat#set("\<Plug>(CppUsingBase)")
enddef

nnoremap <silent> <Plug>(CppUsingBase) :<C-U>call <SID>CppUsingBase()<CR>
nnoremap <silent> <Leader>ub <Plug>(CppUsingBase)

