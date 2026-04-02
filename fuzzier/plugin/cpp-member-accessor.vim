""
" @file
" @brief C++ member accessor.
"
" @author Wei Tang <gauchyler@uestc.edu.cn>
" @date 2026-04-02
"

"----------------------------------------
" @return A dictionary { "type": "TypeName", "name": "valueName", "arr": bool }
function! CppParseMemberDefinition(line)
    let s = a:line
    " Remove comments
    let s = substitute(s, '\/\/.*$', '', '')
    let s = substitute(s, '\/\*.*$', '', '')
    " Remove colon
    let s = substitute(s, ';.*$', '', '')
    " Remove initializers
    let s = substitute(s, '{.*$', '', '')
    " Remove whitespaces
    let s = trim(s)
    " Check array
    let arr = v:false
    if s =~ '\[.*\]$'
        let arr = v:true
    endif
    " Remove array
    let s = substitute(s, '\[.*\]$', '', '')
    " Remove whitespaces
    let s = trim(s)
    " Variable name
    let v = matchstr(s, '\<_\=\w*$')
    if empty(v)
        return #{ type: s, name: '', arr: arr }
    endif
    let t = substitute(s, '\s*' . v . '$', '', '')
    return #{ type: t, name: v, arr: arr }
endfunction

"----------------------------------------
function! CppMemberToGetter()
    let mem = CppParseMemberDefinition(getline('.'))
    let rv = mem['name']
    let fn = substitute(mem['name'], '_$', '', '')
    let rt = mem['type']
    " If `type` is const
    let rt_const = v:false
    if rt =~# '^const\s\+'
        let rt_const = v:true
    endif
    " If `type` is pointer
    " - Change the return type to reference
    " - Deference the pointer in the getter
    if rt =~ '\*$'
        let rt = substitute(rt, '\*$', '\&', '')
        let rv = '*' . rv
    " Otherwise, if `type` is value
    " - Change the return type to reference
    elseif rt !~ '&$'
        let rt = rt . '&'
    endif
    " Clear line
    execute 'normal! ^D'
    if mem['arr'] == v:false
        if !rt_const
            execute 'normal! a'. printf('const %s %s(void) const noexcept { return %s; }', rt, fn, rv)
            " Put non-const getter above const getter, for proper indentation.
            execute 'normal! O'. printf('      %s %s(void)       noexcept { return %s; }', rt, fn, rv)
            execute 'normal! j'
        else
            execute 'normal! a'. printf('%s %s(void) const noexcept { return %s; }', rt, fn, rv)
        endif
    else
        if !rt_const
            execute 'normal! a'. printf('const %s %s(size_t index) const noexcept {', rt, fn)
            execute 'normal! o'. printf('return %s[index];', rv)
            execute 'normal! o'. printf('}')
            " Put non-const getter above const getter, for proper indentation.
            execute 'normal! 3k'
            execute 'normal! o'. printf('%s %s(size_t index) noexcept {', rt, fn)
            execute 'normal! o'. printf('return %s[index];', rv)
            execute 'normal! o'. printf('}')
            execute 'normal! 3j'
        else
            execute 'normal! o'. printf('%s %s(size_t index) const noexcept {', rt, fn)
            execute 'normal! o'. printf('return %s[index];', rv)
            execute 'normal! o'. printf('}')
        endif
    endif
    " Add a blank line if the next line is not blank.
    " let s = getline(line('.') + 1)
    " if s !~ '^\s*$'
    "     execute 'normal! o'
    " endif
    " execute 'normal! j'
    " Allow repeat by '.'
    silent! call repeat#set(":call CppMemberToGetter()\<CR>")
endfunction

"----------------------------------------
function! CppIpcMemberToP()
    let mem = CppParseMemberDefinition(getline('.'))
    let rv = mem['name']
    let fn = substitute(mem['name'], '_$', '', '')
    let rt = mem['type']
    " Clear line
    execute 'normal! ^D'
    if mem['arr'] == v:false
        execute 'normal! a'. printf('%s %s(void) const noexcept {', rt, fn)
        execute 'normal! o'. printf('return getb<%s>(ptr() + offsetof_%s());', rt, fn)
        execute 'normal! o}'
        execute 'normal! o'. printf('constexpr size_t offsetof_%s(void) const noexcept {', fn)
        execute 'normal! o'. printf('return off_p0_ + offsetof(p0, %s);', rv)
        execute 'normal! o}'
        execute 'normal! o'
        execute 'normal! j'
    else
        execute 'normal! a'. printf('%s::Parser %s(void) const noexcept {', rt, fn)
        execute 'normal! o'. printf('%s::Parser parser{ptr() + offsetof_%s(), end_};', rt, fn)
        execute 'normal! o'. printf('NSFX_VERIFY(parser.parse());')
        execute 'normal! o'. printf('return parser;')
        execute 'normal! o}'
        execute 'normal! o'. printf('constexpr size_t offsetof_%s(void) const noexcept {', fn)
        execute 'normal! o'. printf('return off_p1_ + offsetof(p1, %s);', rv)
        execute 'normal! o}'
        execute 'normal! o'
        execute 'normal! j'
    endif
    " Allow repeat by '.'
    silent! call repeat#set(":call CppIpcMemberToP()\<CR>")
