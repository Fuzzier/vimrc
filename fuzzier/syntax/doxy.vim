" syn clear

if exists('b:current_syntax') && b:current_syntax =~ 'doxygen'
    finish
endif

" syn region xFirst  start=+fox+ end=+\(bar\)\@<=\ze+ contains=xSecond
" syn match xSecond +bar+   contained
" syn region xThird  start=+.+   end=+r+   contained

" hi xFirst  guifg=#00ff00 guibg=#373737
" hi xSecond guifg=#ff0000 guibg=#373737
" hi xThird  guifg=#0000ff guibg=#777777


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Options.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let b:doxy_concealends='concealends'

syn sync fromstart

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" C/C++ doxygen comment
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" /** ... */
" /*! ... */
execu 'syn region doxyBody matchgroup=doxyDelimiter '
  \ . 'start=+/\*\%(\*/\)\@![*!]<\@!+ '
  \ . 'end=+\*/+ '
  \ . 'keepend contains=@doxyInbody'

" /// ...
" //! ...
execu 'syn region doxyBody matchgroup=doxyDelimiter '
  \ . 'start=+^\s*//[/!][/!]\@!+ '
  \ . 'end=+$+ '
  \ . 'contains=@doxyInbody'

" /**< ... */
" /*!< ... */
execu 'syn region doxyBody matchgroup=doxyDelimiter '
  \ . 'start=+/\*[*!]<<\@!+ '
  \ . 'end=+\*/+ '
  \ . 'keepend contains=@doxyInbody'

" ///< ...
" //!< ...
" Put after and override '///' and '//!'.
execu 'syn region doxyBody matchgroup=doxyDelimiter '
  \ . 'start=+^\s*//[/!]<+ '
  \ . 'end=+$+ '
  \ . 'contains=@doxyInbody'

" xxx ///< ...
" xxx //!< ...
execu 'syn region doxyBody matchgroup=doxyDelimiter '
  \ . 'start=+/\@<!//[/!]<+ '
  \ . 'end=+$+ '
  \ . 'contains=@doxyInbody'

" * ...
syn match doxyContinue +^\s*\*/\@!\_s+ display contained

" /// ...
" //! ...
syn match doxyContinue +^\s*//[/!]\_s+ display contained

" ///< ...
" //!< ...
syn match doxyContinue +^\s*//[/!]<\_s+ display contained


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python, makefile
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('b:current_syntax') && b:current_syntax =~ '\%(python\|make\)'
    " ## ...
    execu 'syn region doxyBody matchgroup=doxyPyDelimiter '
      \ . 'start=+^\s*###\@!+ '
      \ . 'end=+$+ '
      \ . 'contains=@doxyInbody'
    " # ...
    execu 'syn region doxyBody matchgroup=doxyPyDelimiter '
      \ . 'start=+^\s*##\@!+ '
      \ . 'end=+$+ '
      \ . 'contains=@doxyInbody'
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Batch
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('b:current_syntax') && b:current_syntax =~ '\%(dosbatch\)'
    " REM ...
    " :: ...
    execu 'syn region doxyBody matchgroup=doxyPyDelimiter '
      \ . 'start=+^\s*(\cREM\|::)\s\@=+ '
      \ . 'end=+$+ '
      \ . 'contains=@doxyInbody'
endif


" There are several cases when @ is found:
" 1. Followed by space or eol.
" 2. An escaped character.
" 3. A special command.
" 4. A non-command.

" Several dicussions:
" 1. The structure of doxyBody.
"    doxyBody is divided into sections.
"    Each section may contain subsections and blocks.
"
" 2. The group of @ is determined by what follows it.
"    It is hard to determine the region of an open section, since there are
"    too many commands to terminate an open section.
"    A match pattern of a lot of '\|' (or) is not elegant.
"    The state of a syntax item is implicitly preserved by the stack of the
"    containing items.
"    That is, the state of an item is stored when a contained item matches, and
"    when the contained item ends, the state switches back to the containing
"    item.
"    For example, for a section, it may contain a subsection or block.
"    However, after the subsection or block, the highlight shall be restored
"    back to the section.
"    Thus, the section must be extended until the next section.
"    But how to extend the region?
"    1) Skip commands of subsections and blocks? Use skip pattern.
"    2) Look ahead and decide? Have to use end pattern.
"    When @ is found, several contained items are provided to match each case.
"    Since the items all start from @, the item with the higher priority is
"    defined after the item with lower priority.
"    Some items must be used to find the next @.
" 1.1 Design 1.
"     * When @xxx is not recognized as a doxygen command, the context returns
"       back to doxyBody.
"     * doxyEscaped is defined to recognize escaped characters.
"       It is atomic, and has the highest priority.
"     * The common text of doxygen command fallback directly to doxyBody.
"       For example, the '@brief' command itself is recognized and highlighted,
"       but the item ends and returns to doxyBody, so the body of the section
"       is highlighted as doxyBody.
"       This is a fast method, as it takes a lot of read-ahead and -behind to
"       recognize the border of a large open section.
"       Users do not have to scroll back and forth to correct the highlighting.

