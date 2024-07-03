---
packages: []
discussion: |
  - **Understanding `Str`: `str` is a library that comes with OCaml. It contains many functions that deal with regular expression. The documentation of the `Str` module is in the [API reference](https://v2.ocaml.org/api/Str.html).
  - **Alternative Libraries:** The `re` packages provide regular expression functions and supports multiple `regexp` syntaxes (Perl, Posix, Emacs, and Glob). Its functions are also purely functionnal (on the opposite, the `Str.matched_group` and `Str.matched_string` use a global state that prevents the concurrent use of two `regexp` matching sequences). Other packages provide `regexp` functions: `mikmatch`, `ocamlregexkit`, `ppx_regexp`, `pcre`/`pcre2` (compatible with Perl `regexp`), `re2`, `re_parser`, `tyre` (which comes with a PPX preprocessor `ppx_tyre`), and `human-re`. The `ppx-tyre` package defines a `function%tyre` keywork. It works as a native OCaml pattern matching, but on regular expressions. `ppx_regexp` works in the same way with package `re`.
---

(* Compiling a regular expression: Note, the `{regexp|...|regexp}` is a normal string. This syntax avoids the quoting of `\\`. Indicating `regexp` is optional, but it indicates to the code reader that the string contains a regular expression. *)
    let regexp = Str.regexp {regexp|\([0-9]+\)-\([0-9]+\)-\([0-9]+\)|regexp}

(* Testing if a string matches the `regexp`: The index (0) indicates the characters from which the matching is performed. `string_match` only matches regular expressions with the string at the given index, while `search_forward` will try to match it at the given index and at the following indexes: *)
    let () =
      if Str.string_match regexp "1971-01-23" 0 then
          print_string "The string match\n"
      else
          print_string "The string doesn't match\n"
    let () =
      let str = "Date: 1971-01-23" in
      let index = Str.search_forward regexp str 0 in
      Printf.printf "Date found at index %d (%s)\n" index
        (Str.matched_string str)

(* Getting group substring: Each `\\(` / `\\)` pair permits you to get the substring corresponding to the enclosed `regexp`. By convention, the group 0 is the whole substring matching the `regexp`, and the first explicit group is 1: *)
    let () =
      let str = "Date: 1971-01-23" in
      let _index = Str.search_forward regexp str 0 in
      let year = Str.matched_group 1 str
      and month = Str.matched_group 2 str
      and day = Str.matched_group 3 str in
      Printf.printf "year=%s, month=%s, day=%s\n" year month day

