# /usr/bin/bash

for d in $(ls bundle/repos)
do
    pushd bundle/repos/$d > /dev/null
    echo $d
    git gc
    git prune
    popd > /dev/null
done

# rm -f bak/*
# rm -f swp/*
# rm -f tags/*
# rm -f sesion/*
# rm -f sessions/*
# rm -f undo/*
# rm -f nvim/undo/*

