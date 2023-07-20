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
users and their associated passwords. I could with the Map module create
a mapping from user names to their passwords. The mapping module not
only does this but it does it fairly efficiently. It also does this in a
functional way. In the example below I am going to do a mapping from
strings to strings. However, it is possible to do mappings with all
different types of data.

To create a Map I can do:

```ocaml
# module MyUsers = Map.Make(String);;
module MyUsers :
  sig
    type key = string
    type 'a t = 'a Map.Make(String).t
    val empty : 'a t
    val is_empty : 'a t -> bool
    val mem : key -> 'a t -> bool
    val add : key -> 'a -> 'a t -> 'a t
    val update : key -> ('a option -> 'a option) -> 'a t -> 'a t
    val singleton : key -> 'a -> 'a t
    val remove : key -> 'a t -> 'a t
    val merge :
      (key -> 'a option -> 'b option -> 'c option) -> 'a t -> 'b t -> 'c t
    val union : (key -> 'a -> 'a -> 'a option) -> 'a t -> 'a t -> 'a t
    val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
    val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
    val iter : (key -> 'a -> unit) -> 'a t -> unit
    val fold : (key -> 'a -> 'b -> 'b) -> 'a t -> 'b -> 'b
    val for_all : (key -> 'a -> bool) -> 'a t -> bool
    val exists : (key -> 'a -> bool) -> 'a t -> bool
    val filter : (key -> 'a -> bool) -> 'a t -> 'a t
    val filter_map : (key -> 'a -> 'b option) -> 'a t -> 'b t
    val partition : (key -> 'a -> bool) -> 'a t -> 'a t * 'a t
    val cardinal : 'a t -> int
    val bindings : 'a t -> (key * 'a) list
    val min_binding : 'a t -> key * 'a
    val min_binding_opt : 'a t -> (key * 'a) option
    val max_binding : 'a t -> key * 'a
    val max_binding_opt : 'a t -> (key * 'a) option
    val choose : 'a t -> key * 'a
    val choose_opt : 'a t -> (key * 'a) option
    val split : key -> 'a t -> 'a t * 'a option * 'a t
    val find : key -> 'a t -> 'a
    val find_opt : key -> 'a t -> 'a option
    val find_first : (key -> bool) -> 'a t -> key * 'a
    val find_first_opt : (key -> bool) -> 'a t -> (key * 'a) option
    val find_last : (key -> bool) -> 'a t -> key * 'a
    val find_last_opt : (key -> bool) -> 'a t -> (key * 'a) option
    val map : ('a -> 'b) -> 'a t -> 'b t
    val mapi : (key -> 'a -> 'b) -> 'a t -> 'b t
    val to_seq : 'a t -> (key * 'a) Seq.t
    val to_rev_seq : 'a t -> (key * 'a) Seq.t
    val to_seq_from : key -> 'a t -> (key * 'a) Seq.t
    val add_seq : (key * 'a) Seq.t -> 'a t -> 'a t
    val of_seq : (key * 'a) Seq.t -> 'a t
  end
```

OK, we have created the module `MyUsers`.  Now, let's start putting
something into it.  Where do we start?  Well, let's create an empty
map to begin with:

```ocaml
# let m = MyUsers.empty;;
val m : 'a MyUsers.t = <abstr>
```

Hummm. An empty map is kind of boring, so let's add some data.

```ocaml
# let m = MyUsers.add "fred" "sugarplums" m;;
val m : string MyUsers.t = <abstr>
```

We have now created a new map—again called `m`, thus masking the previous
one—by adding
"fred" and his password "sugarplums" to our previous empty map.
There is a fairly important point to make here. Once we have added the
string "sugarplums" we have fixed the types of mappings that we can do.
This means our mapping in our module `MyUsers` is from strings _to strings_.
If we want a mapping from strings to integers or a mapping from integers
to whatever we will have to create a different mapping.

Let's add in some additional data just for kicks.

```ocaml
# let m = MyUsers.add "tom" "ilovelucy" m;;
val m : string MyUsers.t = <abstr>
# let m = MyUsers.add "mark" "ocamlrules" m;;
val m : string MyUsers.t = <abstr>
# let m = MyUsers.add "pete" "linux" m;;
val m : string MyUsers.t = <abstr>
```

Now that we have some data inside of our map, wouldn't it be nice
to be able to view that data at some point? Let's begin by creating a
simple print function.

```ocaml
# let print_user key password =
  print_string(key ^ " " ^ password ^ "\n");;
val print_user : string -> string -> unit = <fun>
```

We have here a function that will take two strings, a key, and a password,
and print them out nicely, including a new line character at the end.
All we need to do is to have this function applied to our mapping. Here
is what that would look like.

```ocaml
# MyUsers.iter print_user m;;
fred sugarplums
mark ocamlrules
pete linux
tom ilovelucy
- : unit = ()
```
The reason we put our data into a mapping however is probably so we can
quickly find the data. Let's actually show how to do a find.

```ocaml
# MyUsers.find "fred" m;;
- : string = "sugarplums"
```

This should quickly and efficiently return Fred's password: "sugarplums".

