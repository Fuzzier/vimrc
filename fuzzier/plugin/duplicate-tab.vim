""
" @file Duplicate tab.
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-03-30
"

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

