::@ECHO OFF

CALL GetDateTime
SET __rar_date__=%__year__%%__month__%%__day__%

:: To compress general files.
:: -htb: use BLAKE2 hash function
:: -m3: compression level normal
:: -md128m: dictionary size 128MB (key factor for compression ratio)
:: -mlp: large memory pages (rar v7.10+)
:: -idn: disables archived names output
:: -oc: set NTFS "Compressed" attribute
:: -oh: save hard links as link
:: -ol: save symbolic links as link
:: -r: recurse subfolders
:: -rr3p: add data recovery record (3 percent)
:: -s: create a solid archive
SET __rar_args__=-htb -m3 -md128m -mlp -idn -oc -r -rr3p -s

PUSHD ..

SET vimfiles=vimfiles

:: To exclude files and directories.
SET __rar_x_args__=-x%vimfiles%\bak -x%vimfiles%\session -x%vimfiles%\sessions -x%vimfiles%\swp -x%vimfiles%\tags -x%vimfiles%\undo -x%vimfiles%\nvim -x**\.local -x**\.ccls-cache

:: a: add to archive
:: -ttar: create tarball
:: -so: write to stdout
:: -si: read from stdin

SET __rar_file__=..\vimfiles-%__rar_date__%.rar
rar.exe a %__rar_args__% %__rar_x_args__% %__rar_file__% vimfiles make-link.cmd

POPD
EXIT /B
