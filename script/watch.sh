#!/usr/bin/env bash

source_dirs="bin lib asset tailwind.config.js"
args=${*:-"server"}
cmd="dune exec ${args}"

which fswatch || (echo "you need fswatch to run in watch mode"; exit 1)

function sigint_handler() {
  kill "$(jobs -pr)"
  exit 1
}

trap sigint_handler SIGINT

while true; do
  dune build
  $cmd &
  fswatch -r -1 $source_dirs
  printf "\nRestarting server.exe due to filesystem change\n"
  kill "$(jobs -pr)"
done
