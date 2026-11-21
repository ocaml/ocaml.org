#!/bin/sh
# Tests of release-assets.sh against a fake gh (fake_gh.sh): no failure loses
# a release asset. Needs jq, like the fake.
#
#   tool/doc-modules/test/release_assets_test.sh
set -eu
HERE=$(cd "$(dirname "$0")" && pwd)
TOOL=$(dirname "$HERE")
T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
trap 'exit 1' INT TERM HUP

PASS=0
FAIL=0
check() { # check NAME COMMAND...
  name=$1
  shift
  if "$@" >/dev/null 2>&1; then
    PASS=$((PASS + 1))
  else
    FAIL=$((FAIL + 1))
    echo "FAIL: $name" >&2
  fi
}
eq() { [ "$1" = "$2" ] || { echo "  expected <$2>, got <$1>" >&2; return 1; }; }
fails() { ! "$@"; }

mkdir -p "$T/bin" "$T/gh"
ln -s "$HERE/fake_gh.sh" "$T/bin/gh"
ra() { PATH="$T/bin:$PATH" GH_FAKE="$T/gh" "$TOOL/release-assets.sh" "$@"; }
asset() { # asset NAME: its content, or nothing
  id=$(awk -v n="$1" '$2 == n { print $1 }' "$T/gh/names")
  if [ -n "$id" ]; then cat "$T/gh/assets/$id"; fi
}
names() { awk '{ print $2 }' "$T/gh/names" | sort | tr '\n' ' '; }
version() { echo "$1" >"$T/stats.jsonl"; }
check "assets: no release, first run" ra download TAG "$T/pub" stats.jsonl x.idx
check "assets: no release, empty stats" test -f "$T/pub/stats.jsonl" -a ! -s "$T/pub/stats.jsonl"
mkdir "$T/gh/release"
check "assets: release without stats, fails" \
  fails ra download TAG "$T/pub2" stats.jsonl x.idx
version s1
check "assets: first replace" ra replace TAG "$T/stats.jsonl"
check "assets: first replace, content" eq "$(asset stats.jsonl)" s1
version s2
check "assets: replace" ra replace TAG "$T/stats.jsonl"
check "assets: replace, content" eq "$(asset stats.jsonl)" s2
check "assets: replace, nothing left over" eq "$(names)" "stats.jsonl "
echo upload >"$T/gh/fail"
version s3
check "assets: failed upload, fails" fails ra replace TAG "$T/stats.jsonl"
check "assets: failed upload, old kept" eq "$(asset stats.jsonl)" s2
echo rename >"$T/gh/fail"
check "assets: failed rename, fails" fails ra replace TAG "$T/stats.jsonl"
check "assets: failed rename, only the new one" eq "$(names)" "stats.jsonl.new "
rm -rf "$T/pub"
check "assets: download after a failed rename" ra download TAG "$T/pub" stats.jsonl x.idx
check "assets: recovered" eq "$(cat "$T/pub/stats.jsonl")" s3
check "assets: recovered, unfinished" eq "$(cat "$T/pub/unfinished")" stats.jsonl
version s4
check "assets: replace after a failed rename" ra replace TAG "$T/stats.jsonl"
check "assets: finished" eq "$(names)" "stats.jsonl "
check "assets: finished, content" eq "$(asset stats.jsonl)" s4
echo delete >"$T/gh/fail"
version s5
check "assets: failed delete, fails" fails ra replace TAG "$T/stats.jsonl"
check "assets: failed delete, both" eq "$(names)" "stats.jsonl stats.jsonl.new "
rm -rf "$T/pub"
check "assets: download after a failed delete" ra download TAG "$T/pub" stats.jsonl x.idx
check "assets: the newer one" eq "$(cat "$T/pub/stats.jsonl")" s5
version s6
check "assets: replace after a failed delete" ra replace TAG "$T/stats.jsonl"
check "assets: finished again" eq "$(names)" "stats.jsonl "
echo gz >"$T/x.jsonl.gz"
echo rename >"$T/gh/fail"
check "assets: other asset, failed rename" fails ra replace TAG "$T/x.jsonl.gz"
rm -rf "$T/pub"
check "assets: download" ra download TAG "$T/pub" stats.jsonl x.idx
check "assets: an asset not downloaded is unfinished too" \
  eq "$(cat "$T/pub/unfinished")" x.jsonl.gz
echo list >"$T/gh/fail"
check "assets: other failures fail" fails ra download TAG "$T/pub" stats.jsonl

echo "$PASS passed, $FAIL failed"
[ "$FAIL" = 0 ]
