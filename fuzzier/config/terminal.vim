""
" @file Terminal.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"-------------------------------------------------------------------------------
" Terminal.
"-------------------------------------------------------------------------------
function! TabLabel(n)
    let l:buflist = tabpagebuflist(a:n)
    let l:winnr = tabpagewinnr(a:n)
    let l:name = bufname(l:buflist[l:winnr - 1])
    if l:name =~ 'SetVcEnv'
        let l:label = 'msvc'
    elseif l:name =~ 'SetClangEnv'
        let l:label = 'clang'
    else
        let l:label = fnamemodify(l:name, ':t')
    endif
    return l:label
endfunction

function! TabLine()
    let l:line = ''
    for l:index in range(tabpagenr('$'))
        let l:tab = l:index + 1
        " Select tab highlighting.
        if l:tab == tabpagenr()
            let l:line ..= '%#TabLineSel#'
        else
            let l:line ..= '%#TabLine#'
        endif
        " Set tab page number.
        let l:line ..= '%' .. l:tab .. 'T'
        " Set tab label.
        let l:line ..= ' %{TabLabel(' .. l:tab .. ')}'
    endfor
    " After the last tab fill with TabLineFill and reset tab page nr.
    let l:line ..= '%#TabLineFill#%'
    return l:line
endfunction

if exists('&guioptions') && stridx(&guioptions, 'e') != -1
    set guitablabel=%{TabLabel(tabpagenr())}
else
    hi TabLine     ctermfg=grey  ctermbg=black guifg=#999999 guibg=#000000
    hi TabLineSel  ctermfg=white ctermbg=black guifg=#ffffff guibg=#000000
    hi TabLineFill ctermbg=black
    set tabline=%!TabLine()
endif

function! OpenTab(script)
    let l:cmd = ":tab terminal "
    if executable(a:script)
        if !has('nvim')
            " vim:  ":tab terminal ++shell "
            " nvim: ":tab terminal "
            let l:cmd ..= "++shell "
        endif
        " vim:  ":tab terminal ++shell cmd /k SetVcEnv.cmd"
        " nvim: ":tab terminal cmd /k SetVcEnv.cmd"
        let l:cmd ..= "cmd /k" .. a:script
    endif
    " echom l:cmd
    execute l:cmd
    " Enter terminal insert mode.
    if has('nvim')
        normal! i
    endif
endfunction

" Use `<Esc>` to leave terminal insert mode.
tnoremap <Esc>   <C-\><C-n>

if has('win32')
tnoremap <C-l>   <CR><CR><CR><CR><CR><CR><CR><CR><CR><CR><CR><CR><CR><CR><CR><CR><CR><CR><CR><CR><CR>
endif

" Open a terminal in a new tab.
command! Tv call OpenTab('SetVcEnv.cmd')
command! Tc call OpenTab('SetClangEnv.cmd')

if has('terminal') && exists(':terminal')
    " Set terminal window key to.
    set termwinkey=<C-_>
    " Use `Ctrl-Tab` key to switch to the next tab.
    tnoremap <silent> <C-Tab>   <C-_>:tabnext<CR>
elseif has('nvim')
    " Use `Ctrl-Tab` key to switch to the next tab.
    tnoremap <silent> <C-Tab>   <C-\><C-n>:tabnext<CR>
endif

if has('nvim')
autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no
else
autocmd TerminalOpen * setlocal nonumber norelativenumber signcolumn=no
endif

