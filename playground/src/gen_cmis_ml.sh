#!/bin/sh


echo "let cmis = ["

for i in $(ls ../asset/stdlib/); do
  echo "\"$i\";"
done

echo "]"
