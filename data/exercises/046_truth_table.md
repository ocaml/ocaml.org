---
title: Truth Tables for Logical Expressions (2 Variables)
slug: "46"
difficulty: intermediate
tags: [ "logic" ]
description: "Generate a truth table for a two-variable boolean expression, returning a list of variable value pairs and the expression's results"
---

```ocaml
type bool_expr =
  | Var of string
  | Not of bool_expr
  | And of bool_expr * bool_expr
  | Or of bool_expr * bool_expr
```

## Solution

```ocaml
# let rec eval2 a val_a b val_b = function
    | Var x -> if x = a then val_a
               else if x = b then val_b
               else failwith "The expression contains an invalid variable"
    | Not e -> not (eval2 a val_a b val_b e)
    | And(e1, e2) -> eval2 a val_a b val_b e1 && eval2 a val_a b val_b e2
    | Or(e1, e2) -> eval2 a val_a b val_b e1 || eval2 a val_a b val_b e2
  let table2 a b expr =
    [(true,  true,  eval2 a true  b true  expr);
     (true,  false, eval2 a true  b false expr);
     (false, true,  eval2 a false b true  expr);
     (false, false, eval2 a false b false expr)];;
val eval2 : string -> bool -> string -> bool -> bool_expr -> bool = <fun>
val table2 : string -> string -> bool_expr -> (bool * bool * bool) list =
  <fun>
```

## Statement

Let us define a small "language" for boolean expressions containing
variables:

```ocaml
# type bool_expr =
  | Var of string
  | Not of bool_expr
  | And of bool_expr * bool_expr
  | Or of bool_expr * bool_expr;;
type bool_expr =
    Var of string
  | Not of bool_expr
  | And of bool_expr * bool_expr
  | Or of bool_expr * bool_expr
```

A logical expression in two variables can then be written in prefix
notation.  For example, `(a ∨ b) ∧ (a ∧ b)` is written:

```ocaml
# And (Or (Var "a", Var "b"), And (Var "a", Var "b"));;
- : bool_expr = And (Or (Var "a", Var "b"), And (Var "a", Var "b"))
```

Define a function, `table2` which returns the truth table of a given
logical expression in two variables (specified as arguments). The return
value must be a list of triples containing
`(value_of_a, value_of_b, value_of_expr)`.

```ocaml
# table2 "a" "b" (And (Var "a", Or (Var "a", Var "b")));;
- : (bool * bool * bool) list =
[(true, true, true); (true, false, true); (false, true, false);
 (false, false, false)]
```
