""
" @file nerdtree settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

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

