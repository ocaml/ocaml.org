#!/bin/sh


mkdir -p stdlib

SWITCH=playground
SRC_DIR=$HOME/.opam/$SWITCH/lib/ocaml

copylibcmis()  (
  tmpfile=$(mktemp)
  jsoo_listunits -o $tmpfile $2
  for i in $(cat $tmpfile); do
    cp $SRC_DIR/?${i#?}.cmi stdlib/
  done
  rm $tmpfile
)

copylibcmis ocaml stdlib

# Extras!

EXTRA="std_exit unix/unix unix/unixLabels compiler-libs/topdirs"

for i in $EXTRA; do
  cp $SRC_DIR/$i.cmi stdlib/
done
