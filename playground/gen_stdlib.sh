#!/bin/sh


mkdir -p stdlib

copylibcmis()  (
  tmpfile=$(mktemp)
  srcdir=$(opam var $1:lib)
  jsoo_listunits -o $tmpfile $2
  for i in $(cat $tmpfile); do
    cp $srcdir/?${i#?}.cmi stdlib/ 
  done
  rm $tmpfile
)

copylibcmis ocaml stdlib

# Extras!

EXTRA="std_exit unix/unix unix/unixLabels compiler-libs/topdirs"

for i in $EXTRA; do
  cp $(opam var ocaml:lib)/$i.cmi stdlib/
done

