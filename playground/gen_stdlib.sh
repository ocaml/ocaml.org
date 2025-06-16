#!/bin/sh

mkdir -p stdlib

tmpfile=$(mktemp)
srcdir=$1
jsoo_listunits -o $tmpfile stdlib
for i in $(cat $tmpfile); do
  cp $srcdir/?${i#?}.cmi stdlib/ 
done
rm $tmpfile

# Extras!

EXTRA="std_exit unix/unix unix/unixLabels compiler-libs/topdirs"

for i in $EXTRA; do
  cp $srcdir/$i.cmi stdlib/
done

