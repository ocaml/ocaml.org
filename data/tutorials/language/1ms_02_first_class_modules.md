---
id: first-class-modules
title: First-Class Modules
description: >
  First-Class Modules permit the use of modules as ordinary values.
category: "Module System"
---

## Introduction

First-class modules let you treat modules as values. You can pass them to functions, return them from functions, and store them in data structures. This provides an alternative to functors for some use cases and can simplify your APIs.

**Prerequisites**: [Modules](/docs/modules), [Functors](/docs/functors).

## Basic Example

Here's how to pack a module into a value and unpack it:

```ocaml
# module type Printer = sig
    val print : string -> unit
  end;;
module type Printer = sig val print : string -> unit end

# module SimplePrinter = struct
    let print s = print_endline ("Message: " ^ s)
  end;;
module SimplePrinter : sig val print : string -> unit end

# (* Pack a module into a value *)
  let printer = (module SimplePrinter : Printer);;
val printer : (module Printer) = <module>

# (* Unpack and use it *)
  let module P = (val printer : Printer) in
  P.print "Hello";;
Message: Hello
- : unit = ()
```

The expression `(module SimplePrinter : Printer)` converts a module into a value of type `(module Printer)`. The expression `(val printer : Printer)` converts it back. The type annotation can often be omitted when it can be inferred.

## Passing Modules to Functions

You can write functions that accept modules as parameters:

```ocaml
# let print_with (module P : Printer) message =
    P.print message;;
val print_with : (module Printer) -> string -> unit = <fun>

# print_with printer "Works!";;
Message: Works!
- : unit = ()
```

The pattern `(module P : Printer)` automatically unpacks the first-class module, making `P` available as a regular module inside the function.

## Practical Example: Multiple Implementations

First-class modules shine when you need to choose between implementations at runtime:

```ocaml
# module type Database = sig
    val name : string
    val execute : string -> string list
  end;;
module type Database =
  sig val name : string val execute : string -> string list end

# let postgres_connect host db_name =
    (module struct
      let name = "PostgreSQL"
      let execute query =
        Printf.printf "[PostgreSQL] %s\n" query;
        ["result"]
    end : Database);;
val postgres_connect : 'a -> 'b -> (module Database) = <fun>

# let mysql_connect host db_name =
    (module struct
      let name = "MySQL"
      let execute query =
        Printf.printf "[MySQL] %s\n" query;
        ["result"]
    end : Database);;
val mysql_connect : 'a -> 'b -> (module Database) = <fun>

# let execute (module D : Database) query =
    Printf.printf "Using %s\n" D.name;
    D.execute query;;
val execute : (module Database) -> string -> string list = <fun>
```

Now you can choose the database at runtime and store different implementations in data structures:

```ocaml
# let db1 = postgres_connect "localhost" "mydb";;
val db1 : (module Database) = <module>

# let db2 = mysql_connect "localhost" "backup";;
val db2 : (module Database) = <module>

# execute db1 "SELECT * FROM users";;
Using PostgreSQL
[PostgreSQL] SELECT * FROM users
- : string list = ["result"]

# (* Store in a list *)
  let all_dbs = [db1; db2];;
val all_dbs : (module Database) list = [<module>; <module>]

# List.iter (fun db -> ignore (execute db "SELECT 1")) all_dbs;;
Using PostgreSQL
[PostgreSQL] SELECT 1
Using MySQL
[MySQL] SELECT 1
- : unit = ()
```

## Runtime Selection

A common pattern is selecting an implementation based on configuration:

```ocaml
# type config = { db_type : string; host : string };;
type config = { db_type : string; host : string; }

# let get_database config =
    match config.db_type with
    | "postgres" -> postgres_connect config.host "mydb"
    | "mysql" -> mysql_connect config.host "mydb"
    | _ -> failwith "Unknown database type";;
val get_database : config -> (module Database) = <fun>

# let config = { db_type = "mysql"; host = "localhost" };;
val config : config = {db_type = "mysql"; host = "localhost"}

# let db = get_database config;;
val db : (module Database) = <module>

# execute db "SELECT * FROM config";;
Using MySQL
[MySQL] SELECT * FROM config
- : string list = ["result"]
```

## Using Type Constraints

When you need to expose the type from a first-class module, use type constraints with `with type`:

```ocaml
# module type Comparable = sig
    type t
    val compare : t -> t -> int
  end;;
module type Comparable = sig type t val compare : t -> t -> int end

# let int_comparable = (module struct
    type t = int
    let compare = Int.compare
  end : Comparable with type t = int);;
val int_comparable : (module Comparable with type t = int) = <module>

# let sort (type a) (module C : Comparable with type t = a) list =
    List.sort C.compare list;;
val sort : (module Comparable with type t = 'a) -> 'a list -> 'a list = <fun>

# sort int_comparable [3; 1; 4; 1; 5];;
- : int list = [1; 1; 3; 4; 5]
```

The `(type a)` syntax creates a locally abstract type that connects the module's type `t` with the list elements' type.

## When to Use First-Class Modules

**Use first-class modules when you need to:**
- Pass different module implementations to the same function
- Store modules in data structures (lists, hash tables)
- Choose implementations at runtime based on configuration
- Build plugin systems

**Use functors when you need to:**
- Generate many similar modules at compile time
- Maximize performance (first-class modules have small runtime overhead)
- Complex module relationships with multiple dependencies

## Common Patterns

### Plugin Registry

```ocaml
# module type Plugin = sig
    val name : string
    val run : unit -> unit
  end;;
module type Plugin = sig val name : string val run : unit -> unit end

# let plugins = ref [];;
val plugins : '_weak1 list ref = {contents = []}

# let register (module P : Plugin) =
    plugins := (module P : Plugin) :: !plugins;
    Printf.printf "Registered: %s\n" P.name;;
val register : (module Plugin) -> unit = <fun>

# register (module struct
    let name = "Logger"
    let run () = print_endline "Logging..."
  end);;
Registered: Logger
- : unit = ()

# List.iter (fun (module P : Plugin) -> P.run ()) !plugins;;
Logging...
- : unit = ()
```

### Heterogeneous Collections

```ocaml
# module type Formatter = sig
    val format : string -> string
  end;;
module type Formatter = sig val format : string -> string end

# let formatters = [
    ("upper", (module struct let format = String.uppercase_ascii end : Formatter));
    ("lower", (module struct let format = String.lowercase_ascii end : Formatter));
  ];;
val formatters : (string * (module Formatter)) list =
  [("upper", <module>); ("lower", <module>)]

# let apply name text =
    match List.assoc_opt name formatters with
    | Some (module F) -> F.format text
    | None -> text;;
val apply : string -> string -> string = <fun>

# apply "upper" "hello";;
- : string = "HELLO"
```

## Key Points

- Pack modules with `(module M : ModuleType)`
- Unpack with `let module M = (val x : ModuleType) in ...`
- Functions can directly pattern match: `fun (module M : ModuleType) -> ...`
- Use `with type` constraints to expose abstract types
- First-class modules enable runtime polymorphism without objects
- Small runtime overhead compared to functors

## Conclusion

First-class modules let you write flexible code that chooses implementations at runtime. They're particularly useful for plugin systems, configuration-based selection, and when you need to store different module implementations in data structures.

For compile-time module generation and maximum performance, use functors instead.
