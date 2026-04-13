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
        return -1
    endif
    let stack = []
    let depth = 0
    let index = a:pos + 1
    while index < len(a:line)
        let ch = a:line[index]
        if ch == open
            let depth += 1
        elseif ch == close
            if depth == 0
                return index
            endif
            let depth -= 1
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

function! CppAlign()
    call repeat#set(":call CppAlign()\<CR>")
    let cline_num = line('.')
    if cline_num == 0
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
    if pline_len <= cline_indent + 1
        call s:CppAlignAt(cline_num, cline, pline_indent + shiftwidth())
        return
    endif
    let pos = cline_indent
    while v:true
        " Find next: space, (, [, {, <
        let [ch, pos, end] = matchstrpos(pline, '\s\|[(\[{<]', pos)
        if pos == -1 || pos + 1 == pline_len
            " Align with previous line with one more shiftwidth.
            call s:CppAlignAt(cline_num, cline, pline_indent + shiftwidth())
            return
        endif
        " If an opening delimiter is found.
        if ch !~# '\s'
            let close_pos = s:CppFindMatchingClose(pline, pos)
            " If the opening delimiter has no matching close on the same line.
            if close_pos == -1
                " Align with one character after: (, [, {, <
                call s:CppAlignAt(cline_num, cline, pos + 1)
                return
            else
                let pos = close_pos + 1
                continue
            endif
        endif
        " After space, find next: non-space, (, [, {, <
        let [ch, pos, end] = matchstrpos(pline, '\S*[(\[{<]', pos + 1)
        if pos == -1 || pos + 1 == pline_len
            " Align with previous line with one more shiftwidth.
            call s:CppAlignAt(cline_num, cline, pline_indent + shiftwidth())
            return
        endif
        " If a keyword is found.
        if ch =~# '\k'
            " Align with the keyword.
            call s:CppAlignAt(cline_num, cline, pos)
            return
        endif
        " Otherwise, an opening delimiter is found.
        " If the opening delimiter has no matching close on the same line.
        if s:CppFindMatchingClose(pline, pos) == -1
            " Align with one character after: (, [, {, <
            call s:CppAlignAt(cline_num, cline, pos + 1)
            return
        else
            let pos += 1
            continue
        endif
    endwhile
endfunction

nnoremap <Leader>a :call CppAlign()<CR>

