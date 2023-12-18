---
title: Sorting a List of Lists According to Length of Sublists
slug: "28"
difficulty: intermediate
tags: [ "list" ]
description: "Sort a list of lists based on the frequency of sublist lengths in ascending order, with lists of less frequent lengths coming first."
---

# Solution

```ocaml
(* We might not be allowed to use built-in List.sort, so here's an
   eight-line implementation of insertion sort — O(n²) time
   complexity. *)
let rec insert cmp e = function
  | [] -> [e]
  | h :: t as l -> if cmp e h <= 0 then e :: l else h :: insert cmp e t

let rec sort cmp = function
  | [] -> []
  | h :: t -> insert cmp h (sort cmp t)

(* Sorting according to length : prepend length, sort, remove length *)
let length_sort lists =
  let lists = List.map (fun list -> List.length list, list) lists in
  let lists = sort (fun a b -> compare (fst a) (fst b)) lists in
  List.map snd lists
;;

(* Sorting according to length frequency : prepend frequency, sort,
   remove frequency. Frequencies are extracted by sorting lengths
   and applying RLE to count occurrences of each length (see problem
   "Run-length encoding of a list.") *)
let rle list =
  let rec aux count acc = function
    | [] -> [] (* Can only be reached if original list is empty *)
    | [x] -> (x, count + 1) :: acc
    | a :: (b :: _ as t) ->
       if a = b then aux (count + 1) acc t
       else aux 0 ((a, count + 1) :: acc) t in
  aux 0 [] list

let frequency_sort lists =
  let lengths = List.map List.length lists in
  let freq = rle (sort compare lengths) in
  let by_freq =
    List.map (fun list -> List.assoc (List.length list) freq , list) lists in
  let sorted = sort (fun a b -> compare (fst a) (fst b)) by_freq in
  List.map snd sorted
```

# Statement

Sorting a list of lists according to length of sublists.

1. We suppose that a list contains elements that are lists themselves.
The objective is to sort the elements of this list according to their
length. E.g. short lists first, longer lists later, or vice versa.

2. Again, we suppose that a list contains elements that are lists
themselves. But this time the objective is to sort the elements of this
list according to their **length frequency**; i.e., in the default,
where sorting is done ascendingly, lists with rare lengths are placed
first, others with a more frequent length come later.

```ocaml
# length_sort [["a"; "b"; "c"]; ["d"; "e"]; ["f"; "g"; "h"]; ["d"; "e"];
             ["i"; "j"; "k"; "l"]; ["m"; "n"]; ["o"]];;
- : string list list =
[["o"]; ["d"; "e"]; ["d"; "e"]; ["m"; "n"]; ["a"; "b"; "c"]; ["f"; "g"; "h"];
 ["i"; "j"; "k"; "l"]]
# frequency_sort [["a"; "b"; "c"]; ["d"; "e"]; ["f"; "g"; "h"]; ["d"; "e"];
                ["i"; "j"; "k"; "l"]; ["m"; "n"]; ["o"]];;
- : string list list =
[["i"; "j"; "k"; "l"]; ["o"]; ["a"; "b"; "c"]; ["f"; "g"; "h"]; ["d"; "e"];
 ["d"; "e"]; ["m"; "n"]]
```
