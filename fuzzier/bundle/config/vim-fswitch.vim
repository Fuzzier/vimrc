""
" @file vim-fswitch settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"---------------------------------------
" derekwyatt/vim-fswitch
"---------------------------------------
" Never create new file if the alternative file does not exist.
let g:fsnonewfiles = 'no'
"
" FSwitch() that saves and restores window view,
" thus when the window switches back to a buffer, the cursor is moved back
" to where it was.
" The buffer will save window view for each window.
function! FSwitchView(fname, precmd)
    call FSwitch(a:fname, a:precmd)
endfunction
"
" xxx.h  ->  xxx.c
" xxx.c  ->  xxx.h
function! FSwitchC()
    let l:ext   = expand('%:e')   " File extension
    let l:fname = expand('%:t:r') " File name
    " <fname>.h
    if l:ext =~# '^\%(h\|hh\|hpp\|hxx\)$'
        " include/<fname>.h  ->  src/<fname>.c
        let b:fswitchdst    = 'c,cc,cpp,cxx,ex.c,ex.cpp'
        let b:fswitchfnames = '/^//'
        let b:fswitchlocs   = '.'
    " <fname>.c
    elseif l:ext =~# '^\%(c\|cc\|cpp\|cxx\)$'
        " src/<fname>.c  ->  include/i-<fname>.h
        let b:fswitchdst    = 'h,hh,hpp,hxx'
        let b:fswitchfnames = '/^//,/\.ex$//'
        let b:fswitchlocs   = '.'
    else
        return
    endif
    call FSwitchView('%', '')
endfunction
"
nnoremap <silent> <Leader>fs :call FSwitchC()<CR>
"
" i-xxx.h  ->  xxx.h
" xxx.h    ->  i-xxx.h
function! FSwitchI()
    let l:ext   = expand('%:e')
    let l:fname = expand('%:t:r')
    " i-<fname>.h
    if l:fname =~ '^i-' && l:ext =~ '^\%(h\|hh\|hpp\|hxx\)$'
        " include/i-<fname>.h  ->  src/<fname>.h
        " include/i-<fname>.h  ->  src/<fname>.cpp
        let b:fswitchdst    = 'h,hh,hpp,hxx,cc,cpp,cxx'
        let b:fswitchfnames = '/^i-//'
        let b:fswitchlocs   = '.,..,../..'
    " <fname>.h, <fname>.cpp
    elseif l:ext =~ '^\%(h\|hh\|hpp\|hxx\|c\|cc\|cpp\|cxx\)$'
        " src/<fname>.h    ->  include/i-<fname>.h
        " src/<fname>.cpp  ->  include/i-<fname>.h
        let b:fswitchdst    = 'h,hh,hpp,hxx'
        let b:fswitchfnames = '/^/i-/'
        let b:fswitchlocs   = '.,..,../..'
    else
        return
    endif
    call FSwitchView('%', '')
endfunction
"
" Comment: It is recommended to use `:LeaderfFile`.
" nnoremap <silent> <Leader>fi :call FSwitchI()<CR>
"
" xxx.h ->  test-xxx.cpp
function! FSwitchT()
    let l:ext   = expand('%:e')
    let l:fname = expand('%:t:r')
    " test-<fname>.cpp
    if l:fname =~ '^test-' && l:ext =~ '^\%(h\|hh\|hpp\|hxx\|c\|cc\|cpp\|cxx\|json\|jsonc\)$'
        " /test/xxx/test-<fname>.cpp  ->  /xxx/<fname>.h
        let b:fswitchdst    = 'h,hh,hpp,hxx,c,cc,cpp,cxx'
        let b:fswitchfnames = '/^test-//'
        " Remove the last '/test' from file path
        let b:fswitchlocs   = '.,..,reg:#.*\%(/\|\\\)\zstest\ze\%(/\|\\\)##'
    " <fname>.h, <fname>.cpp
    elseif l:ext =~ '^\%(h\|hh\|hpp\|hxx\|c\|cc\|cpp\|cxx\)$'
        " /xxx/<fname>.h  ->  /test/xxx/test-<fname>.cpp
        let b:fswitchdst    = 'c,cc,cpp,cxx,h,hh,hpp,hxx'
        let b:fswitchfnames = '/^/test-/'
        " Insert '/test' before the last '/'
        let b:fswitchlocs   = '.,/test,reg:#.*\zs\ze\%(/\|\\\)#/test#'
    else
        return
    endif
    call FSwitchView('%', '')
endfunction
"
" Comment: It is recommended to use `:LeaderfFile`.
" nnoremap <silent> <Leader>ft :call FSwitchT()<CR>
"
" /test/xxx/test-<fname>.cpp  <->  /test/xxx/test-<fname>.jsonc
" /xxx/<fname>.cpp            <->  /test/xxx/test-<fname>.jsonc
function! FSwitchJ()
    let l:ext   = expand('%:e')
    let l:fname = expand('%:t:r')
    if l:ext =~ '^\%(h\|hh\|hpp\|hxx\|c\|cc\|cpp\|cxx\)$'
        if l:fname =~ '^test-'
            " /test/xxx/test-<fname>.cpp  ->  /test/xxx/test-<fname>.jsonc
            let b:fswitchdst    = 'json,jsonc'
            let b:fswitchfnames = '/^//'
            let b:fswitchlocs   = '.'
        else
            " xxx/<fname>.cpp  ->  /test/xxx/test-<fname>.jsonc
            let b:fswitchdst    = 'json,jsonc'
            let b:fswitchfnames = '/^/test-/'
            " Insert '/test' before the last '/'
            let b:fswitchlocs   = '.,/test,reg:#.*\zs\ze\%(/\|\\\)#/test#'
        endif
    elseif l:ext =~ '^\%(jsonc\|json\)$'
        echo '.....'
        " /test/xxx/test-<fname>.cpp  <-  /test/xxx/test-<fname>.jsonc
        " /xxx/<fname>.cpp            <-  /test/xxx/test-<fname>.jsonc
        let b:fswitchdst    = 'c,cc,cpp,cxx,h,hh,hpp,hxx'
        let b:fswitchfnames = '/^//,/^test-//'
        " Insert '/test' before the last '/'
        let b:fswitchlocs   = '.,/test,reg:#.*\zs\ze\%(/\|\\\)#/test#'
    endif
    call FSwitchView('%', '')
endfunction
"
nnoremap <silent> <Leader>fj :call FSwitchJ()<CR>

