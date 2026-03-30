""
" @file ultisnips settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

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
let g:UltiSnipsSnippetsDir = g:vimrc_path . '/fuzzier/UltiSnips'
"
" Set search directories for snippets.
" Used by :UltiSnipsEdit! command.
let g:UltiSnipsSnippetDirectories = [g:vimrc_path . '/fuzzier/UltiSnips']
"
autocmd VimEnter * silent! delcommand UltiSnipsAddFiletypes

