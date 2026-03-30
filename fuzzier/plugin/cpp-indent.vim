""
" @file Better C++ indentation.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"===============================================================================
" Better indentation for C++ template and namespace
" @see https://github.com/benlangmuir/home/blob/master/.vim/indent/cpp.vim
"
" The key to proper indentation is to examine the previous and current context.
" In C++, an indentation context can be coarsely categorized as follows:
" * preprocessor directive
" * line comment
" * block comment
" * template parameter list
" * jump label
" * access control label
" * default case label
" * initialization list
"
" Each indentation context is accompanied with a state:
" * start
" * after start
" * end
" * after end
"
" Most of the work **shall** be done via `cindent()`.
" * Indent of previous line
" * Opening brace of current block
"
" The extra work is to correct unexpected indentations.
"===============================================================================
function! CppIsJumpLabel(line)
    " The following are excluded:
    " * public:
    " * protected:
    " * private:
    " * default:
    " * case XX:
    if a:line =~ '^\s*[_a-zA-Z][_0-9a-zA-Z]*\s*::\@!'
        if a:line !~# '^\s*\(public\|protected\|private\|default\|case\s.*\)\s*:'
            return v:true
        endif
    endif
    return v:false
endfunction

function! CppPreviousOpenBrace(cline_num)
    let pline_num = a:cline_num
    while pline_num != 0
        let pline_num = prevnonblank(pline_num - 1)
        if pline_num == 0
            break
        endif
        let pline = getline(pline_num)
        " Find the previous open brace.
        if pline =~ '{'
            return pline_num
        endif
    endwhile
    return a:cline_num
endfunction

function! CppIndentComment(cline_num)
    let cline_num = a:cline_num
    let pline_num = cline_num - 1
    let pline = getline(pline_num)
    "
    "     cline shall indent here
    "     |
    "     v
    " ... ///< ...      <= pline
    "     ///< ...      <= cline
    "
    " `cline` contains a doxygen trailing comment.
    " * starts with '///<'
    " * The previous line also contains a doxygen trailing comment.
    "             / / /<
    if pline =~ '\/\/\/<'
        " Indent at the start of the comment in the previous line
        let retv = stridx(pline, '///<')
    else
        let retv = cindent(cline_num)
    endif
    return retv
endfunction

function! CIndentComment(cline_num)
    let cline_num = a:cline_num
    let pline_num = cline_num - 1
    let pline = getline(pline_num)
    "
    "      cline shall indent here
    "      |
    "      v
    " ... /**< ...      <= pline
    "      * ...        <= cline
    "
    " `cline` contains a doxygen trailing comment.
    " * starts with '/**<'
    " * The previous line also contains a doxygen trailing comment.
    "             / * *<
    if pline =~ '\/\*\*<'
        " Indent 1 space after the start of the comment in the previous line
        let retv = stridx(pline, '/**<') + 1
    else
        let retv = cindent(cline_num)
    endif
    return retv
endfunction

function! CppIndentAsTemplate(pline_num)
    let pline_num = a:pline_num
    while pline_num
        let pline_num = prevnonblank(pline_num - 1)
        let pline = getline(pline_num)
        "
        " cline shall indent here
        " |
        " v
        " template<class ...,
        "          class ...,      <= pline
        "          class ...,
        "          class ...>
        " class ...                <= cline
        if pline =~# '^\s*\(class\|typename\)\>.*,\s*$'
            " Search further back until the line that declares 'template'.
            continue
        "
        " cline shall indent here
        " |
        " v
        " template<class ...,      <= pline
        "          class ...,
        "          class ...>
        " class ...                <= cline
        " elseif pline =~# '^\s*template\>'
        "     " Return the indent of the previous line that declares 'template'.
        "     let retv = cindent(pline_num)
        else
            " This line isn't a special case. Fallback to cindent.
            let retv = cindent(pline_num)
        endif
        break
    endwhile
    "
  return retv
endfunction

