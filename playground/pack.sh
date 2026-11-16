#!/bin/sh
# Pack playground/asset/ into a gzipped tarball, for a release (see
# .github/workflows/release-playground.yml). The tarball depends only on the
# files' contents, so identical assets give an identical checksum.
#
#   playground/pack.sh OUT.tar.gz      (needs GNU tar)

set -eu

here=$(cd "$(dirname "$0")" && pwd)
tar --sort=name --mtime=@0 --owner=0 --group=0 --numeric-owner \
  --mode=a+rX,u+w,go-w --format=gnu -C "$here/asset" -cf - . |
  gzip -9n >"$1"
