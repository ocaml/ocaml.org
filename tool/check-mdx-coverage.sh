#!/bin/sh
# Coverage tripwire and report for the mdx-tested markdown under data/.
#
# Usage: check-mdx-coverage.sh DUNE_FILE...            check (exit 1 on problems)
#        check-mdx-coverage.sh --report DUNE_FILE...   print a Markdown report
#
# Check mode. For every file named in an (mdx (files ...)) field of the given
# dune files, require at least one code block that mdx actually runs: a
# column-0 ```ocaml, ```sh or ```bash fence that is not marked `skip`, either
# by a preceding `<!-- $MDX skip -->` comment or by an inline `skip` label.
# Without this, a file can sit in the allow-list, be reported green by
# `dune runtest`, and verify nothing. Also rejects fence labels that look like
# OCaml to a reader but that mdx silently ignores or refuses: `ocamltop`, and
# labels with a leading space such as "``` ocaml"; and `bash`, which mdx
# accepts but runs with sh, so `sh` is the honest label.
#
# Report mode. For every markdown file under each dune file's directory, show
# whether it is in the allow-list and how many blocks are live and skipped,
# with the reason given in the HTML comment above each `$MDX skip`. Nothing is
# committed: run `make mdx-coverage` locally, and CI writes it to the job
# summary.
#
# Only column-0 triple-backtick fences count, which is what mdx itself
# recognises. Patterns are resolved relative to the dune file's directory,
# under the (subdir ...) they appear in if any; shell globs are expanded.
set -u

mode=check
if [ "${1:-}" = "--report" ]; then
  mode=report
  shift