function! CppIndentAsTemplateOpenChevron(pline_num)
    let pline_num = a:pline_num
    while pline_num
        let pline_num = prevnonblank(pline_num - 1)
        let pline = getline(pline_num)
        "
        "          cline shall indent here
        "          |
        "          v
        " template<class ...,
        "          class ...,      <= pline
        "          class ...,      <= cline, OR
        "          class ...>      <= cline
        if pline =~# '^\s*\(class\|typename\)\>'
            " Search further back until the line that declares 'template'.
            continue
        "
        "          cline shall indent here
        "          |
        "          v
        " template<class ...,      <= pline
        "          class ...,      <= cline, OR
        "          class ...>      <= cline
        elseif pline =~# '^\s*template\>'
            " Return the position after the opening chevron that follows
            " 'template'.
            let retv = stridx(pline, '<') + 1
        else
            " This line isn't a special case. Fallback to cindent.
            let retv = cindent(pline_num)
        endif
        break
    endwhile
    "
  return retv
endfunction

" @pre `cline` is not a C/C++-style comment.
function! CppIndentNonComment(cline_num)
    let cline_num = a:cline_num
    let cline = getline(cline_num)
    let pline_num = prevnonblank(cline_num - 1)
    let pline = getline(pline_num)
    "
    "     cline shall indent here
    "     |
    "     v
    " case XX:           <= pline OR
    " default:           <= pline
    "     ...            <= cline (not 'case' or 'default' or '}')
    "
    if pline =~# '^\s*\(case\s\|default\>\)' &&
    \  cline !~# '^\s*\(case\s\|default\>\|}\)'
        let retv = cindent(pline_num) + 4
        " echom 'after case/default: ' . retv
    "
    " cline shall indent here
    " |
    " v
    " xxx ...            <= pline
    " {                  <= cline
    "
    elseif cline =~ '^\s*{'
        let retv = cindent(cline_num)
        " echom 'opening brace: ' . retv
    "
    " cline shall indent here
    " |
    " v
    " template<class ...>      <= pline
    " class ...                <= cline
    "
    " `pline` is a single-line template declaration.
    " * starts with 'template'
    " * ends with a closing chevron '>' but not a comma ','
    elseif pline =~# '^\s*template\>.*>\s*$'
        " Return the indent of the previous line that declares 'template'.
        let retv = cindent(pline_num)
        " echom 'after single-line template declaration: ' . retv
    "
    "          cline shall indent here
    "          |
    "          v
    " template<class ...,      <= pline, OR
    "          class ...,      <= cline, OR
    "          class ...>      <= cline
    "
    " `pline` is the first line of a multi-line template declaration.
    " * starts with 'template'
    " * ends with a comma ',' but not a closing chevron '>'
    elseif pline =~# '^\s*template\>.*,\s*$'
        " Indent at the position after the opening chevron '<'
        let retv = stridx(pline, '<') + 1
        " echom 'within multi-line template declaration: ' . retv
    "
    "          cline shall indent here
    "          |
    "          v
    " template<class ...,
    "          class ...,      <= pline
    "          class ...>      <= cline
    "
    " `pline` is the intermediate line of a multi-line template declaration.
    " * starts with 'class' or 'typename'
    " * ends with a comma ',' but not a closing chevron '>'
    elseif pline =~# '^\s*\(class\|typename\)\>.*,\s*$'
        " Search further back until the line that declares 'template'.
        let retv = CppIndentAsTemplateOpenChevron(pline_num)
        " echom 'end of multi-line template declaration: ' . retv
    "
    " cline shall indent here
    " |
    " v
    " template<class ...,
    "          class ...,
    "          class ...>      <= pline
    " class ...                <= cline
    "
    " `pline` is the last line of a multi-line template declaration.
    " * starts with 'class' or 'typename'
    " * ends with a closing chevron '>' but a not comma ','
    elseif pline =~# '^\s*\(class\|typename\)\>.*>\s*$'
        " Search further back until the line that declares 'template'.
        let retv = CppIndentAsTemplate(pline_num)
        " echom 'after multi-line template declaration: ' . retv
    "
    "     cline shall indent here
    "     |
    "     v
    " xxx ...            <= 'class Xxx', 'Xxx()', ...
    "     : ...          <= cline (not '::')
    "
    elseif cline =~ '^\s*::\@!'
        " Search back for the class or function declaration
        while pline_num > 1
            "                    class  struct      (
            if pline =~# '\(\s*\(class\|struct\)\>\|(\)'
                break
            endif
            let pline_num = pline_num - 1
            let pline = getline(pline_num)
        endwhile
        let retv = cindent(pline_num) + shiftwidth()
        " echom 'colon: ' . retv
    "
    " cline shall indent here
    "   |
    "   v
    " xxx ...            <= 'class Xxx', 'Xxx()', ...
    "   : mem1_(...)     <= pline (not '::')
    "   , mem2_(...)     <= cline
    "
    elseif pline =~# '^\s*::\@!'
        let retv = stridx(pline, ':')
        " echom 'opening brace after colon: ' . retv
    "
    " cline shall indent here
    "   |
    "   v
    " xxx ...            <= 'class Xxx', 'Xxx()', ...
    "   : mem1_(...)
    "   , mem2_(...)     <= pline
    "   , mem3_(...)     <= cline
    "
    " cline shall indent here
    " |
    " v
    " Constructor(...)
    "   : mem1_(...)
    "   , mem2_(...)     <= pline
    " {                  <= cline
    "
    elseif pline =~ '^\s*,'
        let retv = stridx(pline, ',')
        " echom 'opening brace after comma: ' . retv
    "
    "     cline shall indent here
    "     |
    "     v
    " NSFX_XXX  (not ended with ';')
    "     ...                  <= cline
    "
    elseif pline =~# '^\s*NSFX_.*\(;\s*\)\@<!$'
        let retv = cindent(pline_num) + 4
        " echom 'after opening NSFX macro: ' . retv
    "
    " cline shall indent here
    "     |
    "     v
    " xxx<...,           <= pline
    "     ...            <= cline
    "
    "                      \w\+ words
    "                                 <\|(  left chevron or left parenthesis
    "                                       ,  ends with ','
    elseif pline =~ '^\s*\(\w\+\)\s*\(<\|(\).*,\s*$'
        let retv = match(pline, '<\|(') + 1
        " echom 'within template specialization: ' . retv
    "
    " cline shall indent here
    " |
    " v
    " specifier
    " ...                      <= cline
    "
    " elseif pline =~# '^\s*\(alignas\|const\|consteval\|constexpr\|constinit\|decltype\|explicit\|extern\|friend\|inline\|mutable\|register\|static\|thread_local\|using\|virtual\|volatile\)\>.*'
    "     let retv = cindent(pline_num)
    else
        " This line isn't a special case. Fallback to cindent.
        let retv = cindent(cline_num)
        " echom 'fallback to cindent: ' . retv
    endif
    "
  return retv
