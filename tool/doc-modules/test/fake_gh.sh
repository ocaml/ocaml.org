#!/bin/sh
# A fake of the few `gh` commands release-assets.sh uses, for scrape_test.sh.
# One release, kept in $GH_FAKE: it exists if $GH_FAKE/release does; its
# assets are $GH_FAKE/assets/ID, named by the lines "ID NAME" of
# $GH_FAKE/names. If $GH_FAKE/fail names an operation (list, upload, delete,
# rename), that operation fails once. Like GitHub, an upload under the name of
# an existing asset fails.
set -eu
F=$GH_FAKE
mkdir -p "$F/assets"
touch "$F/names"

fail_once() {
  if [ "$(cat "$F/fail" 2>/dev/null)" = "$1" ]; then
    rm -f "$F/fail"
    echo "gh: injected $1 failure" >&2
    exit 1
  fi
}
id_of() { awk -v n="$1" '$2 == n { print $1 }' "$F/names"; }

case "$1 $2" in
"api repos/{owner}/{repo}/releases/tags/"*)
  fail_once list
  [ -d "$F/release" ] || { echo "gh: Not Found (HTTP 404)" >&2; exit 1; }
  [ "$3" = --jq ] || exit 2
  awk '{ printf "%s{\"id\":%s,\"name\":\"%s\",\"state\":\"uploaded\"}",
                 (NR > 1 ? "," : ""), $1, $2 }
    BEGIN { printf "{\"assets\":[" } END { print "]}" }' "$F/names" |
    jq -r "$4"
  ;;
"api -X")
  method=$3
  id=${4##*/}
  grep -q "^$id " "$F/names" || { echo "gh: Not Found (HTTP 404)" >&2; exit 1; }
  case $method in
  DELETE)
    fail_once delete
    rm "$F/assets/$id"
    awk -v id="$id" '$1 != id' "$F/names" >"$F/names.tmp"
    ;;
  PATCH)
    fail_once rename
    [ "$5" = -f ] || exit 2
    awk -v id="$id" -v n="${6#name=}" '$1 == id { $2 = n } { print }' \
      "$F/names" >"$F/names.tmp"
    ;;
  *) exit 2 ;;
  esac
  mv "$F/names.tmp" "$F/names"
  ;;
"release upload")
  shift 3
  for file; do
    fail_once upload
    name=$(basename "$file")
    if [ -n "$(id_of "$name")" ]; then
      echo "gh: asset $name already exists" >&2
      exit 1
    fi
    id=$(($(awk '$1 > m { m = $1 } END { print m + 0 }' "$F/names") + 1))
    cp "$file" "$F/assets/$id"
    echo "$id $name" >>"$F/names"
  done
  ;;
"release download")
  # release download TAG -D DIR -p NAME [--clobber]
  [ "$4" = -D ] && [ "$6" = -p ] || exit 2
  id=$(id_of "$7")
  [ -n "$id" ] || { echo "gh: no asset matches $7" >&2; exit 1; }
  cp "$F/assets/$id" "$5/$7"
  ;;
*)
  echo "fake gh: unsupported: $*" >&2
  exit 2
  ;;
esac
