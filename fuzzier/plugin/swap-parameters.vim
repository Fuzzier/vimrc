vim9script

#===============================================================================
# @file
#
# @brief Swap parameters around comma.
#
# @author Wei Tang <gauchyler@uestc.edu.cn>
# @date 2025-08-08
#===============================================================================

const kSwapLeft = 'left'
const kSwapRight = 'right'

# This function uses 1-based byte columns, not character columns.
# `pat` must match only one-byte delimiters.
#
# @param[in] pat       Vim regex pattern for one-byte delimiters.
# @param[in] line      Line text to search.
# @param[in] start_col The 1-based byte column, inclusive.
#                      Use `0` to search from the end of line.
# @return #{col: number, delim: string}
#         col   1-based byte column of the found delimiter.
#               0 if no delimiter is found.
#         delim The found delimiter, or '' if no delimiter is found.
def FindPrevDelim(pat: string, line: string, start_col: number): dict<any>
    var max_col = start_col
    if max_col == 0
        max_col = strlen(line)
    endif
    # Find the pattern
    var col = 0
    var delim = ''
    var index = 0
    while true
        index = match(line, pat, index)
        if index == -1 || index >= max_col
            break
        endif
        delim = line[index]
        col = index + 1
        index += 1
    endwhile
    return {'col': col, 'delim': delim}
enddef

# Find the previous delimiter matched by `pat` before or at `start_line_col`.
#
# `start_line_col` is a 1-based byte column, not a character column.
# Use 0 to search from the end of the starting line.
#
# If no delimiter is found on the starting line, search previous lines
# down to `min_line_num` / `min_line_col`, inclusive.
#
# @param[in] pat            Vim regex pattern for one-byte delimiters.
# @param[in] start_line_num Starting line number, 1-based.
# @param[in] start_line_col The 1-based byte column on the starting line,
#                           inclusive. Use 0 for end of line.
# @param[in] min_line_num   Lower line bound, inclusive.
# @param[in] min_line_col   Lower column bound on `min_line_num`,
#                           inclusive. Use 0 for end of line.
#
# @return #{line_num: number, col: number, delim: string}
#         line_num  Line number where the delimiter was found.
#                   0 if no delimiter is found.
#         col       1-based byte column of the found delimiter.
#                   0 if no delimiter is found.
#         delim     The found delimiter, or '' if no delimiter is found.
def FindPrevDelimEx(pat: string,
                    start_line_num: number,
                    start_line_col: number,
                    min_line_num: number,
                    min_line_col: number): dict<any>
    var actual_min_line_num = max([1, min_line_num])
    var search_line_num = min([line('$'), start_line_num])
    var search_line_col = start_line_col
    while search_line_num >= actual_min_line_num
        var result = FindPrevDelim(pat, getline(search_line_num), search_line_col)
        if result.col != 0
            if search_line_num > actual_min_line_num
               || min_line_col <= 0
               || result.col >= min_line_col
                return {'line_num': search_line_num,
                        'col': result.col,
                        'delim': result.delim}
            endif
            return {'line_num': 0, 'col': 0, 'delim': ''}
        endif
        search_line_num -= 1
        search_line_col = 0
    endwhile
    return {'line_num': 0, 'col': 0, 'delim': ''}
enddef

# Find the next delimiter matched by `pat` after or at `start_col`.
#
# This function uses 1-based byte columns, not character columns.
# `pat` must match only one-byte delimiters.
#
# @param[in] pat       Vim regex pattern for one-byte delimiters.
# @param[in] line      Line text to search.
# @param[in] start_col The 1-based byte column, inclusive.
#                      It must be positive.
# @return #{col: number, delim: string}
#         col   1-based byte column of the found delimiter.
#               0 if no delimiter is found.
#         delim The found delimiter, or '' if no delimiter is found.
def FindNextDelim(pat: string, line: string, start_col: number): dict<any>
    var start_index = max([0, start_col - 1])
    var index = match(line, pat, start_index)
    if index == -1
        return {'col': 0, 'delim': ''}
    endif
    return {'col': index + 1, 'delim': line[index]}
