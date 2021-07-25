---
title: Hashtables
description: >
  Discover efficient and mutable lookup tables with OCaml's Hashtbl module
users:
  - intermediate
  - advanced
tags: [ "stdlib" ]
date: 2021-05-27T21:07:30-00:00
---

## Module Hashtbl

The Hashtbl module implements an efficient, mutable lookup table. To
create a hash table we could write:

```ocaml
# let my_hash = Hashtbl.create 123456
val my_hash : ('_weak1, '_weak2) Hashtbl.t = <abstr>
```
The 123456 is the initial size of the hashtbl. This initial number is
just your best guess as to the amount of data that you will be putting
into the hash table. The hash table can grow if you under-estimate the
size so don't worry about it too much. The type of my_hash is:

```ocaml
# my_hash
- : ('_weak1, '_weak2) Hashtbl.t = <abstr>
```

The `'_weak1` and `'_weak2` correspond to the key and value types, respectively.
There are no concrete types (e.g., `int` or `float * string`) filled in in
those slots because the type of the key and value are not yet
determined. The underscore indicates that the key and data types, once
chosen, will be fixed. In other words, you can't sometimes use a given
hashtable with ints for keys, and then later use a string as a key in
that same hashtable.

Lets add some data to `my_hash`. Lets say I am working on a cross word
solving program and I want to find all words that start with a certain
letter. First I need to enter the data into `my_hash`.

Note that a hashtable is modified by in-place updates, so, unlike a map,
another hash table is _not_ created every time you change the table. Thus,
the code `let my_hash = Hashtbl.add my_hash ...` wouldn't make any
sense. Instead, we would write something like this:

```ocaml
# Hashtbl.add my_hash "h" "hello";
  Hashtbl.add my_hash "h" "hi";
  Hashtbl.add my_hash "h" "hug";
  Hashtbl.add my_hash "h" "hard";
  Hashtbl.add my_hash "w" "wimp";
  Hashtbl.add my_hash "w" "world";
  Hashtbl.add my_hash "w" "wine"
- : unit = ()
```

If we want to find one element in `my_hash` that has an `"h"` in it then we
would write: 

```ocaml
# Hashtbl.find my_hash "h"
- : string = "hard"
```

Notice how it returns just one element? That element
was the last one entered in with the value of `"h"`.

What we probably want is all the elements that start with `"h"`. To do
this we want to *find all* of them. What better name for this than
`find_all`?

```ocaml
# Hashtbl.find_all my_hash "h"
- : string list = ["hard"; "hug"; "hi"; "hello"]
```

returns `["hard"; "hug"; "hi"; "hello"]`.

If you remove a key, its previous value becomes again the default one
associated to the key.

```ocaml
# Hashtbl.remove my_hash "h";;
- : unit = ()
# Hashtbl.find my_hash "h";;
- : string = "hug"
```

This behavior is interesting for the above example or when, say, the
keys represent variables that can be temporarily masked by a local
variables of the same name.

In other contexts, one may prefer new values to *replace* the previous
ones.  In this case, one uses `Hashtbl.replace`:

```ocaml
# Hashtbl.replace my_hash "t" "try";
  Hashtbl.replace my_hash "t" "test";
  Hashtbl.find_all my_hash "t"
- : string list = ["test"]

# Hashtbl.remove my_hash "t";
  Hashtbl.find my_hash "t"
Exception: Not_found.
```

To find out whether there is an
entry in `my_hash` for a letter we would do:

```ocaml
# Hashtbl.mem my_hash "h"
- : bool = true
```
