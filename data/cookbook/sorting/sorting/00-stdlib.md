---
packages: []
code_blocks:
- explanation: |
    Sorting a list of item, returning a sorted copy.
  code: |
    let l = [ 1; 90; 42; 27 ];;
      let l' = List.sort compare a
- explanation: |
    Sorting an array while modifying it.
  code: |
    let a = [| 1; 90; 42; 27 |];;
    let () = Array.sort compare a;;
- explanation: |
    Defining a custom `compare` function (here a case insensitive string comparison) an using it to compare.
    Note: the comparison function applied to `a` and `b` should return 1 if `a` is greater, 0, if equal, -1 if lower than `b`.
  code: |
    let compare_insensitive a b = 
          compare (String.lowercase_ascii a) (String.lowercase_ascii b)
    let a = [| "ABC"; "BCD"; "abc"; "bcd" |]
    let () = Array.compare_insensitive a
---