enddef

# Find the next delimiter matched by `pat` after or at `start_line_col`.
#
# `start_line_col` is a 1-based byte column, not a character column.
# Use 0 to search from the beginning of the starting line.
#
# If no delimiter is found on the starting line, search following lines
# up to `max_line_num` / `max_line_col`, inclusive.
#
# @param[in] pat            Vim regex pattern for one-byte delimiters.
# @param[in] start_line_num Starting line number, 1-based.
# @param[in] start_line_col The 1-based byte column on the starting line,
#                           inclusive. Use 0 for beginning of line.
# @param[in] max_line_num   Upper line bound, inclusive.
# @param[in] max_line_col   Upper column bound on `max_line_num`,
#                           inclusive. Use 0 for end of line.
# @return #{line_num: number, col: number, delim: string}
#         line_num  Line number where the delimiter was found.
#                   0 if no delimiter is found.
#         col       1-based byte column of the found delimiter.
#                   0 if no delimiter is found.
#         delim     The found delimiter, or '' if no delimiter is found.
def FindNextDelimEx(pat: string,
                    start_line_num: number,
                    start_line_col: number,
                    max_line_num: number,
                    max_line_col: number): dict<any>
    var actual_max_line_num = max([1, min([line('$'), max_line_num])])
    var search_line_num = max([1, start_line_num])
    var search_line_col = start_line_col
    while search_line_num <= actual_max_line_num
        var result = FindNextDelim(pat, getline(search_line_num),
                                        search_line_col)
        if result.col != 0
            if search_line_num < actual_max_line_num
               || max_line_col <= 0
               || result.col <= max_line_col
                return {'line_num': search_line_num,
                        'col': result.col,
                        'delim': result.delim}
            endif
            return {'line_num': 0, 'col': 0, 'delim': ''}
        endif
        search_line_num += 1
        search_line_col = 1
    endwhile
    return {'line_num': 0, 'col': 0, 'delim': ''}
enddef

# Find the matching close delimiter.
#
# This function uses 1-based byte columns, not character columns.
#
# @param[in] open_delim     One of '{', '[', '(', '<'.
# @param[in] start_line_num Starting line number, 1-based.
# @param[in] start_line_col Search starts after this 1-based byte column,
#                           inclusive. Use 0 for start of line.
# @param[in] max_line_num   Upper line bound, inclusive.
# @param[in] max_line_col   Upper column bound on `max_line_num`,
#                           inclusive. Use 0 for end of line.
# @return #{line_num: number, col: number, delim: string}
#         line_num Line number of the matching close delimiter.
#                  0 if no matching delimiter is found.
#         col      1-based byte column of the found delimiter.
#                  0 if no matching delimiter is found.
#         delim    The found delimiter, or '' if no matching delimiter is found.
def FindMatchingDelim(open_delim: string,
                      start_line_num: number,
                      start_line_col: number,
                      max_line_num: number,
                      max_line_col: number): dict<any>
    var open_pat = ''
    var close_pat = ''
    var close_delim = ''
    if open_delim == '('
        open_pat = '\V('
        close_pat = '\V)'
        close_delim = ')'
    elseif open_delim == '['
        open_pat = '\V['
        close_pat = '\V]'
        close_delim = ']'
    elseif open_delim == '{'
        open_pat = '\V{'
        close_pat = '\V}'
        close_delim = '}'
    elseif open_delim == '<'
        open_pat = '<\(=\)\@!'
        close_pat = '\(-\|=\)\@<!>'
        close_delim = '>'
    else
        return {'line_num': 0, 'col': 0, 'delim': ''}
    endif
    var depth = 1
    var actual_max_line_num = min([line('$'), max_line_num])
    var search_line_num = max([1, start_line_num])
    # Search after the `open_delim` itself.
    var search_col_num = start_line_col + 1
    while search_line_num <= actual_max_line_num
        var line = getline(search_line_num)
        var num_cols = strlen(line)
        while search_col_num <= num_cols
            var open_result = FindNextDelim(open_pat, line, search_col_num)
            var close_result = FindNextDelim(close_pat, line, search_col_num)
            var next_open_col = open_result.col
            var next_close_col = close_result.col
            if search_line_num == actual_max_line_num
               && max_line_col > 0
               if next_open_col != 0 && next_open_col > max_line_col
                   next_open_col = 0
               endif
               if next_close_col != 0 && next_close_col > max_line_col
                   next_close_col = 0
               endif
            endif
            if next_open_col == 0 && next_close_col == 0
                break
            endif
            if next_close_col != 0
               && (next_open_col == 0 || next_close_col < next_open_col)
                depth -= 1
                if depth == 0
                    return {'line_num': search_line_num,
                            'col': next_close_col,
                            'delim': close_delim}
                endif
                search_col_num = next_close_col + 1
            else
                depth += 1
                search_col_num = next_open_col + 1
            endif
        endwhile
        search_line_num += 1
        search_col_num = 1
    endwhile
    return {'line_num': 0, 'col': 0, 'delim': ''}
