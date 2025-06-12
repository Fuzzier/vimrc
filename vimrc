"===============================================================================
"         FILE:  vimrc
"  DESCRIPTION:  suggestion for a personal configuration file vimrc
"       AUTHOR:  Dr.-Ing. Fritz Mehner <mehner@fh-swf.de>
"      CREATED:  2009-04-04
"     REVISION:  $Id: customization.vimrc,v 1.6 2009/10/03 12:24:30 mehner Exp $
"       AUTHOR:  Wei Tang <gauchyler@uestc.edu.cn>
"     MODIFIED:  2023-10-21
"===============================================================================

"===============================================================================
" PATH
"===============================================================================
" The directory where 'init.vim' resides.
function! GetVimHome()
    if has('win32')
        let path=expand('~/vimfiles')
    elseif has('unix')
        let path=expand('~/.vim')
    endif
    return path
endfunction
"
let vimrc_path=GetVimHome()

"-------------------------------------------------------------------------------
" Backup directory
"-------------------------------------------------------------------------------
" Set backup directory.
let backup_path=vimrc_path.'/bak'
if !isdirectory(backup_path)
    call mkdir(backup_path, 'p')
endif
let &backupdir=backup_path
"
"-------------------------------------------------------------------------------
" Swap directory
"-------------------------------------------------------------------------------
" Set swap directory.
let swap_path=vimrc_path.'/swp'
if !isdirectory(swap_path)
    call mkdir(swap_path, 'p')
endif
let &directory=swap_path
" Do not swap file, since it can be troublesome.
set noswapfile
"
"-------------------------------------------------------------------------------
" Undo directory
"-------------------------------------------------------------------------------
" Enable persistent undo for unloaded buffer.
set undofile
if !has('nvim')
    let undo_path=vimrc_path.'/undo'
else " Neovim uses an incompatible undo format.
    let undo_path=vimrc_path.'/nvim/undo'
endif
if !isdirectory(undo_path)
    call mkdir(undo_path, 'p')
endif
let &undodir=undo_path
"
"-------------------------------------------------------------------------------
" Bundle directory
"-------------------------------------------------------------------------------
" Set bundle directory.
let bundle_path=vimrc_path.'/bundle'
if !isdirectory(bundle_path)
    call mkdir(bundle_path, 'p')
endif
let &runtimepath.=','.vimrc_path.'/fuzzier'
let &runtimepath.=','.vimrc_path.'/fuzzier/after'
let repos_path=bundle_path.'/repos'

"-------------------------------------------------------------------------------
" PYTHON
"-------------------------------------------------------------------------------
if has('win32')
    " let g:python_host_prog = 'C:/Python-2.7/python.exe'
    let g:python3_host_prog = 'python.exe'
elseif has('unix')
    " let g:python_host_prog = '/usr/bin/python'
    let g:python3_host_prog = '/usr/bin/python3'
endif

"===============================================================================
" GENERAL SETTINGS
"===============================================================================
"
"-------------------------------------------------------------------------------
" Language
"-------------------------------------------------------------------------------
" Set default encoding.
set encoding=utf-8
"
" Set language for menus.
set langmenu=en_US.utf-8
"
" Set message encoding.
language message en_US.utf-8
"
"-------------------------------------------------------------------------------
" Color scheme (console & window)
"-------------------------------------------------------------------------------
" Enables 24-bit RGB color in the TUI.
if has('nvim')
    set termguicolors
endif
"
" Set gui color depth to 256.
set t_Co=256
"
" Set color scheme.
colorscheme calmar256x-dark
"
"-------------------------------------------------------------------------------
" GUI (console & window)
"-------------------------------------------------------------------------------
" Show guideline at 81-th column.
set colorcolumn=81

" Reserve 4 columns for showing line number, plus 1 column for visibility.
set winwidth=88
if has('nvim')
    autocmd WinEnter * :set winwidth=88
endif

" Show more lines.
set linespace=1

if has('nvim')
    set title
    set titlestring=%t\ (%{expand('%:p:h')})
endif

