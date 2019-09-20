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
set conceallevel=2
set concealcursor=nc

syn sync fromstart " ccomment doxyBody

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" C-style multi-line
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
  \ . 'end=+\%(\_s[0-9A-Za-z_*]\+\)\@<=[0-9A-Za-z_*]\@!+ '
  \ . 'end=+[@\\]+me=e-1 '
  \ . 'contained contains=doxyContinue,doxyItalicWord'

" \_s\@<=   match after a space or eol, do not match the command '@a'.
execu 'syn match doxyItalicWord '
  \ . '+\_s\@<=\%([0-9A-Za-z_*]\@<![0-9A-Za-z_*]\+\)[0-9A-Za-z_*]\@!+ '
  \ . 'display contained'

" Bold word: @xxx <word>
execu 'syn region doxyFont '
  \ . 'start=+[@\\]b\>+ '
  \ . 'end=+\%(\_s[0-9A-Za-z_*]\+\)\@<=[0-9A-Za-z_*]\@!+ '
  \ . 'end=+[@\\]+me=e-1 '
  \ . 'contained contains=doxyContinue,doxyBoldWord'

execu 'syn match doxyBoldWord '
  \ . '+\_s\@<=\%([0-9A-Za-z_*]\@<![0-9A-Za-z_*]\+\)[0-9A-Za-z_*]\@!+ '
  \ . 'contained'

" Code word: @xxx <word>
execu 'syn region doxyFont '
  \ . 'start=+[@\\][cp]\>+ '
  \ . 'end=+\%(\_s[0-9A-Za-z_*]\+\)\@<=[0-9A-Za-z_*]\@!+ '
  \ . 'end=+[@\\]+me=e-1 '
  \ . 'contained contains=doxyContinue,doxyCodeWord'