enddef

def IsPosBefore(line1: number, col1: number,
                line2: number, col2: number): bool
    return line1 < line2 || line1 == line2 && col1 < col2
enddef

def IsPosAfter(line1: number, col1: number,
               line2: number, col2: number): bool
    return line1 > line2 || line1 == line2 && col1 > col2
enddef

def IsPosBeforeOrAt(line1: number, col1: number,
                    line2: number, col2: number): bool
    return line1 < line2 || line1 == line2 && col1 <= col2
enddef

def IsPosAfterOrAt(line1: number, col1: number,
                   line2: number, col2: number): bool
    return line1 > line2 || line1 == line2 && col1 >= col2
enddef

# Find the next non-blank ASCII character.
#
# This function uses 1-based byte columns, not character columns.
#
# @param[in] start_line_num Starting line number, 1-based.
# @param[in] start_line_col The 1-based byte column on the starting line,
#                           inclusive. Use 0 for beginning of line.
# @param[in] max_line_num   Upper line bound, inclusive.
# @param[in] max_line_col   Upper column bound on `max_line_num`, inclusive.
#                           inclusive. Use 0 for end of line.
#
# @pre start_line_num/start_line_col is before or at max_line_num/max_line_col.
#
# @return #{line_num: number, col: number}
#         line_num  Line number of the found character.
#                   0 if no non-blank character is found.
#         col       1-based byte column of the found character.
#                   0 if no non-blank character is found.
def FindNextNonblank(start_line_num: number,
                     start_line_col: number,
                     max_line_num: number,
                     max_line_col: number): dict<number>
    var actual_max_line_num = min([line('$'), max_line_num])
    var search_line_num = max([1, start_line_num])
    var search_line_col = max([1, start_line_col])
    while search_line_num <= actual_max_line_num
        var line = getline(search_line_num)
        var index = match(line, '[^ \t]', search_line_col - 1)
        if index != -1
            if search_line_num < actual_max_line_num
               || max_line_col <= 0
               || index < max_line_col
                return {'line_num': search_line_num, 'col': index + 1}
            endif
        endif
        search_line_num += 1
        search_line_col = 1
    endwhile
    return {'line_num': 0, 'col': 0}
enddef

