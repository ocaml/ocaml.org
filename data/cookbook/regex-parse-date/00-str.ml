---
packages: []
discussion: |
  If you want to run this example in UTop, you need to run `#require "str";;`
    in order to load the `Str` module into UTop.
---

(*
Define a regular expression pattern to match dates in YYYY-MM-DD format
   The `{re|...|re}` syntax lets us write the pattern without escaping slashes
   The `\(...\)` groups capture parts of the match we want to extract later:
   - First group: year (digits)
   - Second group: month (digits)
   - Third group: day (digits)
*)
let regexp =
  Str.regexp {re|\([0-9]+\)-\([0-9]+\)-\([0-9]+\)|re}

(*
Extract the matched groups (year, month, day) from the string
After a successful `Str.search_forward`, we use
`Str.matched_group ` to get the individual values for the matching groups.

Note: `matched_group 0` would return the entire matched string
*)
let () =
  let str = "Date: 1971-01-23" in
  let _index = Str.search_forward regexp str 0 in
  let year = Str.matched_group 1 str
  and month = Str.matched_group 2 str
  and day = Str.matched_group 3 str in
  Printf.printf "year=%s, month=%s, day=%s\n" year month day
