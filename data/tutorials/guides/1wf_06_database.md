---
id: database
title: Database handling
description: >
  A guide to database handling in OCaml with the Caqti and ppx_rapper libraries
category: "Guides"
---

## Introduction

The OCaml ecosystem provides multiple libraries that can be used to access an RDBMS.

One of these libraries is `caqti`. It has the following features:

- It can be used with multiple RDBMS (Postgres, MariaDB, SQLite3).
- It can be used in a Lwt context. That permits use in some application servers. Especially the Dream framework, that has some dedicated functions that help using Caqti.
- It can be used with the `ppx_rapper` preprocessor. This preprocessor converts an annotated SQL query into a query function that leverages the strong typing feature of OCaml.

This tutorial is made to facilitate the integration of the multiple involved libraries.

## The Lwt and `Lwt_result` context

`caqti` provides blocking functions which avoid the need of `lwt`, however one can use the `ppx_rapper`
preprocessor and produce Lwt promises, then some `lwt` integration is needed. Moreover `caqti` queries
return `Result` values which can be `Ok the_expected_result` or `Error the_error_description`.

Chaining multiple queries may be cumbersome: testing the result value and extracting the expected result if `Ok`. The `Lwt_result` monad can make implicit each error test and result extraction.

The idea is instead of presenting the program like this:

```ocaml
let () =
  let result1 = query1 () in
  let result2 = query2 () in
  ...
```

We present the program like:

```ocaml
open Lwt_result.Syntax

let () =
  match Lwt_main.run(
    let* result1 = query1 () in
    let* result2 = query2 () in
    Lwt.return (Result.Ok ()))
  with
  | Result.Ok () -> ...
  | Result.Error r -> ...
```

The `let*` notation is associated to the `bind` function which deals with Lwt sequencing
(a `query1 ()` is typically of type `('a, 'b) result Lwt.t` which represent a computation
which need to be scheduled). Once the query has been scheduled and executed, the `Result`
value is analysed and the value of `Result.Ok value` is extracted. If the result is `Error err`,
the thread of queries is aborted.

## The database connection

`caqti` provides a `connect` function which establish a connection to the database, but it
is more secure to use `with_connection` which garantee the closure of the database even in the
presence of an error.

Then the following template should be used:

```ocaml
let () =
  match Lwt_main.run @@
    Caqti_lwt.with_connection(Uri.of_string "sqlite3:essai.sqlite")
      (function cnx ->
         ...

         Lwt.return (Result.Ok ())
      )
  with
  | Result.Ok () -> ...
  | Result.Error err -> ...
```

The following URIs are supported:

- `"sqlite3:filename"` (using sqlite3 library),
- `"postgresql://user:passwd@host/database"` (using postgresql library),
- `"pgx://user:passwd@host/database"` (using pgx library),
- `"mariadb://user:passwd@host/database"` (using mariadb library),


## Declaring and using queries

### Default queries

The declaration of Caqti queries is rather complex. Hopefully, the `ppx_rapper` preprocessor
permits an easy composition of such queries.

The idea is to type something like this:

```ocaml
let query = [%rapper get_many {sql| SELECT @int{id}, @string?{value} FROM a
                                    WHERE category = %string{category} |sql} ]  
```

`%type{name}` is used to indicate parameters which will be provided when calling the query.
`@type{name}` is uses to indicate values (column names) which will be returned by the query.

Types may be `int`, `int32`, `int64`, `string`, `octets`, `float`, `bool`, `pdate`,
`ptime_span` and `cdate` and `ctime` from `caqti-type-calendar`. A `?` like in this
example is used to return option values: `None` if the SQL value is `NULL`, `Some v`.