# Find the smallest enclosing delimited region around
# [`start_line_num`, `start_line_col`].
#
# Opening delimiters are:
#   {  [  (  <
#   except <=
#
# This function uses 1-based byte columns, not character columns.
#
# @param[in] start_line_num Cursor/start line number, 1-based.
# @param[in] start_line_col Cursor/start column, 1-based byte column,
#                           inclusive. Use 0 for beginning of line.
# @param[in] min_line_num   Lower line bound, inclusive.
# @param[in] min_line_col   Lower column bound on `min_line_num`,
#                           inclusive. Use 0 for beginning of line.
# @param[in] max_line_num   Upper line bound, inclusive.
# @param[in] max_line_col   Upper column bound on `max_line_num`,
#                           inclusive. Use 0 for end of line.
#
# @return #{open_line_num: number, open_col: number,
#           close_line_num: number, close_col: number,
#           open_delim: string, close_delim: string}
#         If no enclosing region is found, all position fields are 0
#         and delimiters are ''.
def FindEnclosingRegion(start_line_num: number,
                        start_line_col: number,
                        min_line_num: number,
                        min_line_col: number,
                        max_line_num: number,
                        max_line_col: number): dict<any>
    var actual_min_line_num = max([1, min_line_num])
    var actual_max_line_num = min([line('$'), max_line_num])
    var open_pat = '[{[(]\|<\(=\)\@!'
    var search_line_num = max([1, start_line_num])
    var search_line_col = start_line_col
    while search_line_num >= actual_min_line_num
        var prev = FindPrevDelimEx(open_pat, search_line_num, search_line_col,
                                   actual_min_line_num, min_line_col)
        # No enclosing region.
        if prev.col == 0
            break
        endif
        var close = FindMatchingDelim(prev.delim, prev.line_num, prev.col,
                                      actual_max_line_num, max_line_col)
        if close.col != 0
           && IsPosBeforeOrAt(prev.line_num, prev.col,
                              start_line_num, start_line_col)
           && IsPosAfterOrAt(close.line_num, close.col,
                             start_line_num, start_line_col)
            return {'open_line_num': prev.line_num,
                    'open_col': prev.col,
                    'close_line_num': close.line_num,
                    'close_col': close.col,
                    'open_delim': prev.delim,
                    'close_delim': close.delim}
        endif
        # Continue searching before this opening delimiter.
        search_line_num = prev.line_num
        search_line_col = prev.col - 1
        if search_line_col <= 0
            search_line_num -= 1
            search_line_col = 0
        endif
    endwhile
    return {'open_line_num': 0,
            'open_col': 0,
            'close_line_num': 0,
            'close_col': 0,
            'open_delim': '',
            'close_delim': ''}
enddef