execu 'syn match doxyCodeWord '
  \ . '+\_s\@<=\%([0-9A-Za-z_*]\@<![0-9A-Za-z_*]\+\)[0-9A-Za-z_*]\@!+ '
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
" Text sections
""""""""""""""""""""""""""""""""""""""""
" A common text section: @xxx {text}
"   brief short details author authors version date      since pre post
"   attention   warning note   remark  remarks invariant copyright todo
"   test  bug   deprecated     return  returns result sa see
execu 'syn match doxySection '
  \ . '+[@\\]\%(brief\|short\|details\|author\|authors\|version\|date\|since\|'
  \ .          'pre\|post\|remark\|remarks\|invariant\|copyright\|return\|'
  \ .          'returns\|result\|sa\|see\)\>+ '
  \ . 'display contained'

execu 'syn region doxyTodo '
  \ . 'start=+[@\\]\%(attention\|warning\|note\|todo\|test\|bug\|deprecated\)\>+ '
  \ . 'end=+[@\\]+me=e-1 '
  \ . 'display contained keepend contains=doxyContinue'

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
  \ . 'display contained skipwhite nextgroup=doxyParamIO'

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
  \ . 'display contained skipwhite nextgroup=doxyTitle'

" @xxx
syn match doxyFunction +[@\\]\%(callgraph\|callergraph\)\>+ display contained

""""""""""""""""""""""""""""""""""""""""
" Entity
""""""""""""""""""""""""""""""""""""""""
" @xxx <name>
" file namespace def package
execu 'syn match doxyEntity +[@\\]\%(file\|namespace\|def\|package\)\>+ '
  \ . 'display contained skipwhite nextgroup=doxyName'

" @xxx <name> [<header-file>] [<header-name>]
" class struct interface union enum
execu 'syn match doxyEntity +[@\\]\%(class\|struct\|interface\|union\|enum\)\>+ '
  \ . 'display contained skipwhite nextgroup=doxyName'

" @xxx (declaration)
" fn var property typedef
execu 'syn match doxyEntity +[@\\]\%(fn\|var\|property\|typedef\)\>+ '
  \ . 'display contained skipwhite nextgroup=doxyTitle'

""""""""""""""""""""""""""""""""""""""""
" Group
""""""""""""""""""""""""""""""""""""""""
" @ingroup <name> [<name> ...]
execu 'syn match doxyGrouping '
  \ . '+[@\\]ingroup\>+ '
  \ . 'display contained skipwhite nextgroup=doxyNames'

" @xxx <name> (title)
execu 'syn match doxyGrouping '
  \ . '+[@\\]\%(defgroup\|addtogroup\|weakgroup\)\>+ '
  \ . 'display contained skipwhite nextgroup=doxyNameTitle'

""""""""""""""""""""""""""""""""""""""""
" Page
""""""""""""""""""""""""""""""""""""""""
" @xxx <name> (title)
" page subpage section subsection subsubsection paragraph
execu 'syn match doxyPaging '
  \ . '+[@\\]\%(page\|subpage\|section\|subsection\|subsubsection\|paragraph\)\>+ '
  \ . 'display contained skipwhite nextgroup=doxyNameTitle'

" @mainpage <name>
execu 'syn match doxyPaging '
  \ . '+[@\\]mainpage\>+ '
  \ . 'display contained skipwhite nextgroup=doxyName'

" @tableofcontents
execu 'syn match doxyPaging '
  \ . '+[@\\]tableofcontents\>+ '
  \ . 'display contained'

""""""""""""""""""""""""""""""""""""""""
" Blocks
""""""""""""""""""""""""""""""""""""""""
" Code section: @code['{'<word>'}'] {text} @endcode
execu 'syn region doxyCodeBlock matchgroup=doxyMdDelimiter '
  \ . 'start=+@code\%({\.[[:alnum:]]\+}\)\?$+ '
  \ . 'end=+@endcode+ '
  \ . 'contained keepend contains=doxyContinue'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Markdown.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Emphasis
" space/eol *...* space/eol
" space/eol _..._ space/eol
execu 'syn region doxyMdItalic matchgroup=doxyMdDelimiter '
  \ . 'start=+\%(\_s\|[(\[{<,:;]\)\@<=\*[[:alnum:]]\@=+ '
  \ . 'end=+\%(\_s\|[(\[{<=+\-\\@\*]\)\@<!\*[[:alnum:]]\@!+ '
  \ . 'contained contains=doxyContinue,@doxyMdInline '
  \ . b:doxy_concealends
execu 'syn region doxyMdItalic matchgroup=doxyMdDelimiter '
  \ . 'start=+\%(\s\|[(\[{<,:;]\)\@<=_[[:alnum:]]\@=+ '
  \ . 'end=+\%(\_s\|[(\[{<=+\-\\@_]\)\@<!_[[:alnum:]]\@!+ '
  \ . 'contained contains=doxyContinue,@doxyMdInline '
  \ . b:doxy_concealends

" space/eol **...** space/eol
" space/eol __...__ space/eol
execu 'syn region doxyMdBold matchgroup=doxyMdDelimiter '
  \ . 'start=+\%(\_s\|[(\[{<,:;]\)\@<=\*\*[[:alnum:]]\@=+ '
  \ . 'end=+\%(\_s\|[(\[{<=+\-\\@\*]\)\@<!\*\*[[:alnum:]]\@!+ '
  \ . 'contained contains=doxyContinue,@doxyMdInline '
  \ . b:doxy_concealends
execu 'syn region doxyMdBold matchgroup=doxyMdDelimiter '
  \ . 'start=+\%(\s\|[(\[{<,:;]\)\@<=__[[:alnum:]]\@=+ '
  \ . 'end=+\%(\_s\|[(\[{<=+\-\\@_]\)\@<!__[[:alnum:]]\@!+ '
  \ . 'contained contains=doxyContinue,@doxyMdInline '
  \ . b:doxy_concealends

" Strikethrough
" space/eol ~~...~~ space/eol
execu 'syn region doxyMdStrike matchgroup=doxyMdDelimiter '
  \ . 'start=+\%(\_s\|[(\[{<,:;]\)\@<=\~\~[[:alnum:]]\@=+ '
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
syn region doxyMdH2 matchgroup=doxyMdDelimiter start=+#\@<!##\s\@=+     end=+#*\s*$+ display oneline contained contains=@doxyMdInline
syn region doxyMdH3 matchgroup=doxyMdDelimiter start=+#\@<!###\s\@=+    end=+#*\s*$+ display oneline contained contains=@doxyMdInline
syn region doxyMdH4 matchgroup=doxyMdDelimiter start=+#\@<!####\s\@=+   end=+#*\s*$+ display oneline contained contains=@doxyMdInline
syn region doxyMdH5 matchgroup=doxyMdDelimiter start=+#\@<!#####\s\@=+  end=+#*\s*$+ display oneline contained contains=@doxyMdInline
syn region doxyMdH6 matchgroup=doxyMdDelimiter start=+#\@<!######\s\@=+ end=+#*\s*$+ display oneline contained contains=@doxyMdInline

" Underlined headers (limited support: no highlight of the header itself).
syn match doxyMdHeaderLine "\%(^\|\s\)\@<==\+$" display contained

" Block quotes (overrides doxyContinue)
" > quote
" >> quote
" > > quote
" Prevent '>' from starting a block quote within the text: a block quote starts
" from the start of the line, may optionally have a '*', then one or more '>'s.
syn match doxyMdBlockQuote +^\s*\%(\*\s\+\)\?\%(>\s\?\)\+\s\@=+ display contained

" A block quote starts from the start of the line, have '///' or '//!',
" then one or more '>'s.
syn region doxyBody matchgroup=doxyMdDelimiter start=+^\s*//[/!]\s\+\%(>\s\?\)\+\s\@=+ end=+$+

" A block quote starts from the start of the line, have '///<' or '//!<',
" then one or more '>'s.
syn region doxyBody matchgroup=doxyMdDelimiter start=+^\s*//[/!]<\s\+\%(>\s\?\)\+\s\@=+ end=+$+

" Fenced code block
" ```['{'<word>'}']
" ```
syn region doxyMdFencedCodeBlock matchgroup=doxyMdDelimiter start=+\s\@<=`\{3,}\%({\.[[:alnum:]]\+}\)\?$+ end=+\s\@<=`\{3,}\s*$+
  \ contained keepend contains=doxyContinue

" ~~~['{'<word>'}']
" ~~~
syn region doxyMdFencedCodeBlock matchgroup=doxyMdDelimiter start=+\~\{3,}\%({\.[[:alnum:]]\+}\)\?$+ end=+\~\{3,}\s*$+
  \ contained keepend contains=doxyContinue

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
syn match doxyMdBulletList +\s\@<=[\*+-]\s\@=+ display contained
" #. xxx
" 1. xxx
syn match doxyMdNumberList +\%(#\|\d\+\)\.\s\@=+ display contained

" Horizontal rules (put after and override bullet lists)
" * * *
syn match doxyMdRule +\%(\s\)\@<=\%(\*\s*\)\{3,}$+ display contained
" - - -
syn match doxyMdRule +\%(-\s*\)\{3,}$+ display contained
" _ _ _
syn match doxyMdRule +\%(_\s*\)\{3,}$+ display contained


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Clusters.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Anything that can appear within a <word>.
syn cluster doxyInword contains=doxyEscaped

" Anything that can appear within a (line).
syn cluster doxyInline contains=@doxyInword,doxyFont,@doxyMdInline

" Anything that can appear within a {text}.
syn cluster doxyIntext contains=
  \ @doxyInline,doxyContinue,doxyPar,doxyCodeBlock

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
"    doxyCommand (@command)
"    doxyText    (common text)
"
"    @retval <name> {text}
"    doxyName    (e.g., <name>, ...)
"
"    @par [(title)] {text}
"    doxyTitle   (e.g., (title), ...)
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
"    doxyCodeFont
"
"    Italic and bold fonts require a visible color.
"    doxyItalicFont
"    doxyBoldFont
"
"    Strikethrough font requires a dimmer color.
"    doxyStrikeFont

" CR: contrast ratio
" (CR=15.6) 0,0,88; 0,0,3 (white on black)
hi def doxyDelimiter   guifg=#e3e3e3 guibg=#080808
hi def doxyMdDelimiter guifg=#e3e3e3 guibg=#080808
" (CR=15.0) 0,0,97; 0,0,11 (brighter foreground due to brighter background)
hi def doxyContinue    guifg=#f7f7f7 guibg=#1c1c1c
" (CR=14.2) 0,100,85   (white, no recommended to be colorful)
hi def doxyCommand     guifg=#d9d9d9 guibg=#080808
" (CR= 8.2) 180,100,72 (tan on black)
hi def doxyText        guifg=#00b8b8 guibg=#080808
" (CR=11.1) 145,100,87 (shall be the same as the source code)
hi def doxyCodeFont    guifg=#00df5f guibg=#080808 font='Monaco'
hi def doxyItalicFont  guifg=#00df5f guibg=#080808 term=italic cterm=italic gui=italic
hi def doxyBoldFont    guifg=#00df5f guibg=#080808 term=bold   cterm=bold   gui=bold
" (CR= 7.0) 0,0,60     (Strikethrough text is the least significant)
hi def doxyStrikeFont  guifg=#909090 guibg=#080808
" (CR=10.1) 50,100,85  (a doxygen identifier is more significant than the common
"                       text, different from an identifier in the source code)
hi def doxyName        guifg=#c9db00 guibg=#080808
" (CR=10.0) 190,100,94 (a title is more significant than the common text)
hi def doxyTitle       guifg=#00c8f0 guibg=#080808
" (CR= 8.3) 70,100,70  (special characters)
hi def doxyEscaped     guifg=#95b300 guibg=#080808
" (CR=13.0) 65,100,86  (a header is more significant than the common text)
hi def doxyHeading     guifg=#d9b500 guibg=#080808
" (CR=15.0) 60,100,100 (yellow, the brightest of all, quite attractive)
hi def doxyTodo        guifg=#ffff00 guibg=#080808

""""""""""""""""""""""""""""""""""""""""
hi def link doxyBody       doxyText
hi def link doxyNames      doxyName
hi def link doxyNameTitle  doxyName
hi def link doxyFont       doxyCommand
hi def link doxyItalicWord doxyItalicFont
hi def link doxyBoldWord   doxyBoldFont
hi def link doxyCodeWord   doxyCodeFont
hi def link doxyPar        doxyCommand
hi def link doxySection    doxyCommand
hi def link doxyTypeParam  doxyCommand
hi def link doxyFakeClass  doxyCommand
hi def link doxyParam      doxyCommand
hi def link doxyParamIO    doxyName
hi def link doxyFunction   doxyCommand
hi def link doxyEntity     doxyHeading
hi def link doxyGrouping   doxyCommand
hi def link doxyPaging     doxyCommand
hi def link doxyCodeBlock  doxyCodeWord

hi def link doxyMdDelimiter       doxyDelimiter
hi def link doxyMdItalic          doxyItalicFont
hi def link doxyMdBold            doxyBoldFont
hi def link doxyMdStrike          doxyStrikeFont
hi def link doxyMdInlineCode      doxyCodeFont
hi def link doxyMdRule            doxyEscaped
hi def link doxyMdH1              doxyHeading
hi def link doxyMdH2              doxyHeading
hi def link doxyMdH3              doxyHeading
hi def link doxyMdH4              doxyHeading
hi def link doxyMdH5              doxyHeading
hi def link doxyMdH6              doxyHeading
hi def link doxyMdHeaderLine      doxyEscaped
hi def link doxyMdBlockQuote      doxyContinue
hi def link doxyMdFencedCodeBlock doxyCodeFont
hi def link doxyMdCodeBlock       doxyCodeFont
hi def link doxyMdBulletList      doxyMdDelimiter
hi def link doxyMdNumberList      doxyMdDelimiter

if !exists('b:current_syntax')
    let b:current_syntax = 'doxygen'
else
    let b:current_syntax = b:current_syntax.'.doxygen'
endif

