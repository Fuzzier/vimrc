""
" @file C++ copy class name.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-04-17
"

function! CppCopyClassName()
    let class_name = ''
    " class|struct Xxx
    " * not preceded by any other keywords (e.g., 'friend')
    " * not followed by ';'
    let cline_num = line('.')
    let col = col('.')
    while cline_num != 0
        let cline = getline(cline_num)
        " class/struct declaration
        let pat = '^\s*\zs\%(class\|struct\)\ze\s\+\(\k\|:\)\+;\@!'
        let [s, pos, end] = cline->matchstrpos(pat)
        if pos != -1
            if pos <= col
                let pat = '^\s*\%(class\|struct\)\s\+\zs\(\k\|:\)\+\ze;\@!'
                let class_name = cline->matchstr(pat)
                " echom 'found class name in decl ' .. class_name
                break
            endif
        endif
        " ctor/dtor definition
        "                scope      name     ::
        "                                      tild (if any)
        let pat = '^\s*\zs.\{-}\%(\k\|:\)*\ze::\~\?\k\+('
        let [s, pos, end] = cline->matchstrpos(pat)
        if pos != -1
            if pos <= col
                let pat = '\zs\%(\k\|:\)\+\ze::\~\?\k\+('
                let class_name = cline->matchstr(pat)
                " echom 'found class name in func ' .. class_name
                break
            endif
        endif
        let cline_num = cline_num - 1
    endwhile
    if class_name != ''
        echo class_name
        " " If the class name looks like 'Xxx::Yyy'
        " if class_name =~ '::'
        "     " Remove qualifiers, e.g., remove 'Xxx::', and keep the last 'Yyy'
        "     let class_name = class_name->matchstr('\k\+$')
        " endif
        call setreg('c', class_name)
    endif
endfunction
nnoremap <Leader><Leader>c  :call CppCopyClassName()<CR>

