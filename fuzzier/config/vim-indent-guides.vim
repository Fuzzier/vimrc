""
" @file vim-indent-guides settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"---------------------------------------
" Boolean263/vim-indent-guides
"---------------------------------------
" Start automatically.
let g:indent_guides_enable_on_vim_startup = 1
"
" Disable for certain plugins.
let g:indent_guides_exclude_filetypes = [ 'help', 'nerdtree', 'leaderf' ]
"
" Use custom colors.
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  guibg=#262626 ctermbg=236
hi IndentGuidesEven guibg=#262626 ctermbg=236
"
" Do not change color.
" let g:indent_guides_color_change_percent = 0
"
" Show a vertical line, it is enough to identify the scopes.
let g:indent_guides_guide_size = 1
"
" Show guides from the second indent level.
let g:indent_guides_start_level = 2

