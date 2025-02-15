" Highlight additional keywords in the comments
syn keyword cTodo contained BAD

" Highlight brace initialized variable names
if get(g:, 'cpp_function_highlight', 1)
    syn match cUserVariableBraceInit "\<\h\w*\ze\s\{-}{"
    hi def link cUserVariableBraceInit Function
endif