# Find the next comma-separated element in a delimited region.
#
# Search starts from `start_line_num` / `start_line_col`.
# The search stops before or at `max_line_num` / `max_line_col`.
#
# This function uses 1-based byte columns, not character columns.
#
# @param[in] start_line_num Starting line number, 1-based.
# @param[in] start_line_col The 1-based byte column on the starting line,
#                           inclusive. Use 0 for beginning of line.
# @param[in] max_line_num   Upper line bound, inclusive.
# @param[in] max_line_col   Upper column bound on `max_line_num`,
#                           inclusive. Use 0 for end of line.
# @return #{start_line_num: number, start_line_col: number,
#           end_line_num: number, end_line_col: number,
#           comma_line_num: number, comma_line_col: number}
#         If no element is found, all fields are 0.
#         The element range excludes the comma.
#         comma_* is 0 if this is the last element.
def FindNextElem(start_line_num: number,
                 start_line_col: number,
                 max_line_num: number,
                 max_line_col: number): dict<number>
    var actual_max_line_num = max([1, min([line('$'), max_line_num])])
    var actual_max_line_col = max_line_col > 0 ? max_line_col
                            : strlen(getline(actual_max_line_num))
    var nonblank = FindNextNonblank(start_line_num, start_line_col,
                                    actual_max_line_num, actual_max_line_col)
    # Blank region.
    if nonblank.col == 0
        return {'start_line_num': 0,
                'start_line_col': 0,
                'end_line_num': 0,
                'end_line_col': 0,
                'comma_line_num': 0,
                'comma_line_col': 0}
    endif
    var elem_start_line_num = nonblank.line_num
    var elem_start_line_col = nonblank.col
    var search_line_num = elem_start_line_num
    var search_line_col = elem_start_line_col
    var pat = '[{[(,]\|<\(=\)\@!'
    while search_line_num <= actual_max_line_num
        var delim = FindNextDelimEx(pat, search_line_num, search_line_col,
                                    actual_max_line_num, actual_max_line_col)
        # No more delimiter before region end.
        if delim.col == 0
            return {'start_line_num': elem_start_line_num,
                    'start_line_col': elem_start_line_col,
                    'end_line_num': actual_max_line_num,
                    'end_line_col': actual_max_line_col,
                    'comma_line_num': 0,
                    'comma_line_col': 0}
        endif
        # Elem ends before a top-level comma.
        if delim.delim == ','
            return {'start_line_num': elem_start_line_num,
                    'start_line_col': elem_start_line_col,
                    'end_line_num': delim.line_num,
                    'end_line_col': delim.col - 1,
                    'comma_line_num': delim.line_num,
                    'comma_line_col': delim.col}
        endif
        # Skip nested delimited region.
        var close = FindMatchingDelim(delim.delim, delim.line_num, delim.col,
                                      actual_max_line_num, actual_max_line_col)
        if close.col == 0
            return {'start_line_num': elem_start_line_num,
                    'start_line_col': elem_start_line_col,
                    'end_line_num': actual_max_line_num,
                    'end_line_col': actual_max_line_col,
                    'comma_line_num': 0,
                    'comma_line_col': 0}
        endif
        search_line_num = close.line_num
        search_line_col = close.col + 1
    endwhile
    return {'start_line_num': elem_start_line_num,
            'start_line_col': elem_start_line_col,
            'end_line_num': actual_max_line_num,
            'end_line_col': actual_max_line_col,
            'comma_line_num': 0,
            'comma_line_col': 0}
enddef

# Find all comma-separated elements in a delimited region.
#
# The region bounds should normally be the inside of an enclosing region:
#
#   open delimiter + 1  ...  close delimiter - 1
#
# Each element range excludes the separating comma. The comma position after
# the element is stored separately, if any:
#
#   #{start_line_num: number,
#     start_line_col: number,
#     end_line_num: number,
#     end_line_col: number,
#     comma_line_num: number,
#     comma_line_col: number}
#
# Element text starts at the first non-blank character. Leading blanks between
# a comma and the next element are therefore not part of the next element.
# Trailing blanks before a comma or before the region end remain part of the
# previous element.
#
# Nested delimited regions are skipped while searching for top-level commas.
#
# This function uses 1-based byte columns, not character columns.
#
# @param[in] start_line_num Starting line number, 1-based.
# @param[in] start_line_col The 1-based byte column on the starting line,
#                           inclusive. Use 0 for beginning of line.
# @param[in] end_line_num   Upper line bound, inclusive.
# @param[in] end_line_col   Upper column bound on `end_line_num`, inclusive.
#                           Use 0 for end of line.
#
# @return List of element dicts.
#         Returns an empty list if the region contains no element.
def FindAllElems(min_line_num: number,
                 min_line_col: number,
                 max_line_num: number,
                 max_line_col: number): list<dict<number>>
    var elems: list<dict<number>> = []
    var search_line_num = min_line_num
    var search_line_col = min_line_col
    while true
        var elem = FindNextElem(search_line_num, search_line_col,
                                max_line_num, max_line_col)
        if elem.start_line_num == 0
            break
        endif
        add(elems, elem)
        # Continue after this element.
        search_line_num = elem.end_line_num
        search_line_col = elem.end_line_col + 1
        # Skip comma if the element ended immediately before one.
        var comma = FindNextDelimEx('\V,', search_line_num, search_line_col,
                                    max_line_num, max_line_col)
        if comma.col == 0
            break
        endif
        search_line_num = comma.line_num
        search_line_col = comma.col + 1
    endwhile
    return elems
