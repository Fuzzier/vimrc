""
" @file Toggle `if` not for C++.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

function! CppToggleLogicalNot()
    " if (expr)   =>  if (!expr)
    " if (!expr)  =>  if (expr)
    let cline_num = line('.')
    let cline = getline(cline_num)
    if cline =~ 'NSFX_.\{-}(!'
        let nline = substitute(cline, '\(NSFX_.\{-}\)(!', '\1(', '')
        call setline(cline_num, nline)
    elseif cline =~ 'NSFX_.\{-}('
        let nline = substitute(cline, '\(NSFX_.\{-}\)(', '\1(!', '')
        call setline(cline_num, nline)
    elseif cline =~ '(!'
        let nline = substitute(cline, '(!', '(', '')
        call setline(cline_num, nline)
    elseif cline =~ '.\{-}('
        let nline = substitute(cline, '\(.\{-}(\)', '\1!', '')
        call setline(cline_num, nline)
    endif
    silent! call repeat#set(":call CppToggleLogicalNot()\<CR>")
endfunction
"
nnoremap <Leader>n  :call CppToggleLogicalNot()<CR>


function! CppToggleNsfxLikely()
    " if (expr)                    =>  if NSFX_EXPR_LIKELY(expr) NSFX_LIKELY
    " if NSFX_EXPR_LIKELY(expr)    =>  if NSFX_EXPR_UNLIKELY(expr) NSFX_LIKELY
    " if NSFX_EXPR_UNLIKELY(expr)  =>  if (expr)
    let cline_num = line('.')
    let cline = getline(cline_num)
    if cline =~# 'NSFX_EXPR_LIKELY'
        let nline = substitute(cline, 'NSFX_EXPR_LIKELY', 'NSFX_EXPR_UNLIKELY', '')
        let nline = substitute(nline, 'NSFX_LIKELY', 'NSFX_UNLIKELY', '')
        call setline(cline_num, nline)
    elseif cline =~# 'NSFX_EXPR_UNLIKELY'
        let nline = substitute(cline, 'NSFX_EXPR_UNLIKELY', '', '')
        let nline = substitute(nline, '\s\+NSFX_UNLIKELY', '', '')
        call setline(cline_num, nline)
    elseif cline =~ '('
        let nline = substitute(cline, '(', 'NSFX_EXPR_LIKELY(', '')
        call setline(cline_num, nline)
        " The parenthesis after 'NSFX_EXPR_LIKELY'
        let cpos = getpos('.') " [bufnum, lnum, col, off]
        let npos = copy(cpos)
        " The character index of the left parenthesis after 'NSFX_EXPR_LIKELY'
        let npos[2] = matchend(nline, 'NSFX_EXPR_LIKELY')
        " Move cursor to the newly inserted left parenthesis
        call setcharpos('.', npos)
        try
            " %: Find the matching right parenthesis
            " a): Insert right parenthesis
            normal! %a NSFX_LIKELY
        finally
            " Restore the original cursor position
            call setcharpos('.', cpos)
        endtry
    endif
    silent! call repeat#set(":call CppToggleNsfxLikely()\<CR>")
endfunction
"
nnoremap <Leader><Leader>n  :call CppToggleNsfxLikely()<CR>

