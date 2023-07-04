#!/bin/bash

DIR="src/ocamlorg_frontend"

TMP_FILE="tmp.txt"

# Write all matches to temporary file
grep -r -o -h -E "text-\w+-[0-9]{2,3}|bg-\w+-[0-9]{2,3}" $DIR > $TMP_FILE

# Filter unique matches and print them
sort $TMP_FILE | uniq

# Remove temporary file
rm $TMP_FILE
