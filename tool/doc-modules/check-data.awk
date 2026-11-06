# Check that a data/doc_modules.txt file has the format the data packer
# decodes (tool/data-packer/lib/doc_modules_parser.ml; keep both in sync):
# comment and blank lines aside, "<name> <version> <path>..." with single
# spaces, opam characters in name and version, at least one path, every path
# made of OCaml module names (an uppercase letter, then letters, digits, '_'
# or a quote), lines sorted by name in C order, without duplicates.
#
#   LC_ALL=C awk -v q="'" -f check-data.awk FILE
#
# Exits 1 on the first bad line, which it reports on stderr. (The quote comes
# in through -v q, since it cannot appear in a shell-quoted program.)

BEGIN {
  opam = "^[a-zA-Z0-9_+.~-]+$"
  name = "[A-Z][A-Za-z0-9_" q "]*"
  path = "^" name "([.]" name ")*$"
}

/^#/ || $0 == "" { next }

{
  if ($0 ~ /  / || $0 ~ /^ / || $0 ~ / $/) bad("not single-spaced")
  if (NF < 3) bad("no module path")
  if ($1 !~ opam) bad("package name " $1)
  if ($2 !~ opam) bad("version " $2)
  for (i = 3; i <= NF; i++) if ($i !~ path) bad("module path " $i)
  if (prev != "" && $1 <= prev) bad("not sorted, or a duplicate, after " prev)
  prev = $1
}

function bad(why) {
  printf "line %d: %s\n", NR, why > "/dev/stderr"
  failed = 1
  exit 1
}

END { exit failed }
