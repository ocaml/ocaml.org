#!/bin/sh

# Copy the stdlib .cmi files into stdlib/. Merlin fetches them one by one,
# on demand. The toplevel worker uses stdlib.cmis.js instead.

mkdir -p stdlib

# $1: the compiler's standard library directory (%{ocaml_where} in dune).
srcdir=$1
tmpfile=$(mktemp)
jsoo_listunits -o "$tmpfile" stdlib
for i in $(cat "$tmpfile"); do
  # Unit names are capitalised, file names are not.
  cp "$srcdir"/?"${i#?}".cmi stdlib/
done
rm "$tmpfile"

cp "$srcdir"/std_exit.cmi stdlib/