" An escaped characters: @n, @\, @@, @&, @$, @#, @<, @>, @%, @", @., @=, @::, @|, @--, @---
syn match doxyEscaped +[@\\]\%(n\>\|[\\@&$#<>%".=|]\|::\|-\{2,3}\)+ contained

""""""""""""""""""""""""""""""""""""""""
" Basic syntax items
""""""""""""""""""""""""""""""""""""""""
" <name>
syn match doxyName /[0-9A-Za-z_:]\+/ display contained
" <name> [<name> ...]
syn match doxyNames /[0-9A-Za-z_:]\+/ display contained skipwhite nextgroup=doxyNames
" <name> (title)
syn match doxyNameTitle /[0-9A-Za-z_:]\+/ display contained skipwhite nextgroup=doxyTitle
" (title)
syn match doxyTitle +.*$+ display contained keepend contains=@doxyInline

""""""""""""""""""""""""""""""""""""""""
" Font faces
""""""""""""""""""""""""""""""""""""""""
" Italic word: @xxx <word>
" end pattern:
" \_s   end from a space or eol, do not end at the command '@a'.
" \(\)\@<=\(\)\@<!   zero-width match, even if the text is obsured by
"                    contained items, the pattern can still match.
execu 'syn region doxyFont '
  \ . 'start=+[@\\]\%([ae]\|em\)\>+ '
  \ . 'end=+\%(\_s[0-9A-Za-z_():*]\+\)\@<=[0-9A-Za-z_():*]\@!+ '
  \ . 'end=+[@\\]+me=e-1 '
  \ . 'contained contains=doxyContinue,doxyItalicWord'

" \_s\@<=   match after a space or eol, do not match the command '@a'.
execu 'syn match doxyItalicWord '
  \ . '+\_s\@<=\%([0-9A-Za-z_():*]\@<![0-9A-Za-z_():*]\+\)[0-9A-Za-z_():*]\@!+ '
  \ . 'display contained'

" Bold word: @xxx <word>
execu 'syn region doxyFont '
  \ . 'start=+[@\\]b\>+ '
  \ . 'end=+\%(\_s[0-9A-Za-z_():*]\+\)\@<=[0-9A-Za-z_():*]\@!+ '
  \ . 'end=+[@\\]+me=e-1 '
  \ . 'contained contains=doxyContinue,doxyBoldWord'

execu 'syn match doxyBoldWord '
  \ . '+\_s\@<=\%([0-9A-Za-z_():*]\@<![0-9A-Za-z_():*]\+\)[0-9A-Za-z_():*]\@!+ '
  \ . 'contained'

" Code word: @xxx <word>
execu 'syn region doxyFont '
  \ . 'start=+[@\\][cp]\>+ '
  \ . 'end=+\%(\_s[0-9A-Za-z_():*]\+\)\@<=[0-9A-Za-z_():*]\@!+ '
  \ . 'end=+[@\\]+me=e-1 '
  \ . 'contained contains=doxyContinue,doxyCodeWord'

execu 'syn match doxyCodeWord '
  \ . '+\_s\@<=\%([0-9A-Za-z_():*]\@<![0-9A-Za-z_():*]\+\)[0-9A-Za-z_():*]\@!+ '
  \ . 'contained'

""""""""""""""""""""""""""""""""""""""""
" Par
""""""""""""""""""""""""""""""""""""""""
" @par [(title)]
"      {text}
execu 'syn match doxyPar '
  \ . '+[@\\]par\>+ '
  \ . 'display contained skipwhite nextgroup=doxyTitle'

""""""""""""""""""""""""""""""""""""""""
" Block
""""""""""""""""""""""""""""""""""""""""
" Code section: @code['{'<word>'}'] {text} @endcode
execu 'syn region doxyCodeBlock matchgroup=doxyCommand '
  \ . 'start=+[@\\]code\>\%({\.[[:alnum:]]\+}\)\?$+ '
  \ . 'end=+[@\\]endcode$+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyDot matchgroup=doxyCommand '
  \ . 'start=+[@\\]dot$+ '
  \ . 'end=+[@\\]enddot$+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyVerbatim matchgroup=doxyCommand '
  \ . 'start=+[@\\]verbatim$+ '
  \ . 'end=+[@\\]endverbatim$+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn match doxyInternal '
  \ . '+[@\\]\%(internal\|endinternal\)\>+ '
  \ . 'display contained'

execu 'syn region doxyLatexonly matchgroup=doxyCommand '
  \ . 'start=+[@\\]latexonly$+ '
  \ . 'end=+[@\\]endlatexonly$+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyHtmlonly matchgroup=doxyCommand '
  \ . 'start=+[@\\]htmlonly$+ '
  \ . 'end=+[@\\]endhtmlonly$+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyFormula matchgroup=doxyCommand '
  \ . 'start=+[@\\]f\$+ '
  \ . 'end=+[@\\]f\$+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyFormula matchgroup=doxyCommand '
  \ . 'start=+[@\\]f\[+ '
  \ . 'end=+[@\\]f\]+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyFormula '
  \ . 'start=+[@\\]f{+ '
  \ . 'matchgroup=doxyCommand '
  \ . 'end=+[@\\]f}+ '
  \ . 'contained keepend contains=doxyFormulaEnv,doxyContinue'

" Starts after '@f{', ends at the first following '}'.
execu 'syn region doxyFormulaEnv matchgroup=doxyCommand '
  \ . 'start=+[@\\]f{+ '
  \ . 'end=+}{+ '
  \ . 'contained keepend contains=doxyContinue'

""""""""""""""""""""""""""""""""""""""""
" Text sections
""""""""""""""""""""""""""""""""""""""""
" A common text section: @xxx {text}
"   brief short details author authors version date      since pre post
"   attention   warning note   remark  remarks invariant copyright todo
"   test  bug   deprecated     return  returns result sa see
execu 'syn match doxySection '
  \ . '+[@\\]\%(brief\|short\|details\|author\|authors\|version\|date\|'
  \ .          'since\|pre\|post\|remark\|remarks\|invariant\|copyright\|'
  \ .          'return\|returns\|result\|sa\|see\)\>+ '
  \ . 'display contained'

" Special section (ends with a blank line).
execu 'syn region doxyTodo '
  \ . 'start=+[@\\]\%(attention\|warning\|note\|todo\|test\|bug\|deprecated\)\>+ '
  \ . 'end=+^\s*\*\?\s*$+ '
  \ . 'display contained keepend contains=doxyContinue,@doxyIntext'

""""""""""""""""""""""""""""""""""""""""
" Class
""""""""""""""""""""""""""""""""""""""""
" @xxx <name> {text}
" tparam
execu 'syn match doxyTypeParam '
  \ . '+[@\\]tparam\>+ '
  \ . 'display contained skipwhite nextgroup=doxyName'

" @xxx
execu 'syn match doxyFakeClass '
  \ . '+[@\\]\%(public\|protected\|private\|'
  \ .          'publicsection\|protectedsection\|privatesection\)\>+ '
  \ . 'display contained'

" @xxx <name>
" extends implements memberof
execu 'syn match doxyFakeClass '
  \ . '+[@\\]\%(extends\|implements\|memberof\)\>+ '
  \ . 'display contained skipwhite nextgroup=doxyName'

""""""""""""""""""""""""""""""""""""""""
" Function
""""""""""""""""""""""""""""""""""""""""
" @param ['['in|out|in,out']'] <name> {text}
execu 'syn match doxyParam '
  \ . '+[@\\]param\>+ '
  \ . 'display contained skipwhite nextgroup=doxyParamIO,doxyName'

execu 'syn match doxyParamIO '
  \ . '+\[\%(in\|out\|in,out\)\]+ '
  \ . 'display contained skipwhite nextgroup=doxyName'

" @xxx <name> {text}
" retval
execu 'syn match doxyFunction '
  \ . '+[@\\]retval\>+ '
  \ . 'display contained skipwhite nextgroup=doxyName'

" exception throw throws
execu 'syn match doxyFunction '
  \ . '+[@\\]\%(exception\|throw\|throws\)\>+ '
  \ . 'display contained skipwhite nextgroup=doxyName'

" @xxx <name>
" relates related relatesalso relatedalso
execu 'syn match doxyFunction '
  \ . '+[@\\]\%(relates\|related\|relatesalso\|relatedalso\)\>+ '
  \ . 'display contained skipwhite nextgroup=doxyName'

" @xxx [(declaration)]
execu 'syn match doxyFunction '
  \ . '+[@\\]overload\>+ '
  \ . 'display contained skipwhite nextgroup=doxyFunctionName'

syn match doxyFunctionName +.*$+ display contained

" @xxx
execu 'syn match doxyFunction '
  \ . '+[@\\]\%(callgraph\|hidecallgraph\|'
  \ .          'callergraph\|hidecallergraph\|'
  \ .          'showrefs\|hiderefs\|'
  \ .          'showrefby\|hiderefby'
  \ .        '\)\>+ '
  \ . 'display contained'

""""""""""""""""""""""""""""""""""""""""
" Entity
""""""""""""""""""""""""""""""""""""""""
" @xxx <name>
" file namespace def package
execu 'syn match doxyEntity +[@\\]\%(file\|namespace\|def\|package\)\>+ '
  \ . 'display contained skipwhite nextgroup=doxyName'

" @headerfile [<header-file>] [<header-name>]
execu 'syn match doxyEntity +[@\\]headerfile\>+ '
  \ . 'display contained skipwhite nextgroup=doxyHeaderFileName'

execu 'syn match doxyHeaderFileName '
  \ . '/\%(".\{-}"\)\|\%(<.\{-}>\)\|[0-9A-Za-z_./\\-]\+/ '
  \ . 'display contained skipwhite nextgroup=doxyHeaderName'

execu 'syn match doxyHeaderName '
  \ . '/\%(".\{-}"\)\|\%(<.\{-}>\)\|[0-9A-Za-z_./\\-]\+/ '
  \ . 'display contained'

" @xxx <name> [<header-file>] [<header-name>]
" class struct interface union enum
execu 'syn match doxyEntity +[@\\]\%(class\|struct\|interface\|union\|enum\)\>+ '
  \ . 'display contained skipwhite nextgroup=doxyEntityName'

execu 'syn match doxyEntityName /[0-9A-Za-z_:*]\+/ '
  \ . 'display contained skipwhite nextgroup=doxyHeaderFileName'

" @xxx (declaration)
" fn var property typedef
execu 'syn match doxyEntity +[@\\]\%(fn\|var\|property\|typedef\)\>+ '
  \ . 'display contained skipwhite nextgroup=doxyFunctionName'

""""""""""""""""""""""""""""""""""""""""
" Grouping
""""""""""""""""""""""""""""""""""""""""
" @ingroup <name> [<name> ...]
execu 'syn match doxyGrouping '
  \ . '+[@\\]ingroup\>+ '
  \ . 'display contained skipwhite nextgroup=doxyNames'

" @xxx <name> (title)
execu 'syn match doxyGrouping '
  \ . '+[@\\]\%(defgroup\|addtogroup\|weakgroup\)\>+ '
  \ . 'display contained skipwhite nextgroup=doxyNameTitle'

" @name [(header)]
execu 'syn match doxyGrouping '
  \ . '+[@\\]name\>+ '
  \ . 'display contained skipwhite nextgroup=doxyTitle'

" @{ ... @}
execu 'syn match doxyGrouping '
  \ . '+[@\\]\%({\|}\)+ '
  \ . 'display contained'

" @nosubgrouping
execu 'syn match doxyGrouping '
  \ . '+[@\\]nosubgrouping\>+ '
  \ . 'display contained'

""""""""""""""""""""""""""""""""""""""""
" Subpaging
""""""""""""""""""""""""""""""""""""""""
" @xxx <name> (title)
" page subpage section subsection subsubsection paragraph
execu 'syn match doxyPaging '
  \ . '+[@\\]\%(page\|subpage\|section\|subsection\|subsubsection\|paragraph\|ref\)\>+ '
  \ . 'display contained skipwhite nextgroup=doxyNameTitle'

" @mainpage <name>
execu 'syn match doxyPaging '
  \ . '+[@\\]mainpage\>+ '
  \ . 'display contained skipwhite nextgroup=doxyName'

" @tableofcontents
execu 'syn match doxyPaging '
  \ . '+[@\\]tableofcontents\>+ '
  \ . 'display contained'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Markdown.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Emphasis
" space/eol *...* space/eol
" space/eol _..._ space/eol
execu 'syn region doxyMdItalic matchgroup=doxyMdDelimiter '
  \ . 'start=+\%(\_s\|[(\[{<,:;]\|[\u4E00-\u9FFF]\)\@<=\*[[:alnum:]\u4E00-\u9FFF]\@=+ '
  \ . 'end=+\%(\_s\|[(\[{<=+\-\\@\*]\)\@<!\*[[:alnum:]]\@!+ '
  \ . 'contained contains=doxyContinue,@doxyMdInline '
  \ . b:doxy_concealends
execu 'syn region doxyMdItalic matchgroup=doxyMdDelimiter '
  \ . 'start=+\%(\s\|[(\[{<,:;]\|[\u4E00-\u9FFF]\)\@<=_[[:alnum:]\u4E00-\u9FFF]\@=+ '
  \ . 'end=+\%(\_s\|[(\[{<=+\-\\@_]\)\@<!_[[:alnum:]]\@!+ '
  \ . 'contained contains=doxyContinue,@doxyMdInline '
  \ . b:doxy_concealends

" space/eol **...** space/eol
" space/eol __...__ space/eol
execu 'syn region doxyMdBold matchgroup=doxyMdDelimiter '
  \ . 'start=+\%(\_s\|[(\[{<,:;]\|[\u4E00-\u9FFF]\)\@<=\*\*[[:alnum:]\u4E00-\u9FFF]\@=+ '
  \ . 'end=+\%(\_s\|[(\[{<=+\-\\@\*]\)\@<!\*\*[[:alnum:]]\@!+ '
  \ . 'contained contains=doxyContinue,@doxyMdInline '
  \ . b:doxy_concealends
execu 'syn region doxyMdBold matchgroup=doxyMdDelimiter '
  \ . 'start=+\%(\s\|[(\[{<,:;]\|[\u4E00-\u9FFF]\)\@<=__[[:alnum:]\u4E00-\u9FFF]\@=+ '
  \ . 'end=+\%(\_s\|[(\[{<=+\-\\@_]\)\@<!__[[:alnum:]]\@!+ '
  \ . 'contained contains=doxyContinue,@doxyMdInline '
  \ . b:doxy_concealends

" Strikethrough
" space/eol ~~...~~ space/eol
execu 'syn region doxyMdStrike matchgroup=doxyMdDelimiter '
  \ . 'start=+\%(\_s\|[(\[{<,:;]\|[\u4E00-\u9FFF]\)\@<=\~\~[[:alnum:]\u4E00-\u9FFF]\@=+ '
  \ . 'end=+\%(\_s\|[(\[{<=+\-\\@~]\)\@<!\~\~[[:alnum:]]\@!+ '
  \ . 'contained contains=doxyContinue,@doxyMdInline '
  \ . b:doxy_concealends

" Inline code
" `code`
execu 'syn region doxyMdInlineCode matchgroup=doxyMdDelimiter '
  \ . 'start=+`\@<!``\@!+ skip=+``+ end=+`+ '
  \ . 'contained keepend contains=doxyContinue '
  \ . b:doxy_concealends

" Headers
" # H1
" ## H2
" ### H3
" #### H4
" ##### H5
" ###### H6
syn region doxyMdH1 matchgroup=doxyMdDelimiter start=+#\@<!#\s\@=+      end=+#*\s*$+ display oneline contained contains=@doxyMdInline
syn region doxyMdH2 matchgroup=doxyMdDelimiter start=+#\@<!##\s\@=+     end=+#*\s*$+ display oneline contained contains=@doxyMdInline
syn region doxyMdH3 matchgroup=doxyMdDelimiter start=+#\@<!###\s\@=+    end=+#*\s*$+ display oneline contained contains=@doxyMdInline
syn region doxyMdH4 matchgroup=doxyMdDelimiter start=+#\@<!####\s\@=+   end=+#*\s*$+ display oneline contained contains=@doxyMdInline
syn region doxyMdH5 matchgroup=doxyMdDelimiter start=+#\@<!#####\s\@=+  end=+#*\s*$+ display oneline contained contains=@doxyMdInline
syn region doxyMdH6 matchgroup=doxyMdDelimiter start=+#\@<!######\s\@=+ end=+#*\s*$+ display oneline contained contains=@doxyMdInline

" Underlined headers (limited support: no highlight of the header itself).
syn match doxyMdHeaderLine "\%(^\|\s\)\@<==\+$" display contained

" Block quotes (overrides doxyBlock and doxyContinue)
" > quote
" >> quote
" > > quote
" Prevent '>' from starting a block quote within the text: a block quote starts
" from the start of the line, may optionally have a '*', then one or more '>'s.
execu 'syn region doxyMdBlockQuote matchgroup=doxyMdDelimiter '
  \ . 'start=+^\s*\%(\*\s\+\)\?\%(>\s\?\)\+\s\@=+ '
  \ . 'end=+$+ '
  \ . 'display oneline contained contains=@doxyInline'

" A block quote starts from the start of the line, have '///' or '//!',
" then one or more '>'s.
execu 'syn region doxyMdBlockQuote matchgroup=doxyMdDelimiter '
  \ . 'start=+^\s*//[/!]\s\+\%(>\s\?\)\+\s\@=+ '
  \ . 'end=+$+ '
  \ . 'display oneline contains=@doxyInline'

" A block quote starts from the start of the line, have '///<' or '//!<',
" then one or more '>'s.
execu 'syn region doxyMdBlockQuote matchgroup=doxyMdDelimiter '
  \ . 'start=+^\s*//[/!]<\s\+\%(>\s\?\)\+\s\@=+ '
  \ . 'end=+$+ '
  \ . 'display oneline contains=@doxyInline'

" Fenced code block
" ```['{'<word>'}']
" ```
execu 'syn region doxyMdFencedCodeBlock matchgroup=doxyMdDelimiter '
  \ . 'start=+\s\@<=`\{3,}\%({\.[[:alnum:]]\+}\)\?$+ '
  \ . 'end=+\s\@<=`\{3,}\s*$+ '
  \ . 'contained keepend contains=doxyContinue'

" ~~~['{'<word>'}']
" ~~~
execu 'syn region doxyMdFencedCodeBlock matchgroup=doxyMdDelimiter '
  \ . 'start=+\~\{3,}\%({\.[[:alnum:]]\+}\)\?$+ '
  \ . 'end=+\~\{3,}\s*$+ '
  \ . 'contained keepend contains=doxyContinue'

" Code block (not supported: hard to check the empty lines before and after
"             the code block)
" (empty line)
"     4 or more spaces
"     a code block
" (empty line)
"
" syn match doxyMdCodeBlock +\%(\s\{4,}\)\@<=.*$+ contained

" Lists
" * xxx
" + xxx
" - xxx
" \s\@<=   must not start from the beginning of a line
syn match doxyMdBulletList +\s\@<=\*\s\@=+ display contained
syn match doxyMdBulletList +\_s\@<=[+-]\s\@=+ display contained
" 1. xxx
" -# xxx
syn match doxyMdNumberList +\_s\@<=\d\+\.\s\@=+ display contained
syn match doxyMdNumberList +\_s\@<=-#\s\@=+ display contained

" Horizontal rules (put after and override bullet lists)
" * * *
syn match doxyMdRule +\%(\s\)\@<=\%(\*\s*\)\{3,}$+ display contained
" - - -
syn match doxyMdRule +\%(-\s*\)\{3,}$+ display contained
" _ _ _
syn match doxyMdRule +\%(_\s*\)\{3,}$+ display contained

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Html.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Font faces
" Italic, <i></i>, <em></em>, <var></var>
execu 'syn region doxyHtmlItalic matchgroup=doxyHtmlTag '
  \ . 'start=+<i>+ '
  \ . 'end=+</i>+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyHtmlItalic matchgroup=doxyHtmlTag '
  \ . 'start=+<em>+ '
  \ . 'end=+</em>+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyHtmlItalic matchgroup=doxyHtmlTag '
  \ . 'start=+<var>+ '
  \ . 'end=+</var>+ '
  \ . 'contained keepend contains=doxyContinue'

" Bold, <b></b>, <strong></strong>
execu 'syn region doxyHtmlBold matchgroup=doxyHtmlTag '
  \ . 'start=+<b>+ '
  \ . 'end=+</b>+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyHtmlBold matchgroup=doxyHtmlTag '
  \ . 'start=+<strong>+ '
  \ . 'end=+</strong>+ '
  \ . 'contained keepend contains=doxyContinue'

" Typewritter, <tt></tt>, <code></code>, <dfn></dfn>, <kbd></kbd>
execu 'syn region doxyHtmlCode matchgroup=doxyHtmlTag '
  \ . 'start=+<tt>+ '
  \ . 'end=+</tt>+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyHtmlCode matchgroup=doxyHtmlTag '
  \ . 'start=+<code>+ '
  \ . 'end=+</code>+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyHtmlCode matchgroup=doxyHtmlTag '
  \ . 'start=+<dfn>+ '
  \ . 'end=+</dfn>+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyHtmlCode matchgroup=doxyHtmlTag '
  \ . 'start=+<kbd>+ '
  \ . 'end=+</kbd>+ '
  \ . 'contained keepend contains=doxyContinue'

" Strikethrough, <strike></strike>, <del></del>
execu 'syn region doxyHtmlStrike matchgroup=doxyHtmlTag '
  \ . 'start=+<strike>+ '
  \ . 'end=+</strike>+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyHtmlStrike matchgroup=doxyHtmlTag '
  \ . 'start=+<del>+ '
  \ . 'end=+</del>+ '
  \ . 'contained keepend contains=doxyContinue'

" Underline, <u></u>, <ins></ins>
execu 'syn region doxyHtmlUnderline matchgroup=doxyHtmlTag '
  \ . 'start=+<u>+ '
  \ . 'end=+</u>+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyHtmlUnderline matchgroup=doxyHtmlTag '
  \ . 'start=+<ins>+ '
  \ . 'end=+</ins>+ '
  \ . 'contained keepend contains=doxyContinue'

" Smaller, <small></small>
execu 'syn region doxyHtmlSmall matchgroup=doxyHtmlTag '
  \ . 'start=+<small>+ '
  \ . 'end=+</small>+ '
  \ . 'contained keepend contains=doxyContinue'

" Subscript, <sub></sub>
execu 'syn region doxyHtmlSub matchgroup=doxyHtmlTag '
  \ . 'start=+<sub>+ '
  \ . 'end=+</sub>+ '
  \ . 'contained keepend contains=doxyContinue'

" Superscript, <sup></sup>
execu 'syn region doxyHtmlSup matchgroup=doxyHtmlTag '
  \ . 'start=+<sup>+ '
  \ . 'end=+</sup>+ '
  \ . 'contained keepend contains=doxyContinue'

" Headers
execu 'syn region doxyHtmlH1 matchgroup=doxyHtmlTag '
  \ . 'start=+<h1>+ '
  \ . 'end=+</h1>+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyHtmlH2 matchgroup=doxyHtmlTag '
  \ . 'start=+<h2>+ '
  \ . 'end=+</h2>+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyHtmlH3 matchgroup=doxyHtmlTag '
  \ . 'start=+<h3>+ '
  \ . 'end=+</h3>+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyHtmlH4 matchgroup=doxyHtmlTag '
  \ . 'start=+<h4>+ '
  \ . 'end=+</h4>+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyHtmlH5 matchgroup=doxyHtmlTag '
  \ . 'start=+<h5>+ '
  \ . 'end=+</h5>+ '
  \ . 'contained keepend contains=doxyContinue'

execu 'syn region doxyHtmlH6 matchgroup=doxyHtmlTag '
  \ . 'start=+<h6>+ '
  \ . 'end=+</h6>+ '
  \ . 'contained keepend contains=doxyContinue'

" Centered
execu 'syn region doxyHtmlCenter matchgroup=doxyHtmlTag '
  \ . 'start=+<center\>[^>]*>+ '
  \ . 'end=+</center>+ '
  \ . 'contained keepend contains=doxyContinue,@doxyHtml'

" Line break, <br>
execu 'syn match doxyHtmlTag '
  \ . '+<br>+ '
  \ . 'display contained'

" Paragraph, <p></p>
execu 'syn match doxyHtmlTag '
  \ . '+<p>+ '
  \ . 'display contained'

execu 'syn match doxyHtmlTag '
  \ . '+</p>+ '
  \ . 'display contained'

" Horizontal ruler, <hr>
execu 'syn match doxyHtmlTag '
  \ . '+<hr>+ '
  \ . 'display contained'

" Block quote
execu 'syn region doxyHtmlBlockQuote matchgroup=doxyHtmlTag '
  \ . 'start=+<blockquote\>[^>]*>+ '
  \ . 'end=+</blockquote>+ '
  \ . 'contained keepend contains=doxyContinue,@doxyHtml'

" Preformatted
execu 'syn region doxyHtmlPreformatted matchgroup=doxyHtmlTag '
  \ . 'start=+<pre>+ '
  \ . 'end=+</pre>+ '
  \ . 'contained keepend contains=doxyContinue'

" Span
execu 'syn region doxyHtmlSpan matchgroup=doxyHtmlTag '
  \ . 'start=+<span\>[^>]*>+ '
  \ . 'end=+</span>+ '
  \ . 'contained contains=doxyContinue,@doxyHtml'

" Div
execu 'syn region doxyHtmlDiv matchgroup=doxyHtmlTag '
  \ . 'start=+<div\>[^>]*>+ '
  \ . 'end=+</div>+ '
  \ . 'contained contains=doxyContinue,@doxyHtml'

" Unnumbered item list, <ul></ul>
execu 'syn region doxyHtmlList matchgroup=doxyHtmlTag '
  \ . 'start=+<ul>+ '
  \ . 'end=+</ul>+ '
  \ . 'contained contains=doxyContinue,@doxyHtml'

" Numbered item list, <ol></ol>
execu 'syn region doxyHtmlList matchgroup=doxyHtmlTag '
  \ . 'start=+<ol>+ '
  \ . 'end=+</ol>+ '
  \ . 'contained contains=doxyContinue,@doxyHtml'

" List item, <li></li>
execu 'syn match doxyHtmlTag '
  \ . '+<li>+ '
  \ . 'display contained'

execu 'syn match doxyHtmlTag '
  \ . '+</li>+ '
  \ . 'display contained'

" Description list, <dl></dl>
execu 'syn region doxyHtmlList matchgroup=doxyHtmlTag '
  \ . 'start=+<dl>+ '
  \ . 'end=+</dl>+ '
  \ . 'contained contains=doxyContinue,@doxyHtml'

" Item title, <dt></dt>
execu 'syn region doxyHtmlItemTitle matchgroup=doxyHtmlTag '
  \ . 'start=+<dt>+ '
  \ . 'end=+</dt>+ '
  \ . 'contained contains=doxyContinue,@doxyHtml'

" Item description, <dd></dd>
execu 'syn region doxyHtmlItemDesc matchgroup=doxyHtmlTag '
  \ . 'start=+<dd>+ '
  \ . 'end=+</dd>+ '
  \ . 'contained contains=doxyContinue,@doxyHtml'

" Table
execu 'syn region doxyHtmlTable matchgroup=doxyHtmlTag '
  \ . 'start=+<table\>[^>]*>+ '
  \ . 'end=+</table>+ '
  \ . 'contained keepend contains=doxyContinue,@doxyHtml'

" Table caption
execu 'syn region doxyHtmlCaption matchgroup=doxyHtmlTag '
  \ . 'start=+<caption>+ '
  \ . 'end=+</caption>+ '
  \ . 'contained keepend contains=doxyContinue,@doxyHtml'

" Table row
execu 'syn region doxyHtmlTableRow matchgroup=doxyHtmlTag '
  \ . 'start=+<tr>+ '
  \ . 'end=+</tr>+ '
  \ . 'contained keepend contains=doxyContinue,@doxyHtml'

" Table header
execu 'syn region doxyHtmlTableHeader matchgroup=doxyHtmlTag '
  \ . 'start=+<th>+ '
  \ . 'end=+</th>+ '
  \ . 'contained keepend contains=doxyContinue,@doxyHtml'

" Table data
execu 'syn region doxyHtmlTableData matchgroup=doxyHtmlTag '
  \ . 'start=+<td>+ '
  \ . 'end=+</td>+ '
  \ . 'contained keepend contains=doxyContinue,@doxyHtml'

" Hyperlink
execu 'syn region doxyHtmlLink matchgroup=doxyHtmlTag '
  \ . 'start=+<a\>[^>]*>+ '
  \ . 'end=+</a>+ '
  \ . 'contained keepend contains=doxyContinue,@doxyHtml'

" Image
execu 'syn match doxyHtmlImage '
  \ . '+<img\>[^>]*>+ '
  \ . 'contained keepend'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Clusters.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Anything that can appear within a <word>.
syn cluster doxyInword contains=doxyEscaped

" Anything that can appear within a (line).
syn cluster doxyInline contains=@doxyInword,doxyFont,@doxyMdInline

" Anything that can appear within a {text}.
syn cluster doxyIntext contains=
  \ @doxyInline,doxyContinue,doxyPar,
  \ doxyCodeBlock,doxyDot,doxyVerbatim,doxyInternal,
  \ doxyHtmlonly,doxyLatexonly,doxyFormula,
  \ @doxyHtml

" Anything that can appear within doxyBody.
syn cluster doxyInbody contains=
  \ @doxyIntext,@doxyMd,doxySection,doxyTodo,
  \ doxyTypeParam,doxyFakeClass,doxyParam,doxyFunction,doxyEntity,
  \ doxyGrouping,doxyPaging

" Markdown inline elements that can appear within other markdown elements.
syn cluster doxyMdInline contains=
  \ doxyMdItalic,doxyMdBold,doxyMdStrike,doxyMdInlineCode

" All Markdown elements.
syn cluster doxyMd contains=
  \ @doxyMdInline,doxyMdRule,
  \ doxyMdH1,doxyMdH2,doxyMdH3,doxyMdH4,doxyMdH5,doxyMdH6,doxyMdHeaderLine,
  \ doxyMdBlockQuote,doxyMdFencedCodeBlock,doxyMdCodeBlock,
  \ doxyMdBulletList,doxyMdNumberList

" All HTML elements.
syn cluster doxyHtml contains=
  \ doxyHtmlItalic,doxyHtmlBold,doxyHtmlCode,doxyHtmlStrike,doxyHtmlUnderline,
  \ doxyHtmlSmall,doxyHtmlSub,doxyHtmlSup,
  \ doxyHtmlTag,
  \ doxyHtmlH1,doxyHtmlH2,doxyHtmlH3,doxyHtmlH4,doxyHtmlH5,doxyHtmlH6,
  \ doxyHtmlCenter,doxyHtmlPreformatted,doxyHtmlBlockQuote,
  \ doxyHtmlSpan,doxyHtmlDiv,
  \ doxyHtmlList,doxyHtmlItemTitle,doxyHtmlItemDesc,
  \ doxyHtmlTable,doxyHtmlCaption,doxyHtmlTableRow,doxyHtmlTableHeader,
  \ doxyHtmlTableData,
  \ doxyHtmlLink,doxyHtmlImage


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Since many syntax items in c.vim use the 'contains=ALLBUT' argument,
" the doxygen 'contained' groups would leak into these syntax items.
" Add the doxygen 'contained' groups into the 'BUT' clusters.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syn cluster cParenGroup   add=doxy.*
syn cluster cParenGroup   remove=doxyBody
syn cluster cPreProcGroup add=doxy.*
syn cluster cMultiGroup   add=doxy.*
syn cluster rcParenGroup  add=doxy.*
syn cluster rcParenGroup  remove=doxyBody
syn cluster rcGroup       add=doxy.*

""""""""""""""""""""""""""""""""""""""""
" Highlighting
""""""""""""""""""""""""""""""""""""""""
" How many different colors do we need?
" 1. Comment
"    The begin and end delimiters of a doxygen comment requires a color.
"    /**, */, ///, ///<
"    doxyDelimiter
"
"    The doxygen comment continue delimiter may use a different color.
"    *, ///, ///<
"    doxyContinue
"
"    Markdown delimiters may use a different color.
"    doxyMdDelimiter
"
" 2. Command
"    Multiple different colors are required to distinguish the different fields
"    of a multi-part command.
"    For example,
"    @brief {text}
"    doxyCommand  (@command)
"    doxyText     (common text)
"
"    @retval <name> {text}
"    doxyName     (e.g., <name>, ...)
"
"    @par [(title)] {text}
"    doxyTitle    (e.g., (title), ...)
"
"    Escaped characters may use a more visible color than a command.
"    doxyEscaped
"
"    Header requires a more visible color than a common text.
"    doxyHeading
"
"    Todo requires a more alerting color than a common text.
"    doxyTodo
"
" 3. Font
"    Code requires a visible color.
"    doxyCode
"
"    Italic and bold fonts require a visible color.
"    doxyItalic
"    doxyBold
"
"    Strikethrough font requires a dimmer color.
"    doxyStrike

" CR: contrast ratio
" (CR=15.0) 0,0,87     (white on black)
hi def doxyDelimiter   ctermfg=188 ctermbg=0   guifg=#dfdfdf guibg=#080808
hi def doxyMdDelimiter ctermfg=188 ctermbg=0   guifg=#dfdfdf guibg=#080808
hi def doxyContinue    ctermfg=188 ctermbg=0   guifg=#dfdfdf guibg=#080808
hi def doxyCommand     ctermfg=188 ctermbg=0   guifg=#dfdfdf guibg=#080808
hi def doxyFont        ctermfg=188 ctermbg=0   guifg=#dfdfdf guibg=#080808
" (CR= 7.4) 180,100,68 (shall be the same as Comment)
hi def doxyText        ctermfg=37  ctermbg=0   guifg=#00afaf guibg=#080808
" (CR=11.1) 145,100,87 (shall be the same as the source code)
hi def doxyCode        ctermfg=40  ctermbg=0   guifg=#00df5f guibg=#080808
hi def doxyItalic      ctermfg=45  ctermbg=0   guifg=#00df5f guibg=#080808 term=italic      cterm=italic      gui=italic
hi def doxyBold        ctermfg=50  ctermbg=0   guifg=#00df5f guibg=#080808 term=bold        cterm=bold        gui=bold
hi def doxyBoldItalic  ctermfg=50  ctermbg=0   guifg=#00df5f guibg=#080808 term=italic,bold cterm=italic,bold gui=italic,bold
hi def doxyUnderline   ctermfg=45  ctermbg=0   guifg=#00df5f guibg=#080808 term=underline   cterm=underline   gui=underline
" (CR= 7.5) 0,0,61     (Strikethrough text is the least significant)
hi def doxyStrike      ctermfg=247 ctermbg=0   guifg=#9e9e9e guibg=#080808
" (CR=12.8) 72,100,87  (a doxygen identifier is more significant than the common
"                       text, different from an identifier in the source code)
hi def doxyName        ctermfg=190 ctermbg=0   guifg=#afdf00 guibg=#080808
" (CR= 8.5) 60,100,68  (a title is more significant than the common text)
hi def doxyTitle       ctermfg=142 ctermbg=0   guifg=#afaf00 guibg=#080808
" (CR=12.8) 72,100,87  (special characters)
hi def doxyEscaped     ctermfg=148 ctermbg=0   guifg=#dfdfdf guibg=#080808
" (CR= 9.8) 47,100,87  (a header is more significant than the common text)
hi def doxyHeading     ctermfg=178 ctermbg=0   guifg=#dfaf00 guibg=#080808
" (CR=17.5) 52,100,100 (yellow, quite attractive)
hi def doxyTodo        ctermfg=190 ctermbg=0   guifg=#dfff00 guibg=#080808

""""""""""""""""""""""""""""""""""""""""
hi def link doxyBody           doxyText
hi def link doxyNames          doxyName
hi def link doxyNameTitle      doxyName
hi def link doxyItalicWord     doxyItalic
hi def link doxyBoldWord       doxyBold
hi def link doxyCodeWord       doxyCode
hi def link doxyPar            doxyCommand
hi def link doxySection        doxyCommand
hi def link doxyTypeParam      doxyCommand
hi def link doxyFakeClass      doxyCommand
hi def link doxyParam          doxyCommand
hi def link doxyParamIO        doxyHeading
hi def link doxyFunction       doxyCommand
hi def link doxyFunctionName   doxyName
hi def link doxyEntity         doxyHeading
hi def link doxyEntityName     doxyName
hi def link doxyHeaderFileName doxyCode
hi def link doxyHeaderName     doxyTitle
hi def link doxyGrouping       doxyCommand
hi def link doxyPaging         doxyCommand
hi def link doxyCodeBlock      doxyCodeWord
hi def link doxyDot            doxyCode
hi def link doxyVerbatim       doxyCode
hi def link doxyInternal       doxyText
hi def link doxyLatexonly      doxyCode
hi def link doxyHtmlonly       doxyText
hi def link doxyFormula        doxyCode
hi def link doxyFormulaEnv     doxyHeading

hi def link doxyMdDelimiter       doxyDelimiter
hi def link doxyMdItalic          doxyItalic
hi def link doxyMdBold            doxyBold
hi def link doxyMdStrike          doxyStrike
hi def link doxyMdInlineCode      doxyCode
hi def link doxyMdRule            doxyHeading
hi def link doxyMdH1              doxyHeading
hi def link doxyMdH2              doxyHeading
hi def link doxyMdH3              doxyHeading
hi def link doxyMdH4              doxyHeading
hi def link doxyMdH5              doxyHeading
hi def link doxyMdH6              doxyHeading
hi def link doxyMdHeaderLine      doxyHeading
hi def link doxyMdBlockQuote      doxyCode
hi def link doxyMdFencedCodeBlock doxyCode
hi def link doxyMdCodeBlock       doxyCode
hi def link doxyMdBulletList      doxyMdDelimiter
hi def link doxyMdNumberList      doxyMdDelimiter

hi def link doxyHtmlTag          doxyDelimiter
hi def link doxyHtmlItalic       doxyItalic
hi def link doxyHtmlBold         doxyBold
hi def link doxyHtmlCode         doxyCode
hi def link doxyHtmlStrike       doxyStrike
hi def link doxyHtmlUnderline    doxyUnderline
hi def link doxyHtmlSmall        doxyEscaped
hi def link doxyHtmlSub          doxyEscaped
hi def link doxyHtmlSup          doxyEscaped
hi def link doxyHtmlH1           doxyHeading
hi def link doxyHtmlH2           doxyHeading
hi def link doxyHtmlH3           doxyHeading
hi def link doxyHtmlH4           doxyHeading
hi def link doxyHtmlH5           doxyHeading
hi def link doxyHtmlH6           doxyHeading
hi def link doxyHtmlCenter       doxyText
hi def link doxyHtmlPreformatted doxyCode
hi def link doxyHtmlBlockQuote   doxyCode
hi def link doxyHtmlSpan         doxyText
hi def link doxyHtmlDiv          doxyText
hi def link doxyHtmlList         doxyText
hi def link doxyHtmlItemTitle    doxyHeading
hi def link doxyHtmlItemDesc     doxyText
hi def link doxyHtmlTable        doxyText
hi def link doxyHtmlCaption      doxyHeading
hi def link doxyHtmlTableRow     doxyText
hi def link doxyHtmlTableHeader  doxyHeading
hi def link doxyHtmlTableData    doxyText
hi def link doxyHtmlLink         doxyTitle
hi def link doxyHtmlImage        doxyHtmlTag

hi def link doxyPyDelimiter Comment

if !exists('b:current_syntax')
    let b:current_syntax = 'doxygen'
else
    let b:current_syntax = b:current_syntax.'.doxygen'
endif

