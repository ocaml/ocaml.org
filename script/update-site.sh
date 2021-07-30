#!/usr/bin/env bash

docker pull ocurrent/v3.ocaml.org:live
docker cp $(docker create --rm ocurrent/v3.ocaml.org:live):/data asset_site/
