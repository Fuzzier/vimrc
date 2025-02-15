::@ECHO OFF

CALL GetDateTime
SET __7z_date__=%__year__%%__month__%%__day__%

:: https://stackoverflow.com/questions/53283240/how-to-create-tar-file-with-7zip

:: To compress general files.
:: -sccUTF-8: console output UTF-8
:: -bt: show time statistics
:: -slp: use large memory pages
:: -mx1: compression level fastest (key factor for compression speed)
:: -md=27: dictionary size 2^27=128MB (key factor for compression ratio)
:: -mmf=hc4: match finder hc4 (hash chain 4B, key factor for compression speed)
:: -mfb=273: word size 273B
:: -ms=4g: solid block size 4GB
:: -mmt: multithreading (use all CPU cores)
:: -mmtf: multithreading for filters
:: -myx: analyze all files
:: -mqs: sort by type (better compression ratio)
:: -mhe: encrypt archive header
SET __7z_lzma_args__=-sccUTF-8 -bt -slp -mx1 -md=27 -mfb=273 -ms=4g -mmt -mmtf -myx -mqs -mhe

:: To compress with hard and symbolic links.
:: -an: no archive_name field
:: -snh: keep hard links
:: -snl: keep symbolic links
SET __7z_tar_args__=-an -snh -snl

PUSHD ..

SET vimfiles=vimfiles

:: To exclude files and directories.
SET __7z_x_args__=-x!%vimfiles%\bak -x!%vimfiles%\session -x!%vimfiles%\sessions -x!%vimfiles%\swp -x!%vimfiles%\tags -x!%vimfiles%\undo -x!%vimfiles%\nvim -xr!.local -xr!.ccls-cache

:: a: add to archive
:: -ttar: create tarball
:: -so: write to stdout
:: -si: read from stdin
SET __7z_file__=..\vimfiles-%__7z_date__%.7z
7z.exe a %__7z_x_args__% %__7z_lzma_args__% %__7z_file__% vimfiles README.md make-link.cmd pack-vim-7z.cmd
:: 7z.exe a -ttar -so %__7z_tar_args__% %__7z_x_args__% vimfiles README.md make-link.cmd pack-vim-7z.cmd | 7z.exe a -si %__7z_lzma_args__% %__7z_file__%

POPD
EXIT /B
