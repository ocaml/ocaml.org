---
packages:
- name: "ppx_regexp"
  tested_version: "0.5.1"
  used_libraries:
  - ppx_regexp
- name: "re"
  tested_version: "1.12.0"
  used_libraries:
  - re
discussion: |
  The `re` library supports multiple syntaxes, and
    provides concurrent pattern matching.

  The `ppx_regexp` package provides a preprocessor extension
  (PPX) that introduces syntactic sugar (e.g. `match%pcre`)
  for the PCRE syntax.

  To work with this package, we recommend referencing the
   [PCRE syntax](https://www.pcre.org/original/doc/html/pcresyntax.html)
  or any [PCRE cheat sheet](https://www.debuggex.com/cheatsheet/regex/pcre).
---

(*
Extracting components from a date string
- We use `match%pcre` to pattern match against a string using regex
- The regex pattern is enclosed in `{re|...|re}` string delimiters
(it does not matter whether you use named delimiters or not,
i.e. `re` has no special meaning here)
- Named capture groups are created using `?<name>...` syntax
- `\d` means "match a digit", `{4}` means "exactly 4 times"
*)
let () =
  match%pcre "Date: 1972-01-23  " with
  | {|?<date>(?<year>\d{4})-(?<month>\d\d)-(?<day>\d\d)|} ->
      Printf.printf "Date found: (%s)\n" date;
      Printf.printf "Year: (%s)\n" year;
      Printf.printf "Month: (%s)\n" month;
      Printf.printf "Day: (%s)\n" day;
  | _ -> print_string "Date not found\n"
