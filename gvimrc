"===============================================================================
"         FILE:  gvimrc
"  DESCRIPTION:  suggestion for a personal configuration file gvimrc
"       AUTHOR:  Dr.-Ing. Fritz Mehner <mehner@fh-swf.de>
"      CREATED:  2009-04-04
"     REVISION:  $Id: customization.vimrc,v 1.6 2009/10/03 12:24:30 mehner Exp $
"       AUTHOR:  Wei Tang <gauchyler@uestc.edu.cn>
"     MODIFIED:  2023-10-21
"===============================================================================

"-------------------------------------------------------------------------------
" GUI (window only)
"-------------------------------------------------------------------------------
" Reserve 4 columns for showing line number, plus 1 column for visibility.
set winwidth=88
if has('nvim')
    autocmd WinEnter * :set winwidth=88
endif

if !has('nvim')
    " Support 2 vertically split windows.
    set columns=177

    " For 1440x900.
    " set lines=36
    " For 1920x1080.
    set lines=49

    " Hide scrollbars.
    set go-=rL
endif
