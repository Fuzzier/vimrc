""
" @file C++ code alignment.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-04-13
"

" Find the matching close delimiter on the same line.
function! s:CppFindMatchingClose(line, pos)
    let open = a:line[a:pos]
    if open == '('
        let close = ')'
    elseif open == '['
        let close = ']'
    elseif open == '{'
        let close = '}'
    elseif open == '<'
        let close = '>'
    else
        return ['', -1]
    endif
    let depth = 0
    let index = a:pos + 1
    while index < len(a:line)
        let ch = a:line[index]
        if ch == open
            let depth += 1
        elseif ch == close
            if depth == 0
                return [close, index]
            endif
            let depth -= 1
        endif
        let index += 1
    endwhile
    return ['', -1]
endfunction

" Find the matching closing double-quote on the same line.
function! s:CppFindMatchingDoubleQuote(line, pos)
    let delim = a:line[a:pos]
    if delim != '"'
        return -1
    endif
    let index = a:pos + 1
    let pch = ' '
    while index < len(a:line)
        let ch = a:line[index]
        " Skip escape character.
        " - If the previous character `pch` is '\', then ignore `ch`.
        if pch == '\'
            let pch = ' '
        elseif ch == delim
            return index
        else
            let pch = ch
        endif
        let index += 1
    endwhile
    return -1
endfunction

function! s:CppAlignAt(line_num, text, indent)
    let sp = repeat(' ', a:indent)
    let str = substitute(a:text, '^\s*', '', '')
    let str = sp . str
    call setline(a:line_num, str)
endfunction

function! s:CppAlignOp(line_num, text, indent)
    let sp = repeat(' ', a:indent)
    let str = substitute(a:text, '^\s*', '', '')
    let str = sp . str
    call setline(a:line_num, str)
endfunction

" NSFX_THROW(LogicError{})("This is an error");
"     ^
" NSFX_THROW(LogicError{})("This is an error"
"     ^                    ^
" NestParen(((sa, da
"     ^       ^
function! CppAlign()
    call repeat#set(":call CppAlign()\<CR>")
    let cline_num = line('.')
    if cline_num <= 1
        return
    endif
    let cline = getline(cline_num)
    if cline =~# '^\s*$'
        return
    endif
    let pline_num = cline_num - 1
    let pline = getline(pline_num)
    if pline =~# '^\s*$'
        return
    endif
    " Strip trailing spaces.
    let pline = substitute(pline, '\s*$', '', '')
    let pline_len = strlen(pline)
    let pline_indent = match(pline, '\S')
    let cline_indent = match(cline, '\S')
    " If cline starts before the first character of pline;
    " OR cline starts after the last character of pline.
    if cline_indent < pline_indent || pline_len <= cline_indent
        call s:CppAlignAt(cline_num, cline, pline_indent)
        return
    endif
    " Try to find an align position that is after and closest to cline_indent.
    let align_pos = pline_len
    " The position of the first non-space character of pline
    let pos = pline_indent
    while v:true
        " Find next:  sp (  [  {  <
        let pat = '\V\s\|(\|[\|{\|<\k\@='
        let [s, pos, end] = matchstrpos(pline, pat, pos)
        if pos == -1 || pos + 1 == pline_len
            " echom 'cannot find delim in pline'
            break
        endif
        " If a space is found.
        if s =~# '\s'
            " Continue search after space.
            let pos += 1
            " Find next:   nsp        (  [  {  <
            let pat = '\V\[^ ([{<]\*\((\|[\|{\|<\k\@=\)'
            let [s, pos, end] = matchstrpos(pline, pat, pos)
            if pos == -1 || pos + 1 == pline_len
                " echom 'cannot find non-delim in pline'
                break
            endif
            " If non-delimiter is found.
            if s !~# '\V\[([{<]'
                " echom 'found non-delim in pline ' .. s .. ' ' .. pos
                " May align with the non-delimiter.
                if cline_indent < pos
                    let align_pos = pos
                    " echom 'may align with non-delim in pline ' .. s .. ' ' .. align_pos
                    break
                endif
            endif
            continue
        endif
        " Otherwise, an opening delimiter is found.
        " echom 'found delim ' .. s .. ' ' .. pos
        let [cch, close_pos] = s:CppFindMatchingClose(pline, pos)
        " If the opening delimiter has no matching close on the same line.
        if close_pos != -1
            " Continue search after the matching close delimiter.
            let pos = close_pos + 1
            " echom 'found closing pair in pline ' .. cch .. ' ' .. close_pos
        else
            " Continue search after the opening delimiter.
            let pos += 1
            " May align with one character after: (, [, {, <
            if cline_indent < pos
                let align_pos = pos
                " echom 'may align after delim in pline ' .. s .. ' ' .. align_pos
                break
            endif
        endif
    endwhile
    " If cline starts with an operator that is followed by a space.
    let ops = [
    \   '.*', '->*', '->',
    \   '++', '--',
    \   '&&', '||',
    \   '<<=', '>>=', '<<', '>>',
    \   '<=>',
    \   '<=', '>=', '==', '!=', '+=', '-=', '*=', '/=', '%=', '&=', '|=', '^=',
    \   '<',  '>',  '=',        '+',  '-',  '*',  '/',  '%',  '&',  '|',  '^',
    \                     '!',  '~',
    \   '::', '.',  ',',  '?',  ':'
    \ ]
    " Search for the first operator (surrounded by space) in pline.
    let pat = '\V\s\(' .. join(ops, '\|') .. '\)\ze\s'
    let [p_op, p_op_pos, p_op_end] = matchstrpos(pline, pat, pline_indent)
    if p_op_pos != -1
        " echom 'found p_op ' .. p_op .. ' ' .. p_op_pos
        " Search for the first operator in cline.
        let pat = '^\V\(' .. join(ops, '\|') .. '\)\ze\s'
        let [c_op, c_op_pos, c_op_end] = matchstrpos(cline, pat, cline_indent)
        if c_op_pos != -1
            " echom 'found c_op ' .. c_op .. ' ' .. c_op_pos
            " May align with the operator.
            if c_op_pos < p_op_pos
                if cline_indent < p_op_pos && p_op_pos < align_pos
                    " echom 'align with op in pline ' .. p_op .. ' ' .. align_pos
                    let align_pos = p_op_pos
                endif
            endif
        else
            " Search for the first non-space in pline after the first operator.
            let p_operand_pos = match(pline, '\S', p_op_pos + strlen(p_op))
            if p_operand_pos != -1
                " May align with the operand.
                if cline_indent < p_operand_pos && p_operand_pos < align_pos
                    " echom 'align with operand in pline ' .. p_operand_pos
                    let align_pos = p_operand_pos
                endif
            endif
        endif
    endif
    " May align with previous line with one more shiftwidth.
    let pline_indent_sw = pline_indent + shiftwidth()
    if cline_indent < pline_indent_sw && pline_indent_sw < align_pos
        let align_pos = pline_indent_sw
    endif
    " If there is no proper align position, align with previous line.
    if align_pos == pline_len
        let align_pos = pline_indent
    endif
    " echom 'align with pline ' .. align_pos
    call s:CppAlignAt(cline_num, cline, align_pos)
endfunction

nnoremap <Leader>a :call CppAlign()<CR>

