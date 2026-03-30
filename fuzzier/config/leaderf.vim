""
" @file LeaderF settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"---------------------------------------
" Yggdroot/LeaderF
"---------------------------------------
" Use Python 3.
let g:Lf_PythonVersion = 3
" Path to ctag.
if has('win32')
    let g:Lf_Ctags = g:vimrc_path . '/ctags/uctags.exe'
endif
" Do not generate tags.
let g:Lf_GtagsAutoGenerate = 0
" Do not update tags.
let g:Lf_GtagsAutoUpdate = 0
" Use gutentags.
let g:Lf_GtagsGutentags = 1
" Root path to tag files, the tag files are put under 'LeaderF/gtags/'.
let g:Lf_CacheDirectory = g:vimrc_path
" Search file from the root path.
" * Find root markers in ancestor directories.
" * Fallback to current directory.
let g:Lf_WorkingDirectoryMode = 'Ac'
" Root markers.
let g:Lf_RootMarkers = ['compile_commands.json', '.git']
" Use [0-9] to select entry.
let g:Lf_QuickSelect = 0
"
let g:Lf_WildIgnore = {
    \ 'dir': [ '.ccls-cache', '.vs', '.svn', '.git', '.hg',
    \          'bak', 'swp', 'undo' ]
    \ }
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
" function    hotkey
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


