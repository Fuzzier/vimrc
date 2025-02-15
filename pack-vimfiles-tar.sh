#!/usr/bin/bash

# "VIM - Vi IMproved 9.0 (2022 Jun 28, compiled Aug 25 2022 10:53:48)"
# -P: Use Perl compatible syntax for pattern.
# -m 1: Match 1 time.
# -o: Only output the matched part.
vim_majorminor=`vim --version | grep -P '(?<=Vi IMproved )\d\.\d' -m 1 -o`

# I"ncluded patches: 1-260"
# -P: Use Perl compatible syntax for pattern.
# -m 1: Match 1 time.
# -o: Only output the matched part.
vim_patch=`vim --version | grep -P '(?<=Included patches: 1-)\d+' -m 1 -o`

D=$(date +%Y%m%d)

tarfile=vimfiles-$vim_majorminor.$vim_patch-$D
# echo "$tarfile"

pushd .. > /dev/null

tar -acf $tarfile.tar.gz --totals --exclude=.vim/bak --exclude=.vim/swp --exclude=.vim/tags --exclude=.vim/session --exclude=.vim/sessions --exclude=.vim/undo --exclude=.vim/nvim --exclude=.ccls-cache .vim .config/nvim

popd > /dev/null