endfunction

"----------------------------------------
function! CppIpcMemberToE()
    let mem = CppParseMemberDefinition(getline('.'))
    let rv = mem['name']
    let fn = substitute(mem['name'], '_$', '', '')
    let rt = mem['type']
    " Clear line
    execute 'normal! ^D'
    if mem['arr'] == v:false
        execute 'normal! a'. printf('%s %s(void) const noexcept {', rt, fn)
        execute 'normal! o'. printf('return getb<%s>(ptr() + offsetof_%s());', rt, fn)
        execute 'normal! o}'
        execute 'normal! o'. printf('void set_%s(%s %s) noexcept {', fn, rt, fn)
        execute 'normal! o'. printf('assert(size() >= offsetof_%s() + sizeof(%s));', fn, fn)
        execute 'normal! o'. printf('putb(ptr() + offsetof_%s(), %s);', fn, fn)
        execute 'normal! o}'
        execute 'normal! o'. printf('constexpr size_t offsetof_%s(void) const noexcept {', fn)
        execute 'normal! o'. printf('return off_p0_ + offsetof(p0, %s);', rv)
        execute 'normal! o}'
        execute 'normal! o'
        execute 'normal! j'
    else
        execute 'normal! a'. printf('%s::Editor %s(void) const noexcept {', rt, fn)
        execute 'normal! o'. printf('%s::Editor editor{ptr() + offsetof_%s(), end_};', rt, fn)
        execute 'normal! o'. printf('NSFX_VERIFY(editor.parse());')
        execute 'normal! o'. printf('return editor;')
        execute 'normal! o}'
        execute 'normal! o'. printf('constexpr size_t offsetof_%s(void) const noexcept {', fn)
        execute 'normal! o'. printf('return off_p1_ + offsetof(p1, %s);', rv)
        execute 'normal! o}'
        execute 'normal! o'
        execute 'normal! j'
    endif
    " Allow repeat by '.'
    silent! call repeat#set(":call CppIpcMemberToE()\<CR>")
endfunction

"----------------------------------------
function! CppIpcMemberToB()
    let mem = CppParseMemberDefinition(getline('.'))
    let rv = mem['name']
    let fn = substitute(mem['name'], '_$', '', '')
    let rt = mem['type']
    " Clear line
    execute 'normal! ^D'
    if mem['arr'] == v:false
        execute 'normal! a'. printf('void set_%s(%s %s) noexcept {', fn, rt, fn)
        execute 'normal! o'. printf('assert(size() >= offsetof_%s() + sizeof(%s));', fn, fn)
        execute 'normal! o'. printf('putb(ptr() + offsetof_%s(), %s);', fn, fn)
        execute 'normal! o}'
        execute 'normal! o'. printf('constexpr size_t offsetof_%s(void) const noexcept {', fn)
        execute 'normal! o'. printf('return off_p0_ + offsetof(p0, %s);', rv)
        execute 'normal! o}'
        execute 'normal! o'
        execute 'normal! j'
    else
        execute 'normal! a'. printf('%s::Builder put_%s(void) {', rt, fn)
        execute 'normal! o'. printf('assert(size() >= offsetof_%s());', fn)
        execute 'normal! o'. printf('return %s::Builder{buf_};', rt)
        execute 'normal! o}'
        execute 'normal! o'. printf('constexpr size_t offsetof_%s(void) const noexcept {', fn)
        execute 'normal! o'. printf('return off_p1_ + offsetof(p1, %s);', rv)
        execute 'normal! o}'
        execute 'normal! o'
        execute 'normal! j'
    endif
    " Allow repeat by '.'
    silent! call repeat#set(":call CppIpcMemberToB()\<CR>")
endfunction

