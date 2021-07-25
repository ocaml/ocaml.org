#!/bin/bash

version=main

set -e -o pipefail

TMP="$(mktemp -d)"
trap "rm -rf $TMP" EXIT

(
    cd $TMP
    git clone https://github.com/ocaml/ood.git
    cd ood
    git checkout $version
)

SRC=$TMP/ood

rm -rf data/
cp -vr $SRC/data/ data/

rm -rf lib/ood/
cp -vr $SRC/src/ood lib/ood/

rm -rf tool/ood-gen/
cp -vr $SRC/src/ood-gen tool/ood-gen/
