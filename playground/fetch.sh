#!/bin/sh
# Download the prebuilt playground assets pinned in playground/release, and
# install them as playground/asset/, which the server build reads.
#
#   playground/fetch.sh [--force]
#
# Does nothing when playground/asset/ already holds that release, or holds a
# local build (`make playground`), unless --force is given.
# PLAYGROUND_URL overrides the download URL (e.g. file:///... for tests).

set -eu

here=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=release
. "$here/release"

asset=$here/asset
stamp=$here/.asset-release
url=${PLAYGROUND_URL:-https://github.com/ocaml/ocaml.org/releases/download/$PLAYGROUND_RELEASE/playground-asset.tar.gz}

if [ -d "$asset" ] && [ "${1:-}" != --force ]; then
  if [ ! -f "$stamp" ]; then
    echo "playground/asset: keeping a local build (playground/fetch.sh --force to replace it)"
    exit 0
  fi
  if [ "$(cat "$stamp")" = "$PLAYGROUND_RELEASE" ]; then
    exit 0
  fi
fi

# Work next to the target, so the final move is a rename.
tmp=$(mktemp -d "$here/.fetch.XXXXXX")
trap 'rm -rf "$tmp"' EXIT

curl -fsSL --retry 3 -o "$tmp/asset.tar.gz" "$url"

if command -v sha256sum >/dev/null; then
  sum=$(sha256sum "$tmp/asset.tar.gz")
else
  sum=$(shasum -a 256 "$tmp/asset.tar.gz")
fi
sum=${sum%% *}
if [ "$sum" != "$PLAYGROUND_SHA256" ]; then
  echo "playground/fetch.sh: checksum mismatch for $url" >&2
  echo "  expected $PLAYGROUND_SHA256" >&2
  echo "  got      $sum" >&2
  exit 1
fi

mkdir "$tmp/asset"
tar -xzf "$tmp/asset.tar.gz" -C "$tmp/asset"
rm -rf "$asset"
mv "$tmp/asset" "$asset"
echo "$PLAYGROUND_RELEASE" >"$stamp"
echo "playground/asset: $PLAYGROUND_RELEASE"