enddef

# Find the index of the element referred to by the cursor.
#
# `elems` must be the list of comma-separated elements in an enclosing region.
# Each element range excludes the separating comma, but stores the comma
# position after the element, if any:
#
#   #{
#       start_line_num: number,
#       start_line_col: number,
#       end_line_num: number,
#       end_line_col: number,
#       comma_line_num: number,
#       comma_line_col: number,
#   }
#
# Cursor ownership rules:
#   - Before or at the first element start => first element.
#   - Inside an element text range => that element.
#   - After an element text range but before or at its comma => that element.
#   - After a comma but before or at the next element start => next element.
#   - After the last element, up to the enclosing region end => last element.
#
# This function uses 1-based byte columns, not character columns.
#
# @param[in] elems           Element list.
# @param[in] cursor_line_num Cursor line number, 1-based.
# @param[in] cursor_line_col Cursor column, 1-based byte column.
# @return Index into `elems`.
#         Returns -1 if `elems` is empty.
def FindElemIndexAtCursor(elems: list<dict<any>>,
                          cursor_line_num: number,
                          cursor_line_col: number): number
    if empty(elems)
        return -1
    endif
    # Cursor before or at first elem start refers to first elem.
    if IsPosBeforeOrAt(cursor_line_num, cursor_line_col,
                       elems[0].start_line_num, elems[0].start_line_col)
        return 0
    endif
    var num_elems = len(elems)
    for i in range(0, num_elems - 1)
        var elem = elems[i]
        # Cursor inside element text.
        if IsPosBeforeOrAt(elem.start_line_num, elem.start_line_col,
                           cursor_line_num, cursor_line_col)
           && IsPosBeforeOrAt(cursor_line_num, cursor_line_col,
                              elem.end_line_num, elem.end_line_col)
            return i
        endif
        # Cursor after element text, before or at comma => current elem.
        if elem.comma_line_num != 0
           && IsPosBefore(elem.end_line_num, elem.end_line_col,
                          cursor_line_num, cursor_line_col)
           && IsPosBeforeOrAt(cursor_line_num, cursor_line_col,
                              elem.comma_line_num, elem.comma_line_col)
            return i
        endif
        # Cursor after comma, before or at next elem start => next elem.
        if elem.comma_line_num != 0 && i + 1 < num_elems
            var next = elems[i + 1]
            if IsPosAfter(cursor_line_num, cursor_line_col,
                          elem.comma_line_num, elem.comma_line_col)
               && IsPosBeforeOrAt(cursor_line_num, cursor_line_col,
                                  next.start_line_num, next.start_line_col)
                return i + 1
            endif
        endif
    endfor
    # Cursor after last elem up to closing delimiter => last elem.
    return num_elems - 1
enddef

# Find the source and destination element indexes for a swap.
#
# `from` is the element referred to by the cursor.
# `to` is the adjacent element in `direction`.
#
# If the cursor element cannot move in the requested direction, `from` and `to`
# are both set to the cursor element index.
#
# @param[in] direction Either `kSwapLeft` or `kSwapRight`.
#
# @return #{from: number, to: number}
#         Returns #{from: -1, to: -1} if `elems` is empty, the cursor does not
#         refer to an element, or `direction` is invalid.
def FindElemIndexesToSwap(elems: list<dict<any>>,
                          cursor_line_num: number,
                          cursor_line_col: number,
                          direction: string): dict<number>
    var num_elems = len(elems)
    if num_elems == 0
        return {'from': -1, 'to': -1}
    endif
    var index = FindElemIndexAtCursor(elems, cursor_line_num, cursor_line_col)
    if index < 0
        return {'from': -1, 'to': -1}
    endif
    if direction == kSwapLeft
        if index == 0
            return {'from': 0, 'to': 0}
        endif
        return {'from': index, 'to': index - 1}
    endif
    if direction == kSwapRight
        if index >= num_elems - 1
            return {'from': index, 'to': index}
        endif
        return {'from': index, 'to': index + 1}
    endif
    return {'from': -1, 'to': -1}
