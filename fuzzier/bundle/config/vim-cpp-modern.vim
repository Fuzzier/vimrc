""
" @file vim-cpp-modern settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"---------------------------------------
" bfrg/vim-cpp-modern
"---------------------------------------
" Enable highlighting of C++11 attributes
let g:cpp_attributes_highlight = 1

" Put all standard C and C++ keywords under Vim's highlight group 'Statement'
let g:cpp_simple_highlight = 1
"
" Disable highlighting of named requirements (C++20 library concepts)
let g:cpp_named_requirements_highlight = 0

