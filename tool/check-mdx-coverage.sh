#!/bin/sh
# Tripwire for the mdx allow-lists.
#
# Usage: check-mdx-coverage.sh DUNE_FILE...
#
# For every file named in an (mdx (files ...)) field of the given dune files,
# check that it contains at least one code block that mdx actually runs: a
# column-0 ```ocaml, ```sh or ```bash fence that is not marked `skip`, either
# by a preceding `<!-- $MDX skip -->` comment or by an inline `skip` label.
# Without this, a file can sit in the allow-list, be reported green by
# `dune runtest`, and verify nothing.
#
# Also rejects fence labels that look like OCaml to a reader but that mdx
# silently ignores or refuses: `ocamltop`, and labels with a leading space
# such as "``` ocaml".
#
# Fence patterns are resolved relative to the dune file's directory, under
# the (subdir ...) they appear in if any. Shell globs such as *.md are
# expanded.
set -u

status=0

# Print "pattern" lines, relative to the dune file's directory, for every
# entry of an (mdx (files ...)) field, prefixed with its (subdir ...) if any.
list_patterns() {
  sed -e 's/;.*//' -e 's/(/ ( /g' -e 's/)/ ) /g' "$1" | awk '
    {
      for (i = 1; i <= NF; i++) {
        t = $i
        if (t == "(") { depth++; prev = t; continue }
        if (t == ")") {
          if (depth == files_depth) files_depth = 0
          if (depth == mdx_depth) mdx_depth = 0
          if (depth == subdir_depth) { subdir = ""; subdir_depth = 0 }
          depth--; prev = t; continue
        }
        if (prev == "(" && t == "subdir") { want_subdir = 1; subdir_depth = depth }
        else if (want_subdir) { subdir = t; want_subdir = 0 }
        else if (prev == "(" && t == "mdx") mdx_depth = depth
        else if (prev == "(" && t == "files" && mdx_depth) files_depth = depth
        else if (files_depth && depth == files_depth)
          print (subdir == "" ? t : subdir "/" t)
        prev = t
      }
    }'
}

# Check one markdown file. Prints "file:line: message" for each problem and
# returns non-zero if there is any.
check_file() {
  awk -v file="$1" '
    function err(msg) { printf "%s:%d: %s\n", file, NR, msg; errors++ }
    function has_skip(s,   n, i, toks) {
      n = split(s, toks, /[ ,]+/)
      for (i = 1; i <= n; i++) if (toks[i] == "skip") return 1
      return 0
    }
    BEGIN { live = 0; errors = 0; pending = ""; in_fence = 0 }
    in_fence {
      if ($0 ~ /^```[ \t]*$/) in_fence = 0
      next
    }
    /^<!--[ \t]*\$MDX/ {
      pending = $0
      sub(/^<!--[ \t]*\$MDX[ \t]*/, "", pending)
      sub(/[ \t]*-->.*$/, "", pending)
      next
    }
    /^```/ {
      info = substr($0, 4)
      label = info
      sub(/[ ,].*$/, "", label)
      rest = substr(info, length(label) + 1)
      if (info ~ /^[ \t]+(ocaml|sh|bash|shell)([ \t,]|$)/)
        err("fence label has a leading space; mdx does not accept it")
      else if (label == "ocaml" || label == "sh" || label == "bash") {
        if (!has_skip(pending) && !has_skip(rest)) live++
      }
      else if (label == "ocamltop")
        err("label `ocamltop` is unknown to mdx, which ignores the block; use `ocaml`")
      pending = ""
      in_fence = 1
      next
    }
    { pending = "" }
    END {
      if (live == 0) {
        printf "%s:1: no live mdx block (every ocaml/sh/bash fence is skipped or absent); unskip one or drop the file from the mdx stanza\n", file
        errors++
      }
      exit errors > 0
    }' "$1"
}

for dune_file in "$@"; do
  dir=$(dirname "$dune_file")
  problems=$(
    list_patterns "$dune_file" | while IFS= read -r pattern; do
      found=0
      for f in "$dir"/$pattern; do
        [ -e "$f" ] || continue
        found=1
        check_file "$f"
      done
      [ $found = 1 ] ||
        echo "$dune_file:1: mdx (files ...) entry matches no file: $pattern"
    done
  )
  if [ -n "$problems" ]; then
    printf '%s\n' "$problems" >&2
    status=1
  fi
done

exit $status
