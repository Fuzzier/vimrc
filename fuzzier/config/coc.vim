""
" @file coc.nvim settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"---------------------------------------
" neoclide/coc.nvim
"---------------------------------------
" NOTE:
" If `nvim-qt` is used,
" `neovim/share/neovim-qt/runtime/plugin/nvim_gui_shim.vim` shall be removed!
"
" Configurations.
let g:coc_config_home = g:vimrc_path
let g:coc_data_home = g:vimrc_path . '/coc'
"
" Check whether coc.nvim installed.
if isdirectory(repos_path.'/coc.nvim')
    " Use <Tab> for trigger completion and navigate to the next complete item.
    function! s:check_backspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction
    "
    " Use <C-Space> to trigger completion.
    inoremap <silent><expr> <C-Space> coc#refresh()
    "
    " Use <CR> to confirm completion without expanding a snippet
    " (<C-y> is always available to expand a snippet).
    " Until `v0.0.81`, coc.nvim uses built-in popup menu, the visibility of
    " the popup menu is examined by `pumvisible()`.
    if coc#util#api_version() <= 30
        inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    " From `v0.0.82`, coc.nvim uses custom popup menu, the visibility of
    " the popup menu shall be examined by the new api.
    else
        inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    endif
    "
    " Snippet navigation keys.
    let g:coc_snippet_next = '<Tab>'
    let g:coc_snippet_prev = '<S-Tab>'
    "
    " Use '[c' and ']c' to navigate diagnostics.
    if coc#util#api_version() <= 30
        nmap <silent> [w <Plug>(coc-diagnostic-previous)
    else
        nmap <silent> [w <Plug>(coc-diagnostic-prev)
    endif
    nmap <silent> ]w <Plug>(coc-diagnostic-next)
    "
    " Various actions.
    nmap <silent> <Leader>gd <Plug>(coc-definition)
    nmap <silent> <Leader>gt <Plug>(coc-type-definition)
    nmap <silent> <Leader>gi <Plug>(coc-implementation)
    nmap <silent> <Leader>gr <Plug>(coc-references)
    nmap <silent> <Leader>fc <Plug>(coc-fix-current)
    nmap <silent> <Leader>fh <Plug>(coc-float-hide)
    nmap <silent> <Leader>fj <Plug>(coc-float-jump)
    nmap <silent> <Leader>rf <Plug>(coc-refactor)
    nmap <silent> <Leader>rn <Plug>(coc-rename)
    "
    nmap <silent> <Leader><Leader>gd :vs<Plug>(coc-definition)
    "
    " Use 'K' to show documentation in preview window.
    nnoremap <silent> K :call ShowDocumentation()<CR>
    function! ShowDocumentation()
        if CocAction('hasProvider', 'hover')
            call CocActionAsync('doHover')
        else
            call feedkeys('K', 'in')
        endif
    endfunction
    "
    " Show signature for symbol when jumped to next/prev placeholder in a snippet.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    "
    " Show signature for symbol under cursor in insert mode.
    autocmd CursorHoldI * silent call CocActionAsync('showSignatureHelp')
    "
    " Highlight symbol under cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')
    highlight! def link CocHighlightText Pmenu
    "
    " Show in status line.
    function! CocStatusDiagnostic() abort
        let info = get(b:, 'coc_diagnostic_info', {})
        if empty(info) | return '' | endif
        let msgs = []
        if get(info, 'error',   0) | call add(msgs, 'E' . info['error'])   | endif
        if get(info, 'warning', 0) | call add(msgs, 'W' . info['warning']) | endif
        call add(msgs, get(g:, 'coc_status', ''))
        " call add(msgs, get(b:, 'coc_current_function', ''))
        return join(msgs, ' ')
    endfunction
    "
    " set statusline=%n\ %<%f\ %h%m%r%=%{CocStatusDiagnostic()}\ %-14.(%l,%c%V%)\ %P
    " set statusline=%n\ %<%f\ %h%m%r%=%{CocStatusDiagnostic()}\ %{gutentags#statusline('[',']')}\ %-14.(%l,%c%V%)\ %P
    " set statusline=%n\ %<%f\ %=%{tagbar#currenttag('%s','','f')}\ %h%m%r%=%{CocStatusDiagnostic()}\ %-14.(%l,%c%V%)\ %P
    " %n : buffer number
    " %< : where to truncate line if too long
    " %f : file path relative to cwd
    " %M : modified flag
    " %R : readonly flag
    " %= : section separator
    " %{CocStatusDiagnostic()}: show number of warnings and errors
    " %- : left justify
    " () : group items
    " %l : line number
    " %c : column number
    " %V : virtual column number
    " %P : percentage
    set statusline=%n\ %<%f\ %h%M%R%=%{CocStatusDiagnostic()}\ %-10.(%l,%c%V%)\ %P
endif

