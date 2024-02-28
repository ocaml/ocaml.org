---
packages: []
libraries:
- str
code_blocks:
- explanation: |
    Compiling a regular expression. Nota, the `{regexp|...|regexp}` is a normal string. This syntax avoids the quoting of `\\`. Indicating `regexp` is optional, but indicates to the reader of the code that the string contains a regular expression.
  code: |
    let regexp = Str.regexp {regexp|\([0-9]+\)-\([0-9]+\)-\([0-9]+\)|regexp}
- explanation: |
    Testing if a string matches the regexp. The index (0) indicates the characters from which the matching is performed. `string_match` only match regular expression with the string at the given index, while `search_forward` will try to match it at the given index and at the following indexes:
  code: |
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
- explanation: |
    Getting group substring. Each `\\(` / `\\)` pairs permits you to get the substring corresponding to the enclosed regexp. By convention, the group 0 is the whole substring matching the regexp, and the first explicit group is 1:
  code: |
    let () =
      let str = "Date: 1971-01-23" in
      let _index = Str.search_forward regexp str 0 in
      let year = Str.matched_group 1 str
      and month = Str.matched_group 2 str
      and day = Str.matched_group 3 str in
      Printf.printf "year=%s, month=%s, day=%s\n" year month day
---

- **Understanding `Str`: `str` is a library which is brought with OCaml. It contains many functions which deal with regular expression. The documentation of the `Str` module is in the [API reference](https://v2.ocaml.org/api/Str.html).
- **Alternative Libraries:** The `re` packages provides regular expression functions and supports multiple regexp syntaxes (Perl, Posix, Emacs and Glob). Its functions are also purely functionnal (on the opposite, the `Str.matched_group` and `Str.matched_string` use a global state that prevents the concurrent use of two regexp matching sequences). Other packages provide regexp functions: `mikmatch`, `ocamlregexkit`, `ppx_regexp`, `pcre`/`pcre2` (which are compatible with Perl regexp), `re2`, `re_parser`. `tyre` (which comes with a PPX preprocessor `ppx_tyre`), `human-re`. The `tyre` combo defines a `function%tyre` keywork which works as a native OCaml pattern matching, but with on reggular expression. `ppx_regexp` works in the same way but completes `re`.
