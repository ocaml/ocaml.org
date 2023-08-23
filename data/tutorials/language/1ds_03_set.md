---
id: sets
title: Sets
description: >
  The standard library's Set module
category: "Data Structures"
---

# Sets

## Module Set
To make a set of strings:

```ocaml
# module SS = Set.Make(String);;
module SS :
  sig
    type elt = string
    type t = Set.Make(String).t
    val empty : t
    val is_empty : t -> bool
    val mem : elt -> t -> bool
    val add : elt -> t -> t
    val singleton : elt -> t
    val remove : elt -> t -> t
    val union : t -> t -> t
    val inter : t -> t -> t
    val disjoint : t -> t -> bool
    val diff : t -> t -> t
    val compare : t -> t -> int
    val equal : t -> t -> bool
    val subset : t -> t -> bool
    val iter : (elt -> unit) -> t -> unit
    val map : (elt -> elt) -> t -> t
    val fold : (elt -> 'a -> 'a) -> t -> 'a -> 'a
    val for_all : (elt -> bool) -> t -> bool
    val exists : (elt -> bool) -> t -> bool
    val filter : (elt -> bool) -> t -> t
    val filter_map : (elt -> elt option) -> t -> t
    val partition : (elt -> bool) -> t -> t * t
    val cardinal : t -> int
    val elements : t -> elt list
    val min_elt : t -> elt
    val min_elt_opt : t -> elt option
    val max_elt : t -> elt
    val max_elt_opt : t -> elt option
    val choose : t -> elt
    val choose_opt : t -> elt option
    val split : elt -> t -> t * bool * t
    val find : elt -> t -> elt
    val find_opt : elt -> t -> elt option
    val find_first : (elt -> bool) -> t -> elt
    val find_first_opt : (elt -> bool) -> t -> elt option
    val find_last : (elt -> bool) -> t -> elt
    val find_last_opt : (elt -> bool) -> t -> elt option
    val of_list : elt list -> t
    val to_seq_from : elt -> t -> elt Seq.t
    val to_seq : t -> elt Seq.t
    val to_rev_seq : t -> elt Seq.t
    val add_seq : elt Seq.t -> t -> t
    val of_seq : elt Seq.t -> t
  end
```

To create a set you need to start somewhere so here is the empty set:

```ocaml
# let s = SS.empty;;
val s : SS.t = <abstr>
```

Alternatively if we know an element to start with we can create a set
like

```ocaml
# let s = SS.singleton "hello";;
val s : SS.t = <abstr>
```

To add some elements to the set we can do.

```ocaml
# let s =
  List.fold_right SS.add ["hello"; "world"; "community"; "manager";
                          "stuff"; "blue"; "green"] s;;
val s : SS.t = <abstr>
```

Now if we are playing around with sets we will probably want to see what
is in the set that we have created. To do this we can write a function
that will print the set out.

```ocaml
# let print_set s =
   SS.iter print_endline s;;
val print_set : SS.t -> unit = <fun>
```

If we want to remove a specific element of a set there is a remove
function. However if we want to remove several elements at once we could
think of it as doing a 'filter'. Let's filter out all words that are
longer than 5 characters.

This can be written as:

```ocaml
# let my_filter str =
  String.length str <= 5;;
val my_filter : string -> bool = <fun>
# let s2 = SS.filter my_filter s;;
val s2 : SS.t = <abstr>
```

or using an anonymous function:

```ocaml
# let s2 = SS.filter (fun str -> String.length str <= 5) s;;
val s2 : SS.t = <abstr>
```

If we want to check and see if an element is in the set it might look
like this.

```ocaml
# SS.mem "hello" s2;;
- : bool = true
```

The Set module also provides the set theoretic operations union,
intersection and difference. For example, the difference of the original
set and the set with short strings (≤ 5 characters) is the set of long
strings:

```ocaml
# print_set (SS.diff s s2);;
community
manager
- : unit = ()
```

Note that the Set module provides a purely functional data structure:
removing an element from a set does not alter that set but, rather,
returns a new set that is very similar to (and shares much of its
internals with) the original set.