endfunction

" Correct indentation for the following declarations.
" * C++ comment
" * C++ template
" * C++ specifiers
function! CppIndent()
    let cline_num = line('.')
    let cline = getline(cline_num)
    "
    " cline shall indent here
    " |
    " v
    " #ifdef                 <= cline
    "
    " `cline` is a preprocessor directive.
    " if cline =~ '^#'
    "     let retv = 0
    "
    " cline shall indent here
    " |
    " v
    " {
    " ...
    " label:                 <= cline
    "
    " `cline` is a jump label.
    if CppIsJumpLabel(cline)
        let retv = cindent(cline_num)
        if retv < 0 | let retv = 0 | endif
    "
    "     cline shall indent here
    "     |
    "     v
    " ... // ...             <= pline
    "     // ...             <= cline
    "
    " `cline` has a C++-style trailing comment.
    " * starts with '//'
    " * The above line has a C++-style trailing comment.
    elseif cline =~ '^\s*\/\/'
        let retv = CppIndentComment(cline_num)
    elseif cline =~ '\/\*\*<'
        let retv = CIndentComment(cline_num)
    else
        let retv = CppIndentNonComment(cline_num)
    endif
    "
  return retv
endfunction

if has("autocmd")
    autocmd BufEnter *.{c,cc,cxx,cpp,h,hh,hpp,hxx} setlocal indentexpr=CppIndent()
    " s1:/*,mb:*,ex:*/
    "   s1:/* : The start of comment is '/*', and add 1 space to the middle and
    "           end pieces.
    "   mb:*  : The middle parts begin with '*', and must be followed by blank
    "           character.
    "   ex:*/ : The end of comment is '*/'. Vim will insert '* ' for new lines
    "           after '/*'. Typing '/' will convert '* ' to '*/', and ends the
    "           comment.
    " :///<,:///,://
    "   '///<', '///', '//' are repeatable start of comment.
    autocmd BufEnter *.{c,cc,cxx,cpp,h,hh,hpp,hxx} setlocal comments=s1:/*,m:*,ex:*/,:///<,:///,://
endif

