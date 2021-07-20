#!/bin/bash

# List the files in `public/static` that can't be found in any of the files in `src/` and `pages/`
for i in $(find public/static -maxdepth 1 -type f -exec basename {} \;); do
  grep -Ri $i {src,pages}/* > /dev/null
  if [ $? = 1 ] ; then
   echo $i
  fi
done
