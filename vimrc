"===============================================================================
"         FILE:  vimrc
"  DESCRIPTION:  suggestion for a personal configuration file vimrc
"       AUTHOR:  Dr.-Ing. Fritz Mehner <mehner@fh-swf.de>
"      CREATED:  2009-04-04
"     REVISION:  $Id: customization.vimrc,v 1.6 2009/10/03 12:24:30 mehner Exp $
"       AUTHOR:  Wei Tang <gauchyler@uestc.edu.cn>
"     MODIFIED:  2026-05-22
"===============================================================================

"===============================================================================
" PATH
"===============================================================================
" The directory structure
" vim ($VIM)
" |- vim92 ($VIMRUNTIME)
" |  |- vim.exe
" |  |- gvim.exe
" |- vimfiles
" |  |- vimrc (this file)
" |  |- fuzzier ($HOME)
" |     |- vimrc
" |     |- gvimrc
" |
" |- ccls
" |  |- bin
" |     |- ccls.exe
" |- LLVM
" |  |- bin
" |     |- clang.exe
" |     |- clang++.exe
" |     |- lld.exe
" |     |- lldb.exe
" |- node
" |  |- node.exe
" |  |- node_modules
" |- python
"    |- python.exe
"    |- Lib
"       |- site-packages
" The root directory.
let s:vim_root = getenv('VIM')

" The directory that contains this 'vimrc'.
let s:curr_path = expand('<sfile>:p:h')

let s:user = '/fuzzier'

" The user profile directory.
let s:vim_home = s:curr_path .. s:user
if !isdirectory(s:vim_home)
    let s:vim_home = s:curr_path .. '/vimfiles' .. s:user
    if !isdirectory(s:vim_home)
        echomsg 'Cannot find user directory'
        cquit 1
    endif
endif

" Prepend path to environment variable.
function! s:PrependPathToEnvvar(varname, path)
    if has('win32')
        let sep = ';'
    else
        let sep = ':'
    endif
    let value = getenv(a:varname)
    if empty(value)
        call setenv(a:varname, a:path)
    else
        call setenv(a:varname, a:path .. sep .. value)
    endif
endfunction

" Prepend path to environment variable.
function! s:AppendPathToEnvvar(varname, path)
    if has('win32')
        let sep = ';'
    else
        let sep = ':'
    endif
    let value = getenv(a:varname)
    if empty(value)
        call setenv(a:varname, a:path)
    else
        call setenv(a:varname, value .. sep .. a:path)
    endif
endfunction

if has('win32')
    " Python environment.
    let s:python_home = s:vim_root .. '/python'
    if isdirectory(s:python_home)
        let s:python_path = s:python_home .. '/Lib'
        call setenv('PYTHONHOME', s:python_home)
        call setenv('PYTHONPATH', s:python_path)
        call s:AppendPathToEnvvar('PYTHONPATH', s:python_path .. '/site-packages')
        call s:PrependPathToEnvvar('PATH', s:python_home)
   endif

    " Nodejs environment.
    let s:node_home=s:vim_root .. '/node'
    if isdirectory(s:node_home)
        let s:node_path=s:node_home .. '/node_modules'
        call setenv('NODE_PATH', s:node_path)
        call s:PrependPathToEnvvar('PATH', s:node_home)
    endif

    " LLVM.
    let s:llvm_path = s:vim_root .. '/LLVM/bin'
    if isdirectory(s:llvm_path)
        call s:PrependPathToEnvvar('PATH', s:llvm_path)
    endif

    let s:ccls_path = s:vim_root .. '/ccls/bin'
    if isdirectory(s:ccls_path)
        call s:AppendPathToEnvvar('PATH', s:ccls_path)
    endif

    let s:ctags_path = s:vim_root .. '/ctags'
    if isdirectory(s:ctags_path)
        call s:AppendPathToEnvvar('PATH', s:ctags_path)
    endif

    let s:cscope_path = s:vim_root .. '/cscope'
    if isdirectory(s:cscope_path)
        call s:AppendPathToEnvvar('PATH', s:cscope_path)
    endif

endif

" Source 'vimrc' and 'gvimrc'.
execute 'source ' .. s:vim_home .. '/vimrc'
if has('gui_running')
    execute 'source ' .. s:vim_home .. '/gvimrc'
endif