enddef

def ConcatText(lhs: list<string>, rhs: list<string>): list<string>
    if empty(lhs)
        return copy(rhs)
    endif
    if empty(rhs)
        return copy(lhs)
    endif
    var result = copy(lhs)
    result[-1] ..= rhs[0]
    if len(rhs) > 1
        extend(result, rhs[1 :])
    endif
    return result
enddef

def GetRangeText(start_line_num: number,
                 start_line_col: number,
                 end_line_num: number,
                 end_line_col: number): list<string>
    if start_line_num == end_line_num && start_line_col > end_line_col
        return ['']
    endif
    if start_line_num == end_line_num
        var line = getline(start_line_num)
        return [strpart(line, start_line_col - 1,
                        end_line_col - start_line_col + 1)]
    endif
    var result: list<string> = []
    add(result, strpart(getline(start_line_num), start_line_col - 1))
    for line_num in range(start_line_num + 1, end_line_num - 1)
        add(result, getline(line_num))
    endfor
    add(result, strpart(getline(end_line_num), 0, end_line_col))
    return result
enddef

def ReplaceRange(start_line_num: number,
                 start_line_col: number,
                 end_line_num: number,
                 end_line_col: number,
                 text: list<string>)
    var before = strpart(getline(start_line_num), 0, start_line_col - 1)
    var after = strpart(getline(end_line_num), end_line_col)
    var replacement = copy(text)
    replacement[0] = before .. replacement[0]
    replacement[-1] ..= after
    var old_num_lines = end_line_num - start_line_num + 1
    var new_num_lines = len(replacement)
    setline(start_line_num, replacement[0])
    if new_num_lines > 1
        append(start_line_num, replacement[1 :])
    endif
    var delete_start = start_line_num + new_num_lines
    var delete_end = start_line_num + new_num_lines + old_num_lines - 2
    if delete_start <= delete_end
        deletebufline('', delete_start, delete_end)
    endif
enddef

def AdvancePosByText(start_line_num: number,
                     start_line_col: number,
                     text: list<string>): dict<number>
    if empty(text)
        return {'line_num': start_line_num, 'col': start_line_col}
    endif
    if len(text) == 1
        return {'line_num': start_line_num,
                'col': start_line_col + strlen(text[0])}
    endif
    return {'line_num': start_line_num + len(text) - 1,
            'col': strlen(text[-1]) + 1}
enddef

# Swap two adjacent element text ranges.
#
# `elems` must contain element ranges excluding commas.
# `indexes` must be #{from: number, to: number}.
#
# Only the element text ranges are swapped. The comma / whitespace gap between
# the two elements remains in place.
#
# @return #{line_num: number, col: number}
#         Position of the moved element at its new location.
#         Returns #{line_num: 0, col: 0} if nothing was swapped.
def SwapElemsByIndexes(elems: list<dict<any>>,
                       indexes: dict<number>): dict<number>
    var from_index = indexes.from
    var to_index = indexes.to
    if from_index < 0 || to_index < 0
        return {'line_num': 0, 'col': 0}
    endif
    if from_index == to_index
        var elem = elems[from_index]
        return {'line_num': elem.start_line_num, 'col': elem.start_line_col}
    endif
    # Elements must be adjacent.
    if abs(from_index - to_index) != 1
        return {'line_num': 0, 'col': 0}
    endif
    var first_index = min([from_index, to_index])
    var second_index = max([from_index, to_index])
    var first = elems[first_index]
    var second = elems[second_index]
    var first_text = GetRangeText(first.start_line_num, first.start_line_col,
                                  first.end_line_num, first.end_line_col)
    var gap_text = GetRangeText(first.end_line_num, first.end_line_col + 1,
                                second.start_line_num, second.start_line_col - 1)
    var second_text = GetRangeText(second.start_line_num, second.start_line_col,
                                   second.end_line_num, second.end_line_col)
    var moved_right_prefix = ConcatText(second_text, gap_text)
    var new_text = ConcatText(moved_right_prefix, first_text)
    ReplaceRange(first.start_line_num, first.start_line_col,
                 second.end_line_num, second.end_line_col,
                 new_text)
    # If moving left, moved elem is now at first.start.
    if from_index == second_index
        return {'line_num': first.start_line_num, 'col': first.start_line_col}
    endif
    # Moving right: original first element now starts after second text + gap.
    return AdvancePosByText(first.start_line_num, first.start_line_col,
                            moved_right_prefix)
