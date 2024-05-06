---
packages:
- name: "re"
  tested_version: "1.10.4"
  used_libraries:
  - re
- name: "ppx_regexp"
  tested_version: "0.5.1"
  used_libraries:
  - ppx_regexp
discussion: |
  - **Understanding `re`:** The `re` library proposes multiple advantages over the `Str` library, which is shipped with OCaml. It supports multiple syntaxes, and its absence of global states permits concurrent pattern matching. It is completed by the `ppx_regexp`, which makes using this library easier. However, only the PCRE syntax is supported.
  - **Reference:** `ppx_regexp` is described on [its page](https://github.com/paurkedal/ppx_regexp). It can be completed by the [PCRE syntax](https://www.pcre.org/original/doc/html/pcresyntax.html) or any [PCRE cheat sheet](https://www.debuggex.com/cheatsheet/regex/pcre).
---

(* In order to match a string with a regular expression, we use the `match%pcre` keyword in a way similar to the OCaml `match`: *)

let () =
  match%pcre "Date: 1972-01-23  " with
  | {re|?<date>(?<year>\d{4})-(?<month>\d\d)-(?<day>\d\d)|re} ->
      Printf.printf "Date found: (%s)\n" date;
      Printf.printf "Year: (%s)\n" year;
      Printf.printf "Month: (%s)\n" month;
      Printf.printf "Day: (%s)\n" day;
  | _ -> print_string "Date not found\n"

(* In a similar way, we have a `function%pcre` with perform similar tasks *)

let all_digits =
  function%pcre
  | {re|^\d*$|re} -> true
  | _ -> false

let () =
  assert (all_digits "1234")
let () =
  assert (not @@ all_digits "12x34")