fi
if [ $# -eq 0 ]; then
  echo "usage: $0 [--report] DUNE_FILE..." >&2
  exit 2
fi

# Print one pattern per line, relative to the dune file's directory, for every
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

# Expand the patterns of a dune file into existing paths, one per line.
# Patterns that match nothing are reported on stderr.
listed_files() {
  dune_file=$1
  dir=$(dirname "$dune_file")
  rc=0
  # Patterns are globbed under $dir below, not here.
  set -f
  # shellcheck disable=SC2046
  set -- $(list_patterns "$dune_file")
  set +f
  for pattern do
    found=0
    for f in "$dir"/$pattern; do
      [ -e "$f" ] || continue
      found=1
      printf '%s\n' "$f"
    done
    if [ $found = 0 ]; then
      echo "$dune_file:1: mdx (files ...) entry matches no file: $pattern" >&2
      rc=1
    fi
  done
  return $rc
}

# The scanner, shared by both modes. It walks several files at once (POSIX
# awk, so a file change is detected with FNR == 1), keeps per-file counts of
# live and skipped mdx blocks, and remembers the HTML comment written just
# above a `$MDX skip` directive as the reason for the skip.
#
#   mode=check   prints "file:line: problem" lines; exits 1 if any
#   mode=report  prints a Markdown section; `listed` holds the allow-listed
#                paths, space-separated and space-padded; `title` names it
scan='
  function err(msg) { printf "%s:%d: %s\n", FILENAME, FNR, msg; problems++ }
  function has_skip(s,   n, i, toks) {
    n = split(s, toks, /[ ,]+/)
    for (i = 1; i <= n; i++) if (toks[i] == "skip") return 1
    return 0
  }
  function md(s) { gsub(/\|/, "\\|", s); return s }
  function flush_file(   r, line, first) {
    if (file == "") return
    if (mode == "check" && live == 0)
      printf "%s:1: no live mdx block (every ocaml/sh/bash fence is skipped or absent); unskip one or drop the file from the mdx stanza\n", file
    if (mode == "check") { if (live == 0) problems++; return }
    if (total == 0) return
    name = file; sub(/^(\.\/)?data\//, "", name)
    if (index(listed, " " file " ") > 0) {
      n_listed++; t_total += total; t_live += live; t_skip += skipped; t_shell += shells
      rows = rows sprintf("| `%s` | %d | %d | %d | %d |\n", name, total, live, skipped, shells)
      if (skipped > 0) {
        line = ""; first = 1
        for (r in reasons) {
          line = line (first ? "" : "; ") md(r) (reasons[r] > 1 ? " (x" reasons[r] ")" : "")
          first = 0
        }
        skips = skips sprintf("- `%s`: %s\n", name, line)
      }
    } else {
      n_unlisted++; u_total += total
      untested = untested sprintf("- `%s` (%d)\n", name, total)
    }
  }
  function reset_file() {
    file = FILENAME; total = 0; live = 0; skipped = 0; shells = 0
    pending = ""; reason = ""; in_fence = 0; comment = ""; comment_open = 0; last_comment = ""
    delete reasons
  }
  FNR == 1 { flush_file(); reset_file() }
  in_fence {
    if ($0 ~ /^```[ \t]*$/) in_fence = 0
    next
  }
  /^<!--[ \t]*\$MDX/ {
    pending = $0
    sub(/^<!--[ \t]*\$MDX[ \t]*/, "", pending)
    sub(/[ \t]*-->.*$/, "", pending)
    reason = last_comment
    next
  }
  /^<!--/ {
    c = $0; sub(/^<!--[ \t]*/, "", c)
    if ($0 ~ /-->/) { sub(/[ \t]*-->.*$/, "", c); last_comment = c; comment_open = 0 }
    else { comment = c; comment_open = 1 }
    next
  }
  comment_open {
    c = $0; sub(/^[ \t]+/, "", c)
    if ($0 ~ /-->/) { sub(/[ \t]*-->.*$/, "", c); last_comment = comment " " c; comment_open = 0 }
    else comment = comment " " c
    next
  }
  /^```/ {
    info = substr($0, 4)
    label = info
    sub(/[ ,].*$/, "", label)
    rest = substr(info, length(label) + 1)
    if (info ~ /^[ \t]+(ocaml|sh|bash|shell)([ \t,]|$)/) {
      if (mode == "check") err("fence label has a leading space; mdx does not accept it")
    }
    else if (label == "ocaml" || label == "sh" || label == "bash") {
      if (label == "bash" && mode == "check")
        err("mdx runs `bash` blocks with sh; label it `sh`, or `shell` if it is not meant to run")
      total++
      if (has_skip(pending) || has_skip(rest)) {
        skipped++
        r = reason; sub(/[ \t]+$/, "", r)
        if (r == "") r = "(no reason given)"
        reasons[r]++
      } else live++
    }
    else if (label == "ocamltop") {
      if (mode == "check") err("label `ocamltop` is unknown to mdx, which ignores the block; use `ocaml`")
    }
    else if (label == "shell") shells++
    pending = ""; reason = ""; last_comment = ""
    in_fence = 1
    next
  }
  { pending = ""; last_comment = "" }
  END {
    flush_file()
    if (mode == "check") exit problems > 0
    printf "### %s\n\n", title
    printf "%d of %d files with mdx-runnable blocks are in the allow-list: %d blocks, %d live, %d skipped, plus %d `shell` blocks that are commands for the reader and are not run.", n_listed, n_listed + n_unlisted, t_total, t_live, t_skip, t_shell
    if (n_unlisted > 0) printf " The %d files outside it hold %d more blocks.", n_unlisted, u_total
    printf "\n\n| File | Blocks | Live | Skipped | Shell (not run) |\n| --- | ---: | ---: | ---: | ---: |\n%s", rows
    if (skips != "") printf "\n**Skipped blocks and the reason given above each `$MDX skip`:**\n\n%s", skips
    if (untested != "") printf "\n**Not in the allow-list:**\n\n%s", untested
  }'

status=0
for dune_file in "$@"; do
  dir=$(dirname "$dune_file")
  case $mode in
    check)
      files=$(listed_files "$dune_file") || status=1
      [ -n "$files" ] || continue
      # shellcheck disable=SC2086
      awk -v mode=check "$scan" $files || status=1
      ;;
    report)
      listed=" $(listed_files "$dune_file" 2>/dev/null | tr '\n' ' ')"
      all=$(find "$dir" -name '*.md' | sort)
      [ -n "$all" ] || continue
      # shellcheck disable=SC2086
      awk -v mode=report -v listed="$listed" -v title="$dir" "$scan" $all
      echo
      ;;
  esac
done

exit $status
