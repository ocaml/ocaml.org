---
packages: []
---

(* Sorting a list of `int` values, returning a sorted copy, and using the `compare` function.

  **Note:** The `compare` function is polymorphic and works over all types. *)
let l = [ 1; 90; 42; 27 ]
let l' = List.sort compare a

(* Sorting an array while modifying it in place. *)
let a = [| 1; 90; 42; 27 |]
let () = Array.sort compare a

(* 
  Defining a custom `compare` function (here a case insensitive string comparison) and using it to sort an array.

  **Note:** The comparison function applied to `a` and `b` needs to return `1` if `a` is
  greater than `b`, `0` if they're equal, and `-1` if `a` is less than `b`.
*)
let compare_insensitive a b = 
    compare (String.lowercase_ascii a) (String.lowercase_ascii b)
let a = [| "ABC"; "BCD"; "abc"; "bcd" |]
let () = Array.sort compare_insensitive a
