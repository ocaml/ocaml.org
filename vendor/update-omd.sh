#!/bin/bash

version=89cf92b7ef06ae74bd4b19db5a275fa187e0ec0b

set -e -o pipefail

TMP="$(mktemp -d)"
trap "rm -rf $TMP" EXIT

rm -rf omd
mkdir -p omd/src

(
  cd "$TMP"
  git clone https://github.com/ocaml/omd.git
  cd omd
  git checkout $version
)

SRC=$TMP/omd

cp -v "$SRC"/LICENSE omd
cp -v "$SRC"/src/*.{ml,mli} omd/src
git checkout omd/src/dune omd/src/entities.ml
