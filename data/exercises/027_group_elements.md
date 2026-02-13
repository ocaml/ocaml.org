---
title: Group the Elements of a Set Into Disjoint Subsets
slug: "27"
difficulty: intermediate
tags: [ "list" ]
description: "Generate all possible ways to group elements into disjoint subsets."
---

## Solution

```ocaml
# (* This implementation is less streamlined than the one-extraction
  version, because more work is done on the lists after each
  transform to prepend the actual items. The end result is cleaner
  in terms of code, though. *)

  let group list sizes =
    let initial = List.map (fun size -> size, []) sizes in
    (* The core of the function. Prepend accepts a list of groups,
        each with the number of items that should be added, and
        prepends the item to every group that can support it, thus
        turning [1,a ; 2,b ; 0,c] into [ [0,x::a ; 2,b ; 0,c ];
        [1,a ; 1,x::b ; 0,c]; [ 1,a ; 2,b ; 0,c ]]

        Again, in the prolog language (for which these questions are
        originally intended), this function is a whole lot simpler.  *)
  let prepend p list =
    let emit l acc = l :: acc in
    let rec aux emit acc = function
      | [] -> emit [] acc
      | (n, l) as h :: t ->
         let acc = if n > 0 then emit ((n - 1, p :: l) :: t) acc
                   else acc in
         aux (fun l acc -> emit (h :: l) acc) acc t
    in
    aux emit [] list
  in
  let rec aux = function
    | [] -> [initial]
    | h :: t -> List.concat_map (prepend h) (aux t)
  in
  let all = aux list in
  (* Don't forget to eliminate all group sets that have non-full
     groups *)
  let complete = List.filter (List.for_all (fun (x, _) -> x = 0)) all in
    List.map (List.map snd) complete;;
val group : 'a list -> int list -> 'a list list list = <fun>
```

## Statement

Group the elements of a set into disjoint subsets

1. In how many ways can a group of 9 people work in 3 disjoint subgroups
of 2, 3 and 4 persons? Write a function that generates all the
possibilities and returns them in a list.
2. Generalize the above function in a way that we can specify a list of
group sizes and the function will return a list of groups.

```ocaml
# group ["a"; "b"; "c"; "d"] [2; 1];;
- : string list list list =
[[["a"; "b"]; ["c"]]; [["a"; "c"]; ["b"]]; [["b"; "c"]; ["a"]];
 [["a"; "b"]; ["d"]]; [["a"; "c"]; ["d"]]; [["b"; "c"]; ["d"]];
 [["a"; "d"]; ["b"]]; [["b"; "d"]; ["a"]]; [["a"; "d"]; ["c"]];
 [["b"; "d"]; ["c"]]; [["c"; "d"]; ["a"]]; [["c"; "d"]; ["b"]]]
```
