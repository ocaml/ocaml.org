#!/bin/sh


mkdir -p stdlib

copylibcmis()  (
  tmpfile=$(mktemp)
  srcdir=$(opam var $1:lib)
  jsoo_listunits -o $tmpfile $2
  for i in $(cat $tmpfile); do
    cp $srcdir/?${i:1}.cmi stdlib/ 
  done
  rm $tmpfile
)

copylibcmis ocaml stdlib
copylibcmis domainslib domainslib

# Extras!

cp $(opam var ocaml:lib)/compiler-libs/topdirs.cmi stdlib/

