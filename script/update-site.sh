#!/usr/bin/env bash

docker pull patricoferris/ocamlorg:latest
docker cp $(docker create --rm patricoferris/ocamlorg:latest):/data asset/site