"-------------------------------------------------------------------------------
" Cursor
"-------------------------------------------------------------------------------
" Ps = 0  -> blinking block.
" Ps = 1  -> blinking block (default).
" Ps = 2  -> steady block.
" Ps = 3  -> blinking underline.
" Ps = 4  -> steady underline.
" Ps = 5  -> blinking bar (xterm).
" Ps = 6  -> steady bar (xterm).
" let &t_SI = "\e[6 q"
" let &t_EI = "\e[2 q"

"-------------------------------------------------------------------------------
" GUI Font (console & window)
"-------------------------------------------------------------------------------
function! SetFontSize(size)
    let l:fa = printf(':set guifont=Consolas:h%d', a:size)
    let l:fw = printf(':set guifontwide=Microsoft\ Yahei:h%d', a:size)
    execute l:fa
    execute l:fw
    " echom 'Set font size to ' . a:size
endfunction
"
if has('nvim') && has('gui_running')
    call SetFontSize(12)
else
    call SetFontSize(12)
endif

"-------------------------------------------------------------------------------
" Various settings
"-------------------------------------------------------------------------------
syntax enable                   " enable syntax highlighting
filetype plugin indent on       " enable language-dependent indenting
set autoindent                  " copy indent from current line
set autoread                    " read opened files when changed outside Vim.
                                " In Neovim, use :e<CR> to read manually.
set autowrite                   " write a modified buffer on each :next ,...
set backspace=indent,eol,start  " backspacing over everything in insert mode
set backup                      " keep a backup file
set cmdheight=2                 " prevent status line to be overwritten by mode message
set complete+=k                 " scan the files given with the 'dictionary' option
set concealcursor=n             " conceal text only in normal mode
set conceallevel=2              " conceal text completely
set cursorline                  " hightlight current cursor line and line number
set expandtab                   " use spaces for indentation, instead of tabs
set fileformats=unix,dos        " use unix end-of-line when editing new files
set foldmethod=marker           " fold by using markers
set formatoptions+=nBj          " n: recognize numbered lists
                                " B: don't insert a space between multi-byte characters when joining lines
                                " j: remove a comment leader when joining lines
set hidden                      " keep changed buffer without saving it
set history=10000               " keep 10000 lines of command line history
set hlsearch                    " highlight the last used search pattern
set incsearch                   " do incremental searching
set laststatus=2                " always show the status line
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
                                " strings to use in 'list' mode
set mouse=a                     " enable the use of the mouse
set nocompatible                " always use new features
set nowrap                      " do not wrap lines
set number                      " show line number
if !has('nvim')
set popt=left:8pc,right:3pc     " print options
endif
set ruler                       " show the cursor position all the time
set scrolloff=1                 " show at least 1 line below and after cursor
set sessionoptions-=options     " do not save options and mappings in session script
set shortmess+=c                " do not give completion popup menu messages
set shiftwidth=4                " number of spaces to use for each step of indent
set signcolumn=yes              " always draw signcolumn to show quickfix and syntax error signs
set showcmd                     " display incomplete commands
set showmatch                   " show the matching pair for parenthesis, brackets and braces
set sidescrolloff=5             " show at least 5 columns to the left and right of the cursor
set smartindent                 " smart autoindenting when starting a new line
set smarttab                    " use 'shiftwidth' at the beginning of a line
set switchbuf=                  " switch buffer within the current window
set tabpagemax=50               " set the maximum number of tabpages
set tabstop=4                   " number of spaces that a <Tab> counts for
set updatetime=500              " set idle time before CursorHold event
set viewoptions-=options        " do not save options and mappings in window session script
set visualbell                  " visual bell instead of beeping
set wildignore=*.bak,*.o,*.e,*~ " wildmenu: ignore these extensions
set wildmenu                    " command-line completion in an enhanced mode

if has('browse')
set browsedir=current           " which directory to use for the file browser
endif

"===============================================================================
" BUFFERS, WINDOWS
"===============================================================================

"-------------------------------------------------------------------------------
" Always display incomplete commands.
"-------------------------------------------------------------------------------
autocmd BufEnter * :set showcmd

"-------------------------------------------------------------------------------
" Always expand tab.
"-------------------------------------------------------------------------------
autocmd BufEnter * :set expandtab

"-------------------------------------------------------------------------------
" CTRL-X: substruct number.
"-------------------------------------------------------------------------------
silent! vunmap <C-X>

"-------------------------------------------------------------------------------
" The current directory is the directory of the file in the current window.
"-------------------------------------------------------------------------------
" Commented: Exclude buffers for: manpage, coc, fugitive, terminal.
autocmd BufEnter * :if bufname() !~# '^\(man:\|term:\|list:\|fugitive:\|LeaderF:\|!\)'
                \| :lchdir %:p:h
                \| :endif

"-------------------------------------------------------------------------------
" Indent JSON files by 2 spaces.
"-------------------------------------------------------------------------------
autocmd BufEnter *.json,*.jsonc :setlocal shiftwidth=2 | :setlocal tabstop=2
                             \| :syn clear jsonTrailingCommaError

"-------------------------------------------------------------------------------
" Hybrid line number
" * Absolute line number in normal mode
" * Relative line number in insert mode
" https://jeffkreeftmeijer.com/vim-number/
" https://github.com/jeffkreeftmeijer/vim-numbertoggle
" If you use tmux, add set-option -g focus-events on to your tmux config (~/.tmux.conf).
"-------------------------------------------------------------------------------
augroup hybridLineNumber
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter *
          \ if &nu && mode() != "i" | set relativenumber | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave *
          \ if &nu | set norelativenumber | endif
augroup END

"-------------------------------------------------------------------------------
" Recognize MIB definitions.
"-------------------------------------------------------------------------------
autocmd BufEnter *-SMI.txt,*-MIB.txt :set filetype=mib

"-------------------------------------------------------------------------------
" Leave the editor with Ctrl-q (KDE): Write all changed buffers and exit Vim
"-------------------------------------------------------------------------------
nnoremap  <C-q>    :wqall<CR>

"-------------------------------------------------------------------------------
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
"-------------------------------------------------------------------------------
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

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

" Use `:T` to open a terminal in a new tab.
command! T  call OpenTab('SetVcEnv.cmd')
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

"-------------------------------------------------------------------------------
" Tab navigation.
"-------------------------------------------------------------------------------
" Shortcuts for navigating tabs.
nnoremap <silent> <C-Tab>   :tabnext<CR>
nnoremap <silent> <C-S-Tab> :tabprev<CR>
inoremap <silent> <C-Tab>   <C-o>:tabnext<CR>
inoremap <silent> <C-S-Tab> <C-o>:tabprev<CR>

"-------------------------------------------------------------------------------
" Window navigation.
"-------------------------------------------------------------------------------
" Shortcuts for navigating among windows.
nnoremap <C-j>  <C-w>j
nnoremap <C-k>  <C-w>k
nnoremap <C-h>  <C-w>h
nnoremap <C-l>  <C-w>l

"-------------------------------------------------------------------------------
" Split window.
"-------------------------------------------------------------------------------
" Split vertically, then move the the new window immediately.
nnoremap <C-w>v      :vs<C-w>

"--------------------------------------------------------------------------------
" Save and restore window view for buffer
"--------------------------------------------------------------------------------
" XBufWin may be temporarily disabled.
let g:xbufwin_off = 0
"
function! XBufWinRestView()
    if &diff | return | endif " Do not interfere with synchronous diff view
    if g:xbufwin_off | return | endif
    let l:buf = bufnr()
    let l:win = win_getid()
    if exists('b:xbufwin_view')
        if has_key(b:xbufwin_view, l:win)
            let l:view = b:xbufwin_view[l:win]
            call winrestview(l:view) " Restore window view
        elseif has_key(b:xbufwin_view, 'last')
            let l:view = b:xbufwin_view['last']
            call winrestview(l:view) " Restore window view for new window
        endif
    endif
endfunction

function! XBufWinSaveView()
    if &diff | return | endif " Do not interfere with synchronous diff view
    if g:xbufwin_off | return | endif
    let l:win = win_getid()
    let l:view = winsaveview()
    if exists('b:xbufwin_view')
        let b:xbufwin_view[l:win] = l:view " Save window view
    else
        let b:xbufwin_view = { l:win : l:view } " Save window view
    endif
    let b:xbufwin_view['last'] = l:view " Save window view for new window
    "
    let l:keys = keys(b:xbufwin_view)
    for l:win in l:keys
        if l:win =~# 'last' || l:win =~# l:win
            continue
        endif
        if winbufnr(l:win) == -1 " Window does not exist
            unlet b:xbufwin_view[l:win]
        endif
    endfor
endfunction

augroup XBufWin
  autocmd!
  autocmd BufEnter * :call XBufWinRestView()
  autocmd WinScrolled,WinLeave,BufLeave * :call XBufWinSaveView()
augroup END

"-------------------------------------------------------------------------------
" Swap buffers between windows.
"-------------------------------------------------------------------------------
function! WinBufSwap(dir)
    " Disable XBufWin temporarily
    let g:xbufwin_off = 1
    " This window
    let thiswin  = winnr()
    let thisbuf  = winbufnr(thiswin)
    let thisview = winsaveview()
    " Next window
    let nextwin  = winnr(a:dir)
    let nextbuf  = winbufnr(nextwin)
    " Move to next window
    exec nextwin . ' wincmd w'
    let nextview = winsaveview()
    " 1. Change buffer in next window
    " 2. Restore view in next window
    " 3. Move back to this window
    " 4. Change buffer in this window
    " 5. Restore view in this window
    " 6. Move to next window
    let cmd =
        \ 'buffer ' .   thisbuf   . '|' .
        \ 'call winrestview(' .   string(thisview) . ')|' .
        \ thiswin   . ' wincmd w' . '|' .
        \ 'buffer ' .   nextbuf   . '|' .
        \ 'call winrestview(' .   string(nextview) . ')|' .
        \ nextwin   . ' wincmd w'
    " Swap buffer
    exec cmd
    let g:xbufwin_off = 0
    call repeat#set(":call WinBufSwap('" . a:dir ."')\<CR>")
endfunction

command! WL :call WinBufSwap('l')
command! WH :call WinBufSwap('h')
command! WJ :call WinBufSwap('j')
command! WK :call WinBufSwap('k')

"-------------------------------------------------------------------------------
" Reduce/increase window width by 10 columns.
"-------------------------------------------------------------------------------
function! AdjustWinWidth(n)
    if a:n >= 0
        let cmd = ":vertical resize +" . a:n
    else
        let cmd = ":vertical resize " . a:n
    endif
    exec cmd
    call repeat#set(":call AdjustWinWidth(" . a:n . ")\<CR>")
endfunction
nnoremap <C-w><C-d> :call AdjustWinWidth(-10)<CR>
nnoremap <C-w><C-a> :call AdjustWinWidth(10)<CR>

"-------------------------------------------------------------------------------
" Yank via 'Y'
"-------------------------------------------------------------------------------
if has('nvim')
    " 'Y' yank whole lines.
    nmap Y yy
endif

"-------------------------------------------------------------------------------
" Duplicate tab.
"-------------------------------------------------------------------------------
command! -bar DuplicateTabpane
      \ let s:sessionoptions = &sessionoptions |
      \ try |
      \   let s:this_session = v:this_session |
      \   let &sessionoptions = 'blank,buffers,curdir,folds,globals,help,options,winsize' |
      \   let s:file = tempname() |
      \   execute 'mksession ' . s:file |
      \   tabnew |
      \   let s:tabnr = tabpagenr() |
      \   execute '-tabclose ' |
      \   execute 'source ' . s:file |
      \ finally |
      \   silent call delete(s:file) |
      \   let &sessionoptions = s:sessionoptions |
      \   let v:this_session = s:this_session |
      \   unlet! s:file s:sessionoptions s:this_session s:tabnr |
      \ endtry
"===============================================================================
" EDITTING
"===============================================================================

"-------------------------------------------------------------------------------
" Copy string to clipboard
"-------------------------------------------------------------------------------
noremap <Leader><Leader>y  "*yi"
noremap <Leader><Leader>p  "*p
noremap <Leader><Leader>P  "*P

"-------------------------------------------------------------------------------
" comma always followed by a space
"-------------------------------------------------------------------------------
inoremap  ,  ,<Space>

"-------------------------------------------------------------------------------
" Remove entered word by Ctrl-Backspace in Insert mode.
"-------------------------------------------------------------------------------
" Remove a word backward, blanks between cursor and the word are also removed.
inoremap <C-BS>   <Esc>dbs
" Remove 4 characters backward.
inoremap <C-S-BS> <BS><BS><BS><BS>

"-------------------------------------------------------------------------------
" Indentation styles.
" :h cino->
"-------------------------------------------------------------------------------
" Allman (ANSI) Style
" g0   : C++ public, protected, private are indented as class brace.
" N-1s : C++ namespace scope has no additional indent.
" E-1s : C++ extern scope has no additional indent.
set cino=>1s,e0,n0,f0,{0,}0,^0,L4,:0,=1s,l1,b0,g0,h1s,N-1s,E-s,p1s,t0,i1s,+1s,c3,C0,/0,(0,u0,U0,w0,W1s,m1,M0,j1,J1
"
" nnoremap <Leader><Leader>sa :set cino=>1s,e0,n0,f0,{0,}0,^0,L-1,:0,=1s,l1,b0,g0,h1s,N-1s,E-1s,p1s,t0,i1s,+1s,c3,C0,/0,(0,u0,U0,w0,W1s,m1,M0,j1,J1<CR>:set tabstop=4<CR>:set shiftwidth=4<CR>
"
" Whitesmith Style
" set cino=>1s,e0,n0,f1s,{1s,}0,^0,L-1,:0,=1s,l1,b0,g0,h1s,N-1s,p1s,t0,i1s,+1s,c3,C0,/0,(0,u0,U0,w0,W1s,m1,M0,j1,J1
"
" nnoremap <Leader><Leader>sw :set cino=>1s,e0,n0,f0,{0,}0,^0,L-1,:0,=1s,l1,b0,g0,h1s,N-1s,p1s,t0,i1s,+1s,c3,C0,/0,(0,u0,U0,w0,W1s,m1,M0,j1,J1<CR>:set tabstop=4<CR>:set shiftwidth=4<CR>
"
" GNU Style
" Manual: remove indents for braces of non-statement constructs
"         (namespace, struct, enum, class, function, ...)
" set cino=>2s,e-1s,n-1s,f0,{1s,}0,^-1s,L-1,:1s,=1s,l1,b0,g0,h1s,N-1s,p2s,t0,i1s,+1s,c3,C0,/0,(0,u0,U0,w0,W1s,m1,M0,j1,J1
"
" nnoremap <Leader><Leader>sg :set cino=>2s,e-1s,n-1s,f0,{1s,}0,^-1s,L-1,:1s,=1s,l1,b0,g0,h1s,N-1s,p2s,t0,i1s,+1s,c3,C0,/0,(0,u0,U0,w0,W1s,m1,M0,j1,J1<CR>:set tabstop=2<CR>:set shiftwidth=2<CR>

"-------------------------------------------------------------------------------
" doxygen highlighting
"-------------------------------------------------------------------------------
" Do not use the official doxygen syntax highlighting scheme.
let g:load_doxygen_syntax = 0
"
" Font for code.
" let g:doxy_code_font = 'Bitstream Vera Sans Mono'
"
" Use the new doxygen syntax highlighting scheme.
" Syntax highlighting for pure Doxygen files.
autocmd BufNewFile,BufRead *.doxygen setfiletype doxy
"
autocmd Syntax c,cpp,make,dosbatch
  \ if exists('b:current_syntax')
  \   | runtime! syntax/doxy.vim
  \ | endif

"-------------------------------------------------------------------------------
" jsonc highlighting
"-------------------------------------------------------------------------------
" JSON with C++ style comment.
autocmd FileType json syntax match Comment +/\/\.\+$+

highlight link jsonKeyword Identifier

"===============================================================================
" PLUGINS (managed by 'junegunn/vim-plug')
"===============================================================================
" 'plug.vim' shall be placed in '~/.vim/autoload/'.
" However, to automatically update 'plug.vim', one can put a symbolic link of
" 'plug.vim' in '~/.vim/autoload/'.
" mkdir ~/.vim/autoload
" ln -s ~/.vim/bundle/repos/vim-plug/plug.vim  ~/.vim/autoload
" let g:plug_threads = 3
call plug#begin(repos_path)
    " =========================
    " Plugin manager
    " =========================
    " A minimalist Vim plugin manager.
    " Comment: Simple, fast, yet powerful.
    "          Much faster than 'Shougo/dein.vim'.
    "          'Shougo/dein.vim' merges plugins into a single directory,
    "          thus the `rtp` is short and clean.
	"          Use `PlugUpgrade` to upgrade `vim-plug` itself.
    " Plug 'junegunn/vim-plug'
    "
    " =========================
    " Neovim on Vim
    " =========================
    if !has('nvim')
        " This is an experimental project, trying to build a compatibility layer for neovim rpc client working on vim8.
        Plug 'roxma/vim-hug-neovim-rpc'
        " Yet Another Remote Plugin Framework for Neovim.
        Plug 'roxma/nvim-yarp'
    endif
    "
    " =========================
    " LSP client
    " =========================
    " Intellisense engine for vim8 & neovim, full language server protocol support as VSCode.
    " Comment: Fully functional LSP client.
    "          Cache for each project.
    "          Starting from `v0.0.82`, coc.nvim uses custom popup menu.
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    " Plug 'neoclide/coc.nvim', { 'do': 'yarn install --frozen-lockfile' }
    " Extended Vim syntax highlighting for C and C++ (C++11/14/17/20).
    " Comment: Not ideal.
    "          e.g., strings are not recognized correctly in macro/function
    "          calls.
    "          Many highlightings has bad contrast/brightness.
    Plug 'bfrg/vim-cpp-modern'
    " Additional Vim syntax highlighting for C++ (including C++11/14/17).
    " Plug 'octol/vim-cpp-enhanced-highlight'
    " Print documents in echo area.
    " Comment: Replaced by coc.nvm.
    " Plug 'Shougo/echodoc'
    "
    " =========================
    " Snippet tools
    " =========================
    " The ultimate snippet solution for Vim. Send pull requests to SirVer/ultisnips!
    " Comment: Powerful, with interoperability with python and vim script.
    Plug 'SirVer/ultisnips'
    "
    " =========================
    " Highlighting
    " =========================
    " Highlight words and expressions
    Plug 'azabiong/vim-highlighter'
    " Highlight several words in different colors simultaneously.
    " Comment: The highest version just works.
    " Plug 'inkarkat/vim-mark', { 'commit': 'd9431b7cf5ddf1828035b45b7becd8a985d4311d' }
    " Comment: The newer versions depend upon a giganic library
    "          'inkarkat/vim-ingo-library' with a tiny dependency.
    " Plug 'inkarkat/vim-mark', { 'branch': 'stable' }
    " Comment: The standalone version has no dependencies.
    " Plug 'ayuanx/vim-mark-standalone', { 'tag': '3.0.0_standalone' }
    " Comment: Many functions are broken.
    " Plug 'fuzzier/vim-mark-standalone'
    " Word highlighting and navigation throughout out the buffer.
    " Comment: It is less versatile than 'vim-mark'.
    " Plug 'lfv89/vim-interestingwords'
    " Show syntax highlighting attributes of character under cursor.
    Plug 'vim-scripts/SyntaxAttr.vim'
    "
    " =========================
    " Indent guides
    " =========================
    " A Vim plugin for visually displaying indent levels in code.
    " Comment: The vertical lines are thick, but it works without many problems.
    Plug 'Boolean263/vim-indent-guides', { 'tag': '154-no-execute' }
    " A vim plugin to display the indention levels with thin vertical lines.
    " Comment: Display thin vertical lines embedded in the background, very
    "          calm and noise-free.
    "          However, it interferes with conceal settings, and pollutes
    "          concealed syntax items (concealed delimiters are no longer
    "          concealed and shown as indent guides).
    " Plug 'Yggdroot/indentLine'
    " Display a guide for the current line's indent level.
    " Comment: Dynamic indent guides, fancy, but the cursor have to be moved to
    "          the scope in order to display indent guides for that scope.
    "          Inconvenient for code reading.
    " Plug 'tweekmonster/local-indent.vim'
    if has('nvim')
        " The fastest Neovim colorizer.
        " Comment: Simple and fast, but only useful when working with colors
        "          alone, since it pollutes the highlightings of syntax items.
        Plug 'norcalli/nvim-colorizer.lua'
    endif
    "
    " =========================
    " Colorschemes
    " =========================
    " Top 100(ish) Themes, GUI Menu.
    " Plug 'vim-scripts/Colour-Sampler-Pack'
    " Colorsheme Scroller, Chooser, and Browser.
    " Plug 'vim-scripts/ScrollColors'
    " All 256 xterm colors with their RGB equivalents, right in Vim!
    Plug 'vim-scripts/xterm-color-table.vim'
    " Black and White cterm color scheme
    " Plug 'vim-scripts/bw.vim'
    "
    " =========================
    " General tools
    " =========================
    " A Vim plugin to move function arguments (and other delimited-by-something items) left and right.
    Plug 'AndrewRadev/sideways.vim'
    " Highlights trailing whitespace in red and provides :FixWhitespace to fix it.
    Plug 'bronson/vim-trailing-whitespace'
    " Vim plug for switching between companion source files (e.g. '.h' and '.cpp').
    Plug 'derekwyatt/vim-fswitch'
    " A plugin which makes swapping of text in Vim easier.
    " Comment: The original plugin has naming conflict with 'machakann/vim-swap'.
    "          As the plugin is no longer maintained by the original author,
    "          it is forked and renamed.
    " Plug 'kurkale6ka/vim-swap'
    Plug 'fuzzier/vim-swap-operands'
    " A Vim alignment plugin.
    Plug 'junegunn/vim-easy-align'
    " The missing motion for Vim 👟.
    " Comment: Override `s` key is overly intrusive, alters the meaning and
    "          habit of essential key strokes, and interferes other operations
    "          that use the hijacked keys.
    Plug 'justinmk/vim-sneak'
    " Speed up Vim by updating folds only when just.
    Plug 'Konfekt/FastFold'
    " Vim motions on speed!
    Plug 'Lokaltog/vim-easymotion'
    " A Vim text editor plugin to swap delimited items.
    Plug 'machakann/vim-swap'
    " Argumentative aids with manipulating and moving between function arguments.
    " Comment: Argument swapping scrolls and blinks the screen.
    " Plug 'PeterRincker/vim-argumentative'
    " Provides auto-balancing and some expansions for parens, quotes, etc.
    Plug 'Raimondi/delimitMate'
    " Mark quickfix & location list items with signs.
    Plug 'tomtom/quickfixsigns_vim'
    " An extensible & universal comment vim-plugin that also handles embedded filetypes.
    Plug 'tomtom/tcomment_vim'
    " Enable repeating supported plugin maps with '.'.
    Plug 'tpope/vim-repeat'
    " Defaults everyone can agree on.
    Plug 'tpope/vim-sensible'
    " Quoting/parenthesizing made simple.
    Plug 'tpope/vim-surround'
    " Pairs of handy bracket mappings.
    Plug 'tpope/vim-unimpaired'
    " Extended % matching for HTML, LaTeX, and many other languages.
    Plug 'vim-scripts/matchit.zip'
    " Replace text with the contents of a register.
    " Comment: `ya"` does not yank the surrounding blanks, good.
    Plug 'vim-scripts/ReplaceWithRegister'
    " Vim plugin that shows the context of the currently visible buffer contents
    Plug 'wellle/context.vim'
    " Vim plugin that provides additional text objects.
    Plug 'wellle/targets.vim'
    "
    " =========================
    " IDE like
    " =========================
    " Active fork of kien/ctrlp.vim—Fuzzy file, buffer, mru, tag, etc finder.
    " Comment: Unhandy.
    "          Have to use <C-j>, <C-k> to move around, an anti-VIM experience.
    " Plug 'ctrlpvim/ctrlp.vim'
    " 🌵 Viewer & Finder for LSP symbols and tags.
    " Comment: Unhandy.
    "          The icons are not visible.
    " Plug 'liuchengxu/vista.vim'
    " The fancy start screen for Vim.
    " Comment: Session and MRU management is quite handy.
    "          The header quotes is a sweet addition.
    Plug 'mhinz/vim-startify'
    " 🚀 Run Async Shell Commands in Vim 8.0 / NeoVim and Output to the Quickfix Window !!
    Plug 'skywind3000/asyncrun.vim'
    " 🚀 Modern Task System for Project Building, Testing and Deploying !!
    Plug 'skywind3000/asynctasks.vim'
    " Small changes make vim/nvim's internal terminal great again !!
    Plug 'skywind3000/vim-terminal-help'
    " A tree explorer plugin for vim.
    Plug 'scrooloose/nerdtree'
    " Buffer Explorer / Browser.
    Plug 'vim-scripts/bufexplorer.zip'
    " Plugin to manage Most Recently Used (MRU) files.
    " Comment: For linewise yank, the replacement is also linewise.
    Plug 'vim-scripts/mru.vim'
    " An efficient fuzzy finder that helps to locate files, buffers, mrus, gtags, etc. on the fly for both vim and neovim.
    Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
    "
    " =========================
    " Tag tools
    " =========================
    " A Vim plugin that manages your tag files.
    " Comment: Intra-file tag jumping is still useful.
    Plug 'ludovicchabant/vim-gutentags'
    " Vim plugin that displays tags in a window, ordered by scope.
    " Comment: Lighter and faster than language server.
    " Comment: It is quite annoying to auto-update tags upon file save.
    "          When there are a number of files to save, it hangs Vim.
    "          And the auto-update cannot be disabled!
    Plug 'preservim/tagbar'
    "
    " =========================
    " Git tools
    " =========================
    " A Vim plugin which shows git diff markers in the sign column and
    " stages/previews/undoes hunks and partial hunks.
    Plug 'airblade/vim-gitgutter'
    " A Git wrapper so awesome, it should be illegal.
    Plug 'tpope/vim-fugitive'
    " ➕ Show a diff using Vim its sign column.
    " Comment: since 'quickfixsigns_vim' is working.
    " Plug 'mhinz/vim-signify'
    "
    " =========================
    " C/C++ tools
    " =========================
    " C/C++ IDE -- Write and run programs. Insert statements, idioms, comments etc.
    " Comment: the complex mappings can be troublesome.
    "Plug 'vim-scripts/c.vim'
    " Simplify Doxygen documentation in C, C++, Python.
    Plug 'vim-scripts/DoxygenToolkit.vim'
call plug#end()

"===============================================================================
" VARIOUS PLUGIN CONFIGURATIONS
"===============================================================================

"=======================================
" LSP client
"=======================================
"---------------------------------------
" neoclide/coc.nvim
"---------------------------------------
" NOTE:
" If `nvim-qt` is used,
" `neovim/share/neovim-qt/runtime/plugin/nvim_gui_shim.vim` shall be removed!
"
" Configurations.
let g:coc_config_home = vimrc_path
let g:coc_data_home = vimrc_path . '/coc'
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
    hi def link CocHighlightText Pmenu
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

"=======================================
" Snippet tools
"=======================================
"---------------------------------------
" SirVer/ultisnips
"---------------------------------------
" Use python3.
let g:UltiSnipsUsePythonVersion = 3
"
" Disable snipmate snippets expansion.
let g:UltiSnipsEnableSnipMate = 0
"
" Shortcut keys.
let g:UltiSnipsExpandTrigger = '<Tab>'
let g:UltiSnipsListSnippets  = '<Leader><Tab>'
let g:UltiSnipsJumpForwardTrigger  = '<Tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
"
" Set private directories for snippets.
" Used by :UltiSnipsEdit command.
let g:UltiSnipsSnippetsDir = vimrc_path . '/fuzzier/UltiSnips'
"
" Set search directories for snippets.
" Used by :UltiSnipsEdit! command.
let g:UltiSnipsSnippetDirectories = [vimrc_path . '/fuzzier/UltiSnips']

"=======================================
" Highlighting
"=======================================
"---------------------------------------
" azabiong/vim-highlighter
"---------------------------------------
" Turn highlighting on or off using only the HiSet key.
let HiSetToggle = 1
" The directory to store highlight (*.hl) files.
let HiKeywords = vimrc_path . '/hl'
" Jump forward/backward highlights of the same pattern
nnoremap gj <Cmd>Hi><CR>
nnoremap gk <Cmd>Hi<<CR>
" Jump forward/backward the nearest highlights
nnoremap gl <Cmd>Hi}<CR>
nnoremap gh <Cmd>Hi{<CR>

"---------------------------------------
" ayuanx/vim-mark-standalone
" fuzzier/vim-mark-standalone
"---------------------------------------
" Disable default mapping.
" let g:mark_maps = 0
"
" Set hotkeys.
" nnoremap <silent> <Leader>m <Plug>MarkSet
" nnoremap <silent> <Leader>M <Plug>MarkAllClear
"
" 1. Jump to marked words; OR
" 2. Search.
" nnoremap <silent> n :<C-u>if ! mark#SearchCurrentMark(0)<Bar>execute 'normal! nzv'<Bar>endif<CR>
" nnoremap <silent> N :<C-u>if ! mark#SearchCurrentMark(1)<Bar>execute 'normal! Nzv'<Bar>endif<CR>
"
" 1. Search; OR
" 2. Mark.
" nnoremap <silent> * <Plug>MarkSearchNext
" nnoremap <silent> # <Plug>MarkSearchPrev

" --------------------------------------
" lfv89/vim-interestingwords
" --------------------------------------
" Disable default mapping.
" let g:interestingWordsDefaultMappings = 0
"
" Set hotkeys.
" nnoremap <silent> <Leader>m :call InterestingWords('n')<CR>
" vnoremap <silent> <Leader>m :call InterestingWords('v')<CR>
" nnoremap <silent> <Leader>M :call UncolorAllWords()<CR>
"
" Navigate highlighted word, works with VIM's search highlight.
" nnoremap <silent> n :call WordNavigation(1)<CR>
" nnoremap <silent> N :call WordNavigation(0)<CR>
"
" Randomise the colors.
" let g:interestingWordsRandomiseColors = 1
"
" Custom colors.
" let g:interestingWordsGUIColors = ['#8CCBEA', '#A4E57E', '#FFDB72', '#FF7272', '#FFB3FF', '#9999FF']
" let g:interestingWordsTermColors = ['Cyan', 'Green', 'Yellow', 'Red', 'Magenta', 'Blue']

" ======================================
" Indent guides
" ======================================
"---------------------------------------
" Boolean263/vim-indent-guides
"---------------------------------------
" Start automatically.
let g:indent_guides_enable_on_vim_startup = 1
"
" Disable for certain plugins.
let g:indent_guides_exclude_filetypes = [ 'help', 'nerdtree' ]
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

"---------------------------------------
" tweekmonster/local-indent.vim
"---------------------------------------
" Enable for file types.
" autocmd FileType c,cpp,py,json  LocalIndentGuide +hl +cc
"
" Set color.
" hi LocalIndentGuide ctermfg=8 ctermbg=0 cterm=inverse

"---------------------------------------
" Yggdroot/indentLine
"---------------------------------------
" Use custom colors.
" let g:indentLine_color_term = 22
" let g:indentLine_color_gui = '#005F00'
"
" Do not change conceal options.
" let g:indentLine_setConceal = 0

"---------------------------------------
" norcalli/nvim-colorizer.lua
"---------------------------------------
" lua require 'colorizer'.setup()

"=======================================
" Colorschemes
"=======================================

"=======================================
" General tools
"=======================================
"---------------------------------------
" AndrewRadev/sideways.vim
"---------------------------------------
nnoremap <silent> g< :SidewaysLeft<CR>
nnoremap <silent> g> :SidewaysRight<CR>
"
"---------------------------------------
" kurkale6ka/vim-swap
" fuzzier/vim-swap-operands
"---------------------------------------
let g:swap_operands_no_default_key_mappings = 1
"
" Swap operands
xnoremap <silent> <Leader>so <Plug>SwapSwapOperands

" Swap operands interactively
xnoremap <silent> <Leader>si <Plug>SwapSwapPivotOperands
"
"---------------------------------------
" bronson/vim-trailing-whitespace
"---------------------------------------
" Set hotkey.
nnoremap <silent> <Leader>fw :FixWhitespace<CR>

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

"---------------------------------------
" junegunn/vim-easy-align
"---------------------------------------
" Set hotkeys.
nmap <silent> ga <Plug>(EasyAlign)
xmap <silent> ga <Plug>(EasyAlign)
"
" '/': Align C++-style comment.
" 'c': Align backslash (line continuity).
let g:easy_align_delimiters = {
    \  '/': { 'pattern'        : '/[/*]\+<\{,1}',
    \         'delimiter_align': 'l',
    \         'ignore_groups'  : [] },
    \
    \  'c': { 'pattern'        : '\\',
    \         'delimiter_align': 'l',
    \         'left_margin'    : ' ' }
    \ }

"---------------------------------------
" justinmk/vim-sneak
"---------------------------------------
" Use label-mode to jump fast.
let g:sneak#label = 1
"
highlight link Sneak      Search
highlight link SneakScope Visual
highlight link SneakLabel Search

"---------------------------------------
" machakann/vim-swap
"---------------------------------------

"---------------------------------------
" tomtom/quickfixsigns_vim
"---------------------------------------
" Enable several classes.
let g:quickfixsigns_classes = [ 'qfl', 'marks', 'vcsdiff', 'breakpoints' ]

"---------------------------------------
" tomtom/tcomment_vim
"---------------------------------------
" Disable default maps.
let g:tcomment_maps = 0
" let g:tcomment_mapleader1 = ''
" let g:tcomment_mapleader2 = ''
" let g:tcomment_opleader1 = ''
" let g:tcomment_mapleader_uncomment_anyway = ''
" let g:tcomment_mapleader_comment_anyway = ''
"
" Toggle comment via motion.
nmap <silent> gc  <Plug>TComment_gc
xmap <silent> gc  <Plug>TComment_gc
" Toggle comment for current line.
nmap <silent> gcc <Plug>TComment_gcc

"---------------------------------------
" wellle/context.vim
"---------------------------------------
let g:context_enabled = 1
let g:context_max_height = 5
let g:context_max_join_parts = 5

"=======================================
" IDE like
"=======================================
"---------------------------------------
" skywind3000/asyncrun.vim
"---------------------------------------
" Open quickfix window at given height after command starts.
let g:asyncrun_open = 6
" Save current(1) or all(2) modified buffer(s) before executing.
let g:asyncrun_save = 2
" Ring a bell after finished.
let g:asyncrun_bell = 1

"---------------------------------------
" skywind3000/vim-terminal-help
"---------------------------------------
" Disable default mappings.
" * 'termwinkey' remains unchanged.
let g:terminal_default_mapping = 0
" The key to toggle terminal window.
let g:terminal_key = '<Leader>to'
" Initialize working dir: 0 for unchanged, 1 for file path and 2 for project root.
let g:terminal_cwd = 2
" Set to 'term' to kill term session when exiting vim.
let g:terminal_kill = 'term'
" Set to 1 to close window if process finished.
let g:terminal_close = 1

"---------------------------------------
" ctrlpvim/ctrlp.vim
"---------------------------------------
" let g:ctrlp_cache_dir = bundle_path . '/.cache/ctrlp'

"---------------------------------------
" mhinz/vim-startify
"---------------------------------------
let g:startify_session_dir = vimrc_path . '/session'
"
" Automatically update sessions.
let g:startify_session_persistence = 1

"---------------------------------------
" scrooloose/nerdtree
"---------------------------------------
" Set hotkey to toggle taglist window
nnoremap <silent> <Leader>tt  :NERDTreeToggle<CR>
"
" Put NERD tree at the right side of the window.
let g:NERDTreeWinPos = "right"
"
" Closes the tree window after opening a file.
let g:NERDTreeQuitOnOpen = 1
"
" Files to ignore (list of regular expressions).
let g:NERDTreeIgnore = ['\.\%(obj\|pdb\|exp\|ilk\|lib\|dll\|exe\)$']

"---------------------------------------
" vim-scripts/bufexplorer.zip
"---------------------------------------
" Enable default key mapping.
let g:bufExplorerDisableDefaultKeyMapping = 0
"
" Split new window above current.
let g:bufExplorerSplitBelow = 0
"
" Split right.
let g:bufExplorerSplitRight = 1

"---------------------------------------
" vim-scripts/mru.vim
"---------------------------------------
" Remove :MANPAGER.
" :M<Tab> expands directly to :MRU
if !has('nvim')
    autocmd VimEnter * if exists(":MANPAGER") | delcommand MANPAGER | endif
endif

"---------------------------------------
" Yggdroot/LeaderF
"---------------------------------------
" Use Python 3.
let g:Lf_PythonVersion = 3
" Path to ctag.
if has('win32')
    let g:Lf_Ctags = vimrc_path . '/ctags/uctags.exe'
endif
" Do not generate tags.
let g:Lf_GtagsAutoGenerate = 0
" Do not update tags.
let g:Lf_GtagsAutoUpdate = 0
" Use gutentags.
let g:Lf_GtagsGutentags = 1
" Root path to tag files, the tag files are put under 'LeaderF/gtags/'.
let g:Lf_CacheDirectory = vimrc_path
" Search file from the root path.
" * Find root markers in ancestor directories.
" * Fallback to current directory.
let g:Lf_WorkingDirectoryMode = 'Ac'
" Root markers.
let g:Lf_RootMarkers = ['.ccls', '.git']
" Use [0-9] to select entry.
let g:Lf_QuickSelect = 0
"
" Use the following command to check whether C module is loaded.
" echo g:Lf_fuzzyMatch_C
"
" Disable default key mappings.
let g:Lf_ShortcutF = ''
let g:Lf_ShortcutB = ''
"
" Define custom key mappings.
nnoremap <silent> <Leader>ff  :LeaderfFile<CR>
nnoremap <silent> <Leader>fm  :LeaderfMru<CR>
nnoremap <silent> <Leader>fn  :LeaderfFunction<CR>
nnoremap <silent> <Leader>fan :LeaderfFunctionAll<CR>
nnoremap <silent> <Leader>ft  :LeaderfBufTag<CR>
nnoremap <silent> <Leader>fat :LeaderfBufTagAll<CR>
nnoremap <silent> <Leader>fl  :LeaderfLine<CR>
nnoremap <silent> <Leader>fal :LeaderfLineAll<CR>
"
" Customize command inside LeaderF's prompt.
" <C-K>    => <Up>     : navigate the next result list.
" <C-J>    => <Down>   : navigate the prev result list.
" <Up>     => <C-Up>   : recall prev input history.
" <Down>   => <C-Down> : recall next input history.
" <C-Up>   => <C-K>    : scroll up in the popup preview window.
" <C-Down> => <C-J>    : scroll down in the popup preview window.
let g:Lf_CommandMap = {
    \ '<C-K>':    ['<Up>'],
    \ '<C-J>':    ['<Down>'],
    \ '<Up>':     ['<C-Up>'],
    \ '<Down>':   ['<C-Down>'],
    \ '<C-Up>':   ['<C-K>'],
    \ '<C-Down>': ['<C-J>'],
    \ }

"=======================================
" Tag tools
"=======================================
"---------------------------------------
" ludovicchabant/vim-gutentags
"---------------------------------------
let g:gutentags_enabled = 1
"
" Set the cache directory for tags.
let g:gutentags_cache_dir = expand(g:Lf_CacheDirectory.'/LeaderF/gtags')
"
let g:gutentags_ctags_extra_args = [
    \ '-I BOOST_NOEXCEPT,BOOST_CONSTEXPR,NSFX_NOEXCEPT,NSFX_OVERRIDE,NSFX_FINAL'
    \ ]
"
let g:gutentags_ctags_exclude = [ '.ccls-cache' ]
"
if has('win32')
    let g:gutentags_ctags_executable = vimrc_path . '/ctags/uctags.exe'
endif
"
let g:gutentags_ctags_extra_args = [
    \ '--extra=+q',
    \ '--fields=+ainSz',
    \ '--c-kinds=+px',
    \ '--c++-kinds=+px'
    \ ]
"
let g:gutentags_exclude_filetypes = [
    \ 'vim',
    \ 'snippets',
    \ 'fugitive', 'gitcommit'
    \ ]

"---------------------------------------
" preservim/tagbar
"---------------------------------------
" Set hotkey to toggle taglist window
nnoremap <silent> <F11>  :TagbarToggle<CR>
"
if has('win32')
    let g:tagbar_ctags_bin = vimrc_path . '/ctags/uctags.exe'
endif
"
let g:tagbar_autofocus = 1
"
let g:tagbar_autoclose = 1
"
" Do not echo tag information in status line.
let g:tagbar_silent = 0
"
" Do not sort by name.
let g:tagbar_sort = 0
" Show absolute line numbers.
let g:tagbar_show_linenumbers = 1
"
" let g:tagbar_iconchars = ['+', '-']
"
" Do no generate tags upon file save.
let g:tagbar_no_autocmds = 1
"
" Prevent tagbar from using python to launch 'ctags'.
" There is a bug that the launching will fail with error code `129`.
" Fallback to call `system()` to launch 'ctags'.
let g:tagbar_python = 0
"
" let g:tagbar_type_cpp = {
"     \ 'ctagsargs' : [
"     \ '--extra=+f',
"     \ '-f', '-',
"     \ '--format=2',
"     \ '--excmd=pattern',
"     \ '--fields=nksSafet',
"     \ '--sort=no',
"     \ '--append=no',
"     \ '-V',
"     \ '--language-force=c++',
"     \ '--c++-kinds=hdpgetncsufmv',
"     \ '--file-scope=yes',
"     \ '-I', 'BOOST_NOEXCEPT,BOOST_CONSTEXPR,NSFX_OVERRIDE,NSFX_FINAL'
"     \ ]}
"
nnoremap <silent> <Leader>tg  :Tagbar<CR>

"---------------------------------------
" airblade/vim-gitgutter
"---------------------------------------
" Turn off signs, which interferes with `quickfixsigns_vim`.
let g:gitgutter_signs = 0

"---------------------------------------
" tpope/vim-fugitive
"---------------------------------------
" Reopen summary window
command! -nargs=* GG :execute "normal gq" | :Git

" Git log pretty format
" @see https://coderwall.com/p/euwpig/a-better-git-log
" command! GL  :Git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s' --abbrev-commit --all
command! -nargs=* GL :execute "normal gq"
         \| :Git log --graph
         \  --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s'
         \  --abbrev-commit --all <args>

" Git blame a range of codes
" * -s: without author and date.
command! -range=% GB <line1>,<line2>:Git blame -s

"---------------------------------------
" mhinz/vim-sigify
"---------------------------------------

"---------------------------------------
" vim-scripts/DoxygenToolkit.vim
"---------------------------------------
let g:DoxygenToolkit_paramTag_pre = '@param[in] '

"---------------------------------------
" Netrw
"---------------------------------------
" Disable Netrw.
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

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
    if a:line =~ '^\s*[_a-zA-Z][_0-9a-zA-Z]*\s*::\@!'
        if a:line !~# '^\s*\(public\|protected\|private\|default\)\s*:'
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
    " cline shall indent here
    " |
    " v
    " xxx ...            <= pline
    " {                  <= cline
    "
    if cline =~ '^\s*{'
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
    " cline shall indent here
    " |
    " v
    " NSFX_OPEN_NAMESPACE
    " ...                  <= cline
    " NSFX_CLOSE_NAMESPACE
    " ...                  <= cline
    "
    elseif pline =~# '^\s*NSFX\k\+NAMESPACE'
        let retv = stridx(pline, 'NSFX')
        " echom 'after NSFX namespace declaration: ' . retv
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

"===============================================================================
" Coding functions
"===============================================================================
"
" Source visually selected codes.
xmap <Leader>sc  y:@"<CR>
"
" Remove trailing whitespaces
nnoremap <Leader>w  :noh<CR>:wall<CR>

" Delete C/C++ style comments.
" function! DeleteComments()
"     let @"=substitute(@", '^\_s*\/\*\_.\{-}\*\/\n', '', 'g')
"     let @"=substitute(@", '^\_s*\/\/.*\n', '', 'g')
" endfunction
" xnoremap <Leader>dc  y:<C-u>call DeleteComments()<CR>p
" nnoremap <Leader>dc  gvy:<C-u>call DeleteComments()<CR>p

function! AssignHotkeys()
    let __ss = ':noh<CR>'
    " Remove comments.
    let __s1 = ':s/^\_s*\(\/\*\_.\{-}\*\/\\|\/\/.*\)\n//ge<CR>'
    exe 'xnoremap <Leader>dc    ' . __s1 . __ss
    exe 'nnoremap <Leader>dc  gv' . __s1 . __ss
    "
    " Replace '= 0' into 'override'
    let __s1 = ':s/\s*=\s*0;/ override;/ge<CR>'
    exe 'xnoremap <Leader>d0    ' . __s1 . __ss
    exe 'nnoremap <Leader>d0  gv' . __s1 . __ss
    "
    " Replace '= 0' into 'override { }'
    let __s1 = ':s/\s*=\s*0;/ override\r{\r}\r/ge<CR>'
    let __s2 = 'gv}='
    exe 'xnoremap <Leader>do    ' . __s1 . __s2 . __ss
    exe 'nnoremap <Leader>do  gv' . __s1 . __s2 . __ss
endfunction
call AssignHotkeys()

function! CopyClassName()
    " class|struct Xxx
    " * not preceded by any other keywords (e.g., 'friend')
    " * not followed by ';'
    let cline_num = line('.')
    while cline_num != 0
        let cline = getline(cline_num)
        " class/struct declaration
        let pattern = '^\(class\|struct\)\s\+\zs\(\k\|:\)\+\ze\;\@!'
        let class_name = cline->matchstr(pattern)
        if class_name != ''
            break
        endif
        " ctor/dtor definition
        "              leading spaces (as few as possible)
        "                         keywords and :
        "                                    ::
        "                                      tild (if any)
        let pattern = '^\(\zs\(\k\|:\)\+\ze\)::\~\?\1('
        let class_name = cline->matchstr(pattern)
        if class_name != ''
            break
        endif
        " member function definition
        "              leading spaces (as few as possible)
        "                         keywords and :
        "                                       ::
        let pattern = '^\S.\{-}\zs\(\k\|:\)\+\ze::.*('
        let class_name = cline->matchstr(pattern)
        if class_name != ''
            break
        endif
        let cline_num = cline_num - 1
    endwhile
    if class_name != ''
        echo class_name
        " If the class name looks like 'Xxx::Yyy'
        if class_name =~ '::'
            " Remove qualifiers, e.g., remove 'Xxx::', and keep the last 'Yyy'
            let class_name = class_name->matchstr('\k\+$')
        endif
        call setreg('c', class_name)
    endif
endfunction
nnoremap <Leader><Leader>c  :call CopyClassName()<CR>

function! ToggleNsfxLikely()
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
    silent! call repeat#set(":call ToggleNsfxLikely()\<CR>")
endfunction
nnoremap <Leader><Leader>n  :call ToggleNsfxLikely()<CR>

function! ToggleLogicalNot()
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
    silent! call repeat#set(":call ToggleLogicalNot()\<CR>")
endfunction
nnoremap <Leader>n  :call ToggleLogicalNot()<CR>

" function! Test()
"     echo strftime('%H:%M:%S')
"     silent! call repeat#set(":call Test()\")
" endfunction
" nnoremap <silent> <Plug>MyTest :<C-U>call Test()<CR>
" nmap zz <Plug>MyTest

"===============================================================================
" Coding macros
"===============================================================================
"
"----------------------------------------
" Convert class member function declaration to definition.
" @precondition: yank class name into register 'c'
" disable highlighting search.
" :set nohls
" find '(', select lines til ')',
" 0/(     v/)V
" remove 'explicit', 'static', 'friend', 'virtual', '= 0' and 'final' and 'override',
" :s/\s*\(explicit\|friend\|static\|virtual\|=\s*0\|final\|override\)\s*//ge
" replace two or more spaces into one space,
" :s/\s\{2,\}/ /ge
" find back '(', visual the line
" /)?(       V
" find the function name in the current visual area before '('
"       operator\s*\S\+(
"       \~\?\k\+\s*(
" /\%V\(operator[^(]*\|\k+[^(]*\)\ze(
" paste from register 'c', add '::',
" "cP                      a::
" find back '(', select lines til ')', auto indent, move to start of line
" /)?(       v/)V                =            0
" find ')', remove ';', add '{}',
" /)      :s/;//e   o{}iA
" leave only 1 blank line by replacing 2+ blank lines that are not followed by
" 'NSFX', '}' (end of namespace), // (comments) with 1 blank line,
"              NSFX
"                    }
"                       //
" :s/\n\{2,\}\(NSFX\|}\|\/\{2,\}\)\@!/\r/ge
" enable highlight search.
" :set hls
" no highlight.
" :noh
" let @z=':set nohls\'
"     \ .'0/(\v/)\V'
"     \ .':s/\s*\(explicit\|friend\|static\|virtual\|=\s*0\|final\|override\)\s*//ge\'
"     \ .':s/\s\{2,\}/ /ge\'
"     \ .'/)\?(\V'
"     \ .'/\%V\(operator\s*\S\+\|\~\?\k\+\s*\)\ze(\'
"     \ .'"cPa::'
"     \ .'/)\?(\v/)\V=0'
"     \ .'/)\:s/;//e\o{}i\A\'
"     \ .':s/\n\{0,\}\(NSFX\|}\|\/\{2,\}\)\@=/\r\r/ge\'
"     \ .':s/\n\{2,\}\(NSFX\|}\|\/\{2,\}\)\@!/\r/ge\'
"     \ .':set hls\'
"     \ .':noh\'

function! CppDefineMemberFunction()
    let cline_num = line('.')
    let cline = getline(cline_num)
    """"""""""""""""""""
    " `cline` is blank or comment or access control
    while 1
        "                   ( / / | / * | * ).*
        if cline =~  '^\s*\(\(\/\/\|\/\*\|\*\).*\)*$' ||
         \ cline =~# '^\s*\(public\|protected\|private\)\>'
            " Delete current line into black hole register
            silent :execute 'normal! "_dd'
            " If no more lines to delete (the last line has been deleted)
            if cline_num != line('.')
                return
            endif
            let cline = getline(cline_num)
        else
            break
        endif
    endwhile
    """"""""""""""""""""
    " Find left parenthesis '(', move cursor
    call cursor(cline_num, 1)
    let cline_num = search('(')
    if !cline_num
        return
    endif
    " Find right parenthesis ')', do not move cursor
    let rline_num = search(')', 'n')
    if !rline_num
        return
    endif
    """"""""""""""""""""
    " Remove declarative words
    let cline = getline(cline_num)
    let cline = substitute(cline, '\s*\(explicit\|friend\|static\|virtual\|final\|override\|=\s*0\)\>\s*', '', 'g')
    " Extract the function name that is followed by '('
    "                                 operator   ...  | ~  xxx        (
    let funcname = matchstr(cline, '\(operator\s*\S\+\|\~\?\k\+\)\(\s*(\)\@=')
    " If current line does not match pattern
    if empty(funcname)
        return
    endif
    " Add scope name from register "c and '::'
    let qualname = getreg('c') . '::' . funcname
    " Update current line
    "                                operator   ...  | ~  xxx        (
    let cline = substitute(cline, '\(operator\s*\S\+\|\~\?\k\+\)\(\s*(\)\@=', qualname, '')
    call setline(cline_num, cline)
    """"""""""""""""""""
    " Find comma ';', do not move cursor, do not wrap around
    let nline_num = search(';', 'nW')
    if nline_num
        " Remove comma ';'
        let nline = getline(nline_num)
        let nline = substitute(nline, ';', '', '')
        call setline(nline_num, nline)
    else
        " Fallback to the line of right parenthesis ')'
        let nline_num = rline_num
    endif
    """"""""""""""""""""
    " Insert braces
    call append(nline_num, ['{', '}'])
    " (   < cline_num
    " ...
    " }   <= nline_num
    let nline_num = nline_num + 2
    """"""""""""""""""""
    " Indent from function name to braces
    " silent :execute 'normal! =' . (nline_num - cline_num) . 'j'
    silent :execute 'normal! =ap'
    " Move cursor to inserted '}'
    " } <= cline_num, nline_num
    let cline_num = nline_num
    call cursor([cline_num, 0])
    """"""""""""""""""""
    " Ensure empty lines
    let num_empty = 0
    " } <= cline_num, nline_num
    let nline_num = cline_num
    if nline_num == line('$')
        call append(cline_num, ['', ''])
        " }   <= cline_num
        "
        "     <= nline_num (last line)
        let nline_num = nline_num + 2
    else
        " }   <= cline_num
        " ... <= nline_num
        let nline_num = nline_num + 1
        let nline = getline(nline_num)
        if !empty(nline)
            " Add a blank line after '}'
            call append(cline_num, [''])
        endif
        " }   <= cline_num
        "
        " ... <= nline_num
        let nline_num = nline_num + 1
        let nline = getline(nline_num)
        " Add another blank line before 'NSFX_...' or '//' or '}'
        if nline =~# '\s*\(NSFX\|//\|}\)'
            call append(cline_num, [''])
            " }   <= cline_num
            "
            "
            " ... <= nline_num ('NSFX_...' or '//' or '}')
            let nline_num = nline_num + 1
        endif
    endif
    let cline_num = nline_num
    call cursor([nline_num, 0])
    """"""""""""""""""""
    " Ensure spaces
    " Allow repeat by '.'
    silent! call repeat#set(":call CppDefineMemberFunction()\<CR>")
endfunction

let @z=':call CppDefineMemberFunction()'

"----------------------------------------
" Property definition to initialization list.
" 'size_t count_;' => 'count_(count),'
" find ';', word back, delete type til first character in line,
" 0/;     b          d^
" add comma ', ',
" i,w
" yank 'xxx_', move to end of 'xxx_',
" yw           e
" add '()', paste 'xxx_', remove '_' and ';'
" a(      p             x           lx
" select line, auto indent
" V            =
" leave no blank lines by replacing 2+ blank lines with 1 blank line,
" :s/\n\{2,\}/\r/ge
" no highlighting.
" :noh
" let @y='0/;\bd^'
"     \ .'i,w'
"     \ .'ywe'
"     \ .'a(pxlx'
"     \ .'V='
"     \ .':s/\n\{2,\}/\r/ge\'
"     \ .':noh\'

"----------------------------------------
" Property definition to initialization list.
" 'Message* msg_;' => 'msg_(nullptr),'
" find ';', word back, delete type til first character in line,
" 0/;     b          d^
" add comma ', ',
" i,w
" yank 'xxx_', move to end of 'xxx_',
" yw           e
" add '()', put 'nullptr', remove ';'
" a(        nullptr      f;x
" select line, auto indent
" V            =
" leave no blank lines by replacing 2+ blank lines with 1 blank line,
" :s/\n\{2,\}/\r/ge
" no highlighting.
" :noh
" let @x='0/;\bd^'
"     \ .'i,w'
"     \ .'ywe'
"     \ .'a(nullptrf;x'
"     \ .'V='
"     \ .':s/\n\{2,\}/\r/ge\'
"     \ .':noh\'

function! CppDefinitionToInitializationList(type)
    " a:type
    " * '': default
    " * 'v': use variable name
    "
    " Convert
    "   'Message* msg_;' OR
    "   'Message* msg_[];'
    " To
    "   ': msg_()' OR
    "   ', msg_{}'
    "
    let l:cline_num = line('.')
    let l:cline = getline(l:cline_num)
    " `l:cline` is blank or comment
    "                      ( / / | / * | * ).*
    while l:cline =~ '^\s*\(\(\/\/\|\/\*\|\*\).*\)*$'
        " Delete current line into black hole register
        silent :execute 'normal! "_dd'
        " If no more lines to delete (the last line has been deleted)
        if l:cline_num != line('.')
            return
        endif
        let l:cline = getline(l:cline_num)
    endwhile
    " Extract the variable name that is followed by ';'
    let l:varname = matchstr(l:cline, '\k\+\(\[.*\]\)\?;\@=')
    " If current line does not match pattern
    if empty(l:varname)
        return
    endif
    let l:varname = matchstr(l:cline, '\k\+;\@=')
    let l:isArray = 0
    if empty(l:varname)
        let l:varname = matchstr(l:cline, '\k\+\[\@=')
        let l:isArray = 1
    endif
    let l:valname = substitute(l:varname, '_$', '', '')
    " Extract the type name that is followed by the variable name.
    let l:typename = matchstr(l:cline, '\S\+\%(\s\+\S\+;\)\@=')
    echom l:typename
    let l:isPointer = 0
    let l:isNumeric = 0
    let l:isBoolean = 0
    let l:isDefCtor = 0
    if l:typename =~ '\*'
        let l:isPointer = 1
    elseif l:typename =~# 'unique_ptr\|shared_ptr\|weak_ptr\|intrusive_ptr'
        let l:isPointer = 1
    elseif l:typename =~# 'unsigned\|int\d*_t\|size_t\|float\|double\|addr_t\|csn\d\+_t'
        let l:isNumeric = 1
    elseif l:typename =~# 'bool'
        let l:isBoolean = 1
    elseif l:typename =~# 'simtime_t\|Vec\|List\|Set\|Map\|Tree\c'
        let l:isDefCtor = 1
    endif
    "
    let l:pline_num = prevnonblank(l:cline_num-1)
    let l:pline = getline(l:pline_num)
    " Xxx()
    "     : ...      <= pline (not '::'), OR
    "     , ...      <= pline
    " If `pline` starts with ':' or ','
    " echom l:pline
    if l:pline =~ '^\s*\(::\@!\|,\)'
        let l:delim = ', '
    else
        let l:delim = ': '
    endif
    " Build statement
    let l:stmt = l:delim . l:varname
    if a:type =~# 'v'
        let l:stmt = l:stmt . '{' . l:valname . '}'
    else
        if l:isArray
            let l:stmt = l:stmt . '{} // Fill 0'
        elseif l:isPointer
            let l:stmt = l:stmt . '{nullptr}'
        elseif l:isNumeric
            let l:stmt = l:stmt . '{0}'
        elseif l:isBoolean
            let l:stmt = l:stmt . '{false}'
        elseif l:isDefCtor
            let l:stmt = l:stmt . '{}'
        else
            let l:stmt = l:stmt . '{' . l:valname . '}'
        endif
    endif
    call setline(l:cline_num, l:stmt)
    " Auto indent.
    exec 'normal =='
    " Move cursor to the next line
    call cursor([l:cline_num + 1, 0])
    " Allow repeat by '.'
    silent! call repeat#set(":call CppDefinitionToInitializationList()\<CR>")
endfunction

let @x=':call CppDefinitionToInitializationList("")'
let @y=':call CppDefinitionToInitializationList("v")'

"----------------------------------------
" Replace '= 0;' to 'override;'
let @p='0/):s/\(override\s\*\)\@<!= 0/override/ej:noh'

"----------------------------------------
" Override a virtual function inplace.
" find '(', select lines til ')',
" 0/(     v/)V
" replace '= 0;' with 'override',
" :s/\s*=\s*0\s*;/ override;/e
" find back '(', select lines til ')', auto indent,
" /)?(       v/)V                =
" find ')', remove ';', add '{}',
" /)      :s/;//e   o{}ia
" leave only 1 blank line by replacing 2+ blank lines with 1 blank line
" :s/\n\{2,\}/\r/ge
" no highlighting.
" :noh
let @o='0/(v/)V'
    \ .':s/\s*=\s*0\s*;/ override;/e'
    \ .'/)?(v/)V='
    \ .'/):s/;//eo{}iA'
    \ .':s/\n\{2,\}/\r/ge'
    \ .':noh'

"----------------------------------------
" Inline function definition
function! CppInlineFunctionDefinition()
    let cline_num = line('.')
    call cursor(cline_num, 1)
    " Find ';'
    " * Move cursor
    " * Do not wrap around
    let line_num = search(';', 'W')
    " If ';' is not found
    if line_num == 0
        return
    endif
    " The next line
    let nline_num = line_num + 1
    let nline = getline(nline_num)
    " If the next line is not blank
    if nline !~ '^\s*$'
        call append(line_num, '')
    endif
    " Remove ';' to the end of the line
    " Insert newline
    " Insert '{'      <--
    " Insert newline    |
    " Insert '}'        |
    " Move cursor up  ---
    execute 'normal! C{}'
    execute 'normal! k'
    " Allow repeat by '.'
    silent! call repeat#set(":call CppInlineFunctionDefinition()\<CR>")
endfunction

let @d=':call CppInlineFunctionDefinition()'

"----------------------------------------
" Copy assign variable
" Convert
"   'o->xxx_'
" To
"   'o->xxx_ = xxx_;'
function! CppCopyAssignVariable()
    let cline_num = line('.')
    let line = getline(cline_num)
    " If there are trailing whitespaces
    " 'o->xxx '
    "        ^
    if line =~ '\s\+$'
        " Remove trailing whitespaces
        let line = substitute(line, '\s\+$', '')
        call setline(cline_num, line)
    endif
    " If there is no ending ';'
    " 'o->xxx'
    "        ^
    if line !~ ';'
        " Append ';'
        " 'o->xxx;'
        "        ^
        execute 'normal! A;'
    endif
    " Move to the end of the word
    " 'o->xxx = yyy;'
    "       ^
    execute 'normal! ^E'
    " Move to the start of the word
    " * From current cursor
    " * Backward
    " * Do not wrap around
    " 'o->xxx;'
    "     ^
    call search('\<\w', 'cbW')
    " Copy the word
    " 'o->xxx = yyy;'
    "       ^
    execute 'normal! yiw'
    " move to the end of the word
    " * From current cursor
    " * Do not wrap around
    call search('\w\>', 'cW')
    " If there is no has '='
    " 'o->xxx;'
    "       ^
    if line !~ '='
        " Append ' = '
        " 'o->xxx = ;'
        "          ^
        execute 'normal! a = '
        " Put the word
        " 'o->xxx = xxx;'
        "             ^
        execute 'normal! p'
    " Else, there is '='
    else
        " Move to ';'
        " * From current cursor
        " 'o->xxx = yyy;'
        "              ^
        call search(';', 'c')
        let line = getline(cline_num)
        " If there is a word between '=' and ';'
        " 'o->xxx = yyy;'
        "              ^
        if line =~ '=.*\w\+.*;'
            " Move to the end of the word
            " 'xxx = yyy;'
            "          ^
            execute 'normal! ge'
            " Visual the word
            " 'xxx = yyy;'
            "        ^^^
            execute 'normal! viw'
            " Put word
            " 'xxx = xxx;'
            "          ^
            execute 'normal! p'
        " If there is no word between '=' and ';'
        " 'o->xxx = ;'
        "           ^
        else
            " Put word
            " 'xxx = xxx;'
            "          ^
            execute 'normal! P'
        endif
        " Move the start of the word
        execute 'normal! f;b'
        " Move down
        execute 'normal! j'
    endif
    " Allow repeat by '.'
    silent! call repeat#set(":call CppCopyAssignVariable()\<CR>")
endfunction

let @a=':call CppCopyAssignVariable()'

"----------------------------------------
" Remove til '*/'.
" find '/',
" /\/
" move to the blank line before the paragraph (paragraph forward, paragraph back),
" }{
" one line down, select lines til '*/', delete
" j              v/\*\/V              d
" no highlighting.
" :noh
let @c='/\/'
    \ .'}{'
    \ .'jv/\*\/Vd'
    \ .':noh'

"----------------------------------------
" Add 'inline'.
" find '('
" /(
" move to the first column
" 0
" insert 'inline'
" iinline 
" find '{'
" /{
" find the pairing '}'
" %
" move to the blank link before the next paragraph
" }
" no highlighting
" :noh
let @h='/(0iinline /{%}:noh'

"----------------------------------------
function! CppRemoveComments()
    " Move the the first column
    exe 'normal! 0'
    let l:stopline = line('.') + 10
    " Search for comments
    " * from current curror
    " * do not wrap around
    "                            / /
    let l:line_num = search('\s*\/\/', 'cW', l:stopline)
    if l:line_num
        " Remove the comment
        exec 'normal! D'
    endif
    " Allow repeat by '.'
    silent! call repeat#set(":call CppRemoveComments()\<CR>")
endfunction

noremap <Leader>xd :call CppRemoveComments()<CR>

"----------------------------------------
function! GetVisualLines()
    let l:lines = []
    if 'V' ==# visualmode() || 'v' ==# visualmode()
        " Obtain selected string
        let l:start = getpos("'<")
        let l:end   = getpos("'>")
        let l:lines = getline(l:start[1], l:end[1])
        //
        if len(l:lines) == 1
            let l:lines[0] = l:lines[0][l:start[2] - 1 : l:end[2] - 1]
        else
            let l:lines[0]  = l:lines[0][l:start[2] - 1 :]
            let l:lines[-1] = l:lines[-1][: l:end[2] - 1]
        endif
    endif
    return l:lines
endfunction

"===============================================================================
" Tags search paths.
"===============================================================================
" set tags+=../../../tag
" set tags+=../../tag
" set tags+=../tags

"===============================================================================
unlet backup_path
unlet swap_path
unlet undo_path
unlet bundle_path
unlet vimrc_path