enddef

# Swap the element at [`start_line_num`, `start_line_col`] with its adjacent
# element in `direction`.
#
# The search is limited by [`min_line_num`, `min_line_col`] and
# [`max_line_num`, `max_line_col`].
#
# @param[in] direction Either 'left' or 'right'.
#
# @return true if a swap was performed, false otherwise.
def SwapElems(start_line_num: number,
              start_line_col: number,
              direction: string,
              min_line_num: number,
              min_line_col: number,
              max_line_num: number,
              max_line_col: number): bool
    var region = FindEnclosingRegion(start_line_num, start_line_col,
                                     min_line_num, min_line_col,
                                     max_line_num, max_line_col)
    if region.open_line_num == 0
        return false
    endif
    # Elements are inside the enclosing delimiters.
    var elem_start_line_num = region.open_line_num
    var elem_start_line_col = region.open_col + 1
    var elem_end_line_num = region.close_line_num
    var elem_end_line_col = region.close_col - 1
    if elem_end_line_col <= 0
        elem_end_line_num -= 1
        elem_end_line_col = 0
    endif
    var elems = FindAllElems(elem_start_line_num, elem_start_line_col,
                             elem_end_line_num, elem_end_line_col)
    if len(elems) < 2
        return false
    endif
    var indexes = FindElemIndexesToSwap(elems, start_line_num,
                                        start_line_col, direction)
    if indexes.from < 0 || indexes.to < 0 || indexes.from == indexes.to
        return false
    endif
    var pos = SwapElemsByIndexes(elems, indexes)
    if pos.line_num == 0
        return false
    endif
    cursor(pos.line_num, pos.col)
    return true
enddef

def SwapElemsAtCursor(direction: string): bool
    var pos = getpos('.')
    var start_line_num = pos[1]
    var start_line_col = pos[2]
    var min_line_num = start_line_num - 10
    var min_line_col = 0
    var max_line_num = start_line_num + 10
    var max_line_col = 0
    var succ = SwapElems(start_line_num, start_line_col,
                         direction,
                         min_line_num, min_line_col,
                         max_line_num, max_line_col)
    return succ
enddef

def SwapParamToRight()
    SwapElemsAtCursor(kSwapRight)
    if exists('*repeat#set')
        repeat#set("\<Plug>(SwapParamToRight)")
    endif
enddef

def SwapParamToLeft()
    SwapElemsAtCursor(kSwapLeft)
    if exists('*repeat#set')
        repeat#set("\<Plug>(SwapParamToLeft)")
    endif
enddef

nnoremap <silent> <Plug>(SwapParamToRight) <ScriptCmd>SwapParamToRight()<CR>
nnoremap <silent> <Plug>(SwapParamToLeft)  <ScriptCmd>SwapParamToLeft()<CR>

nnoremap <silent> g> <Plug>(SwapParamToRight)
nnoremap <silent> g< <Plug>(SwapParamToLeft)

