""
" @file vim-fugitive settings.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

"---------------------------------------
" tpope/vim-fugitive
"---------------------------------------
" Reopen summary window
command! -nargs=* GG :execute "normal gq" | :Git
"
" Git log pretty format
" @see https://coderwall.com/p/euwpig/a-better-git-log
" command! GL  :Git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s' --abbrev-commit --all
command! -nargs=* GL :execute "normal gq"
         \| :Git log --graph
         \  --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s'
         \  --abbrev-commit --all <args>
"
" Git blame a range of codes
" * -s: without author and date.
command! -range=% GB <line1>,<line2>:Git blame -s

