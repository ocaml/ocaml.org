#!/bin/sh


echo "let cmis = ["

for d in "$@"; do
  for i in $(ls ../asset/$d/); do
    echo "(\"$d\", \"$i\");"
  done
done

echo "]"
