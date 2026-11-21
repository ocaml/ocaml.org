#!/bin/sh
# Download and replace the assets of the doc-modules release, for
# .github/workflows/scrape-doc-modules.yml, so that no failure loses one.
#
#   tool/doc-modules/release-assets.sh download TAG DIR REQUIRED [OPTIONAL...]
#   tool/doc-modules/release-assets.sh replace TAG FILE...
#
# `gh release upload --clobber` deletes the old asset, then uploads the new
# one: if the upload fails, the asset is gone (GitHub refuses two assets of the
# same name, so there is no plain upload-then-delete). `replace` uploads FILE
# as NAME.new, deletes NAME, then renames NAME.new to NAME. Whenever it stops,
# NAME, NAME.new or both exist, and NAME.new, if any, is the newer one; the
# window in which NAME answers 404 is one API call, the rename.
#
# `download` fetches the named assets of release TAG into DIR, preferring
# NAME.new to NAME (an interrupted `replace`). It lists in DIR/unfinished every
# asset of the release, downloaded or not, with a NAME.new left over, so that
# the caller replaces them even when its new file equals the published one. If the release does not exist (the very
# first run), it creates an empty DIR/REQUIRED. If the release exists without
# REQUIRED, it fails: that asset is history that must never be silently
# restarted (delete the release to start over). Any other failure fails too.
#
# Uses `gh` with the repository of the current directory, or $GH_REPO.
set -eu
cmd=$1
tag=$2
shift 2

W=$(mktemp -d)
trap 'rm -rf "$W"' EXIT
trap 'exit 1' INT TERM HUP

# "id name state" of every asset of the release, in $W/assets. An upload cut
# short can leave an asset in state "starter", not "uploaded": it must not be
# read, but it holds its name until deleted.
list_assets() {
  gh api "repos/{owner}/{repo}/releases/tags/$tag" \
    --jq '.assets[] | "\(.id) \(.name) \(.state)"' >"$W/assets" 2>"$W/error"
}
asset_id() { awk -v n="$1" '$2 == n { print $1 }' "$W/assets"; }
uploaded_id() { awk -v n="$1" '$2 == n && $3 == "uploaded" { print $1 }' "$W/assets"; }

case $cmd in
download)
  dir=$1
  shift
  required=$1 # the names to download are "$@", REQUIRED first
  mkdir -p "$dir"
  : >"$dir/unfinished"
  if list_assets; then
    for name; do
      if [ -n "$(uploaded_id "$name.new")" ]; then
        gh release download "$tag" -D "$W" -p "$name.new"
        mv "$W/$name.new" "$dir/$name"
        echo "$name: recovered from $name.new (an interrupted replacement)" >&2
      elif [ -n "$(uploaded_id "$name")" ]; then
        gh release download "$tag" -D "$dir" -p "$name" --clobber
      fi
    done
    awk '$2 ~ /\.new$/ { print substr($2, 1, length($2) - 4) }' "$W/assets" |
      sort -u >"$dir/unfinished"
    if [ ! -f "$dir/$required" ]; then
      echo "Release $tag exists but has no $required: refusing to start its" \
        "history over. Delete the release to do so." >&2
      exit 1
    fi
  elif grep -q 'HTTP 404' "$W/error"; then
    echo "No release $tag yet: first run." >&2
    : >"$dir/$required"
  else
    cat "$W/error" >&2
    exit 1
  fi
  ;;
replace)
  for file; do
    name=$(basename "$file")
    list_assets || { cat "$W/error" >&2; exit 1; }
    # A leftover of an interrupted replacement: superseded by $file, which
    # the caller built from what `download` recovered.
    leftover=$(asset_id "$name.new")
    if [ -n "$leftover" ]; then
      gh api -X DELETE "repos/{owner}/{repo}/releases/assets/$leftover"
    fi
    cp "$file" "$W/$name.new"
    gh release upload "$tag" "$W/$name.new"
    list_assets || { cat "$W/error" >&2; exit 1; }
    new=$(uploaded_id "$name.new")
    old=$(asset_id "$name")
    [ -n "$new" ] || { echo "$name.new: not found after its upload" >&2; exit 1; }
    if [ -n "$old" ]; then
      gh api -X DELETE "repos/{owner}/{repo}/releases/assets/$old"
    fi
    gh api -X PATCH "repos/{owner}/{repo}/releases/assets/$new" \
      -f name="$name" >/dev/null
  done
  ;;
*)
  echo "usage: $0 download TAG DIR REQUIRED [OPTIONAL...] | replace TAG FILE..." >&2
  exit 2
  ;;
esac
