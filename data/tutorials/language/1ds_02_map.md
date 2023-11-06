---
id: map
title: Map
description: >
  Create a mapping using the standard library's Map module
category: "Data Structures"
---

# Map

## Module Map

Map creates a "mapping". For instance, let's say I have some data that is
fruits and their associated quantities. I could with the Map module create
a mapping from inventory fruit items to their quantity. The mapping module not
only does this, but it does it fairly efficiently. It also does this in a
functional way. In the example below I am going to do a mapping from
fruits to ints. However, it is possible to do mappings with all
different types of data.

Let's first create a `fruit` type and a minimal functor:

```ocaml
# type fruit = Apple | Orange | Banana;;
type fruit = Apple | Orange | Banana

# module Fruit = struct
    type t = fruit

    let compare = compare
  end;;
module Fruit : sig type t = fruit val compare : 'a -> 'a -> int end
```

To create a Map I can do:

```ocaml
# module Stock = Map.Make (Fruit);;
module Stock :
  sig
    type key = fruit
    type 'a t = 'a Map.Make(Fruit).t
    val empty : 'a t
    val add : key -> 'a -> 'a t -> 'a t
    val add_to_list : key -> 'a -> 'a list t -> 'a list t
    val update : key -> ('a option -> 'a option) -> 'a t -> 'a t
    val singleton : key -> 'a -> 'a t
    val remove : key -> 'a t -> 'a t
    val merge :
      (key -> 'a option -> 'b option -> 'c option) -> 'a t -> 'b t -> 'c t
    val union : (key -> 'a -> 'a -> 'a option) -> 'a t -> 'a t -> 'a t
    val cardinal : 'a t -> int
    val bindings : 'a t -> (key * 'a) list
    val min_binding : 'a t -> key * 'a
    val min_binding_opt : 'a t -> (key * 'a) option
    val max_binding : 'a t -> key * 'a
    val max_binding_opt : 'a t -> (key * 'a) option
    val choose : 'a t -> key * 'a
    val choose_opt : 'a t -> (key * 'a) option
    val find : key -> 'a t -> 'a
    val find_opt : key -> 'a t -> 'a option
    val find_first : (key -> bool) -> 'a t -> key * 'a
    val find_first_opt : (key -> bool) -> 'a t -> (key * 'a) option
    val find_last : (key -> bool) -> 'a t -> key * 'a
    val find_last_opt : (key -> bool) -> 'a t -> (key * 'a) option
    val iter : (key -> 'a -> unit) -> 'a t -> unit
    val fold : (key -> 'a -> 'acc -> 'acc) -> 'a t -> 'acc -> 'acc
    val map : ('a -> 'b) -> 'a t -> 'b t
    val mapi : (key -> 'a -> 'b) -> 'a t -> 'b t
    val filter : (key -> 'a -> bool) -> 'a t -> 'a t
    val filter_map : (key -> 'a -> 'b option) -> 'a t -> 'b t
    val partition : (key -> 'a -> bool) -> 'a t -> 'a t * 'a t
    val split : key -> 'a t -> 'a t * 'a option * 'a t
    val is_empty : 'a t -> bool
    val mem : key -> 'a t -> bool
    val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
    val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
    val for_all : (key -> 'a -> bool) -> 'a t -> bool
    val exists : (key -> 'a -> bool) -> 'a t -> bool
    val to_list : 'a t -> (key * 'a) list
    val of_list : (key * 'a) list -> 'a t
    val to_seq : 'a t -> (key * 'a) Seq.t
    val to_rev_seq : 'a t -> (key * 'a) Seq.t
    val to_seq_from : key -> 'a t -> (key * 'a) Seq.t
    val add_seq : (key * 'a) Seq.t -> 'a t -> 'a t
    val of_seq : (key * 'a) Seq.t -> 'a t
  end

```

OK, we have created the module `Stock`.  Now, let's start putting
something into it.  Where do we start?  Well, let's create an empty
map to begin with:

```ocaml
# let data = Stock.empty;;
val data : 'a Stock.t = <abstr>
```

Hummm. An empty map is kind of boring, so let's add some data.

```ocaml
# let data = Stock.add Apple 10 data;;
val data : int Stock.t = <abstr>
```

We have now created a new map—again called `data`, thus masking the previous
one—by adding `Apple` and its quantity `10` to our previous empty map.
There is a fairly important point to make here. Once we have added the
value `10` we have fixed the types of mappings that we can do.
This means our mapping in our module `Stock` is from fruit _to int_.
If we want a mapping from fruits to strings, we will have to create a different mapping.

Let's add in some additional data just for kicks.

```ocaml
# let data = data |> Stock.add Orange 30 |> Stock.add Banana 42;;
val data : int Stock.t = <abstr>
```

Now that we have some data inside our map, wouldn't it be nice
to be able to view that data at some point? Let's begin by creating a
simple print function.

```ocaml
# let string_of_fruit = function
    | Apple -> "apple"
    | Orange -> "orange"
    | Banana -> "banana"
;;
val string_of_fruit : fruit -> string = <fun>

# let print_fruit key value =
    print_string (string_of_fruit key ^ " " ^ string_of_int value ^ "\n")
;;
val print_fruit : fruit -> int -> unit = <fun>
```

We have here a function that will take a `fruit` key, and a quantity value,
and print them out nicely, including a new line character at the end.
All we need to do is to have this function applied to our mapping. Here
is what that would look like.

```ocaml
# Stock.iter print_fruit data;;
apple 10
orange 30
banana 42
- : unit = ()
```
The reason we put our data into a mapping however is probably so we can
quickly find the data. Let's actually show how to do a find.

```ocaml
# data |> Stock.find Banana;;
- : int = 42
```

This should quickly and efficiently return the quantity of `Banana`: 42.