See [ppx_raper reference](https://github.com/roddyyaga/ppx_rapper) for defining custom types.

In order to execute the query, we have to type:

```ocaml
let* result = query ~category:"a category" cnx
```

With every input parameters as a labelled argument. If the query has no parameter (no
`%` values), `let* result = query () cnx` should be typed.

There are different types of queries. A `get_many` query (like the example) returns a list of
rows. `get_one` just returns the unique row, `get_opt` returns an option value (`None` or `Some`
depending of the existance of a queried row), `execute` returns nothing `()`.

By default rows are presented as tuples.

### ppx_rapper options

Depending of the needs, a `ppx_rapper` query can be written as

```ocaml
  [%rapper get_many {sql|...|sql} options]
```

Where supported options are:

- `record_in` : instead of calling the query with one argument per parameter, a single
argument is provided. It must be a record whose the fields correspond to the parameters.
- `record_out` : instead of outputing row(s) as tuple(s), they are presented as record(s).
- `function_out` : the query is called with a function as its first argument. This function
is called for each row with every values (column names) as a labelled arguments. The return value of the query
is composed of the returned values of this function. This works like [List/Option.map].

Options are separated by whitespaces.

## Custom error handling

`(let*)` from `Lwt_result.Syntax` is handy if we want a default error
handling (stopping the chain of queries, returning an error type).

If we want our own error handling, we can use the `lwt_ppx` preprocessor and
use the `let%lwt` or `match%lwt` tokens.

Typically:

```ocaml
     match%lwt query_a () cnx with
     | Result.Ok _value -> do_something;
                  Lwt.return (Result.Ok ())
     | Result.Error err -> do_something;
                  Lwt.return (Result.Error err)
```

Note: we can also change the `Lwt.return` values... An ok query could be
wrong if the returned values do not respect some assertions. An error query could also be mitigated.

If we want to embed the custom error handled query in the `(let*)` chain,
simply type:

```ocaml
 let* () = match%lwt ... in
```

## Itering a List of Queries, Transactions

Using `List.map` creates queries that won't be chained from
a `lwt` point of view. The `Lwt_list.iter_s` and `Lwt_list.map_s` can iter
them... but won't stop at the first error.

If we want to iter all the queries even in the presence of an error, we can
type

```ocaml
let%lwt () = Lwt_list.iter_s  item_to_query_function list in
Lwt.return (Result.OK ())
```

Or

```ocaml
let%lwt result_list = Lwt_list.map_s item_to_query_function list in
analyse_the_result_list;
Lwt.return (Result.OK ())
```

But it would be better to define a function:

```ocaml
let iter_queries queries cnx =
   List.fold_left
     (fun a f -> Lwt_result.bind a (fun () -> f cnx))
     (Lwt.return (Ok ()))
     queries
```

This function iters a list of functions with a connection as an argument and executes each query.
It can be used in the following context (where `insert_a_record` is defined in the example
section):
```ocaml
   let* () = iter_queries (List.map insert_a_record
           [ {id=78; text=Some "record78"};
             {id=142; text=Some "record142"};
             {id=42; text=Some "record78"} ]) cnx
   in
   ...
```

This iteration stops at the first error and returns this error.

A transaction (a rollback is executed at the first error) can be defined by the following
function (which needs the `lwt_ppx` preprocessor):

```ocaml
let transaction queries cnx =
  let module Connection = (val cnx : Caqti_lwt.CONNECTION) in
  let* () = Connection.start () in
  match%lwt iter_queries queries cnx with
  |  Ok () -> Connection.commit ()
  |  Error e -> let%lwt _ = Connection.rollback () in
                  Lwt.return (Error e)
```

The `transaction` function is used in the same way as `iter_queries`.

## Example

The following example is a working program that illustrates the use of the different
`ppx_rapper` options.

```ocaml
open Lwt_result.Syntax

type a_row = { id:int; text: string option}

let insert_a = [%rapper
                     execute {sql| INSERT INTO a VALUES
                                     (%int{id}, %string?{text})
                              |sql}
               ]
let insert_a_record = [%rapper
                     execute {sql| INSERT INTO a VALUES
                                     (%int{id}, %string?{text})
                              |sql}
               record_in]

let query_a = [%rapper
                     get_many {sql| SELECT @int{id}, @string?{text}
                                    FROM a
                               |sql}
              ]

let query_a_record = [%rapper
                     get_many {sql| SELECT @int{id}, @string?{text}
                                    FROM a
                               |sql}
                     record_out]
let query_a_function = [%rapper
                     get_many {sql| SELECT @int{id}, @string?{text}
                                    FROM a
                               |sql}
                     function_out]

let string_option_to_string so =
  match so with
  | None -> "NULL"
  | Some s -> s

let () =
  match Lwt_main.run @@
    Caqti_lwt.with_connection(Uri.of_string "sqlite3:essai.sqlite")
      (function cnx ->
         let* () = insert_a ~id:1 ~text:(Some "Essai") cnx in
         let* () = insert_a_record {id=2; text = None} cnx in
         let* table_a = query_a () cnx in
         List.iter (fun (id,text) -> Printf.printf "id=%d text = %s\n"
                                                id (string_option_to_string text))
                   table_a;
         let* table_a_record = query_a_record () cnx in
         List.iter (fun ligne -> Printf.printf "id=%d text = %s\n"
                                              ligne.id
                                              (string_option_to_string ligne.text))
                    table_a_record;
         let* table_a_fun_list = query_a_function
                              (fun ~id ~text ->   Printf.sprintf "id=%d text = %s\n"
                                                    id (string_option_to_string text))
                              () cnx in
         List.iter output_string table_a_fun_list;
         Lwt.return (Result.Ok ()))
  with
  | Result.Ok () ->
       output_string "OK\n"
  | Result.Error err ->
       output_string (Caqti_error.show err)
```

Its corresponding `dune` file is

```lisp
(executable
  (name main)
  (libraries
      ppx_rapper_lwt
      lwt
      caqti-lwt
      caqti-driver-sqlite3)
  (preprocess (pps ppx_rapper)))
```

## References

[Caqti reference](https://github.com/paurkedal/ocaml-caqti)

[ppx_rapper reference](https://github.com/roddyyaga/ppx_rapper)

