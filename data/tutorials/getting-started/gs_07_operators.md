---
id: operators
title: Operators
descrption: |
  
category: "Getting Started"
---

# Operators

## Using Binary Operators

In OCaml almost all binary operators are regular functions. The function underlying behind an operator is referred by surrounding the operator symbol with parenthesis. Here are the addition, string concatenation and equality functions:

```ocaml
# (+);;
- : int -> int -> int = <fun>
# (^);;
- : string -> string -> string = <fun>
# (=);;
- : 'a -> 'a -> bool = <fun>
```

Note the operator symbol for multiplication is ` * `, but OCaml comments also have an opening delimiter `(*` and a closing delimiter `*)`. To resolve the parsing ambiguity, space characters must be inserted to get the multiplication function.

```ocaml
# ( * );;
- : int -> int -> int = <fun>
```

Using operators as functions is convenient when combined with partial application. For instance, here is how to get the values which are greater or equal to 10 in a list of integers, using the function `List.filter` applied to the function `( <= ) 10`:
```ocaml
# List.filter;;
- : ('a -> bool) -> 'a list -> 'a list = <fun>

# List.filter (( <= ) 10);;
- : int list -> int list = <fun>

# List.filter (( <= ) 10) [6; 15; 7; 14; 8; 13; 9; 12; 10; 11];;
- : int list = [15; 14; 13; 12; 10; 11]
```

The first two lines are only informative.

1. The first shows the `List.filter` type, which is a function taking two parameters. The first parameter is a function; the second is a list.
2. The second is the partial application of `List.filter` to `( <= ) 10`, which is a function returning `true` if applied to a number which is greater or equal than 10.

Finally, in the third line, all the arguments expected by `List.filter` are provided. The returned list contains the values satisfying the `( <= ) 10` function.

## Defining Binary Operators

It is also possible to define binary operators. Here is an example:
```ocaml
# let cat s1 s2 = s1 ^ " " ^ s2;;
val cat : string -> string -> string = <fun>

# let ( ^? ) = cat;;
val ( ^? ) : string -> string -> string = <fun>
# "hi" ^? "friend";;
- : string = "hi friend"
```

## Unary Operators

Unary operators are also called prefix operators. In some contexts, it can make sense to shorten the name of a function into a symbol. This is often used as a way to shorten the name of a function which performs some sort of conversion over its argument.
```ocaml
# let ( !! ) = Lazy.force;;
val ( !! ) : 'a lazy_t -> 'a = <fun>

# let rec transpose = function
   | [] | [] :: _ -> []
   | rows -> List.(map hd rows :: transpose (map tl rows))
val transpose : 'a list list -> 'a list list = <fun>

# let ( ~: ) = transpose;;
val ( ~: ) : 'a list list -> 'a list list
```

This allows writing more compact code. However, be careful not to write excessively terse code, which is harder to maintain. Understanding operators must be obvious to most readers, otherwise they do more harm than good.

## Allowed Operators

OCaml has a subtle syntax, not everything is allowed as an operator symbol. An operator symbol is an identifier with a spacial syntax, it must have the following structure:

**Prefix operator**

1. First character
  * `?` `~` or
  * `!`
1. Following characters, at least one if the first character is `!`, optional otherwise
  * `$` `&` `*` `+` `-` `/` `=` `>` `@` `^` `|` or
  * `%` `<`

**Binary Operator**
1. First character
  * `$` `&` `*` `+` `-` `/` `=` `>` `@` `^` `|` or
  * `%` `<` or
  * `#`
2. Following characters, at least one if the first character is `#`, optional otherwise
  * `$` `&` `*` `+` `-` `/` `=` `>` `@` `^` `|` or
  * `%` `<` or
  * `!` `.` `:` `?` `~`

This is defined in the [Prefix and infix symbols](https://v2.ocaml.org/releases/5.1/htmlman/lex.html#sss:lex-ops-symbols) section of The OCaml Manual.

Tips:
  * Don't define wide scope operators. Restrict their scope to module or function.
  * Don't use many of them
  * Before defining a custom binary operator, check if the symbol is not already used. This can be done in two ways
    - By surrounding the candidate symbol with parentheses in UTop and see if it responds with a type or `Unbound value`
    - Use [Sherlocode](https://sherlocode.com/) to check if it is already used in some OCaml project
  * Avoid shadowing existing operators

## Operator Associativity and Precedence

Let's illustrate what operator associativity is using an example. Consider this function, it concatenates its string arguments, surrounded by `|` characters and separated by a `_` character.
```ocaml
# let par s1 s2 = "|" ^ s1 ^ "_" ^ s2 ^ "|";;
val par : string -> string -> string = <fun>

# par "hello" "world";;
- : string = "|hello_world|"
```

Let's turn `par` into two different operators.
```ocaml
# let ( @^ ) = par;;
val ( @^ ) : string -> string -> string = <fun>

# let ( &^ ) = par;;
val ( &^ ) : string -> string -> string = <fun>
```

At first sight, operators `@^` and `&^` are the same. However, the OCaml parser allows forming expression using several operators without parentheses.
```ocaml
# "foo" @^ "bar" @^ "bus";;
- : string = "|foo_|bar_bus||"

# "foo" &^ "bar" &^ "bus";;
- : string = "||foo_bar|_bus|"
```

Although both expressions are calling the same function (`par`), they are evaluated in different order.
1. Expression `"foo" @^ "bar" @^ "bus"` is evaluated as if it was `"foo" @^ ("bar" @^ "bus")`. Parentheses are added at the right, therefore `@^` _associates to the right_
1. Expression `"foo" &^ "bar" &^ "bus"` is evaluated as if if was `"(foo" @^ "bar") @^ "bus"`. Parentheses are added at the left, therefore `@^` _associates to the left_

Operator _precedence_ rules how expression combining several operators without parentheses are interpreted. For instance, using the same operators, here is how expressions using both are evaluated.
```ocaml
# "foo" &^ "bar" @^ "bus";;
- : string = "(foo, (bar, bus))"

# "foo" @^ "bar" &^ "bus";;
- : string = "((foo, bar), bus)"
```

In both cases, values are passed to `@^` before `&^`. Therefore, it is said that `@^` has higher _precedence_ over `&^`. Rules for operator priorities are detailed in the [Expressions](https://v2.ocaml.org/manual/expr.html#ss%3Aprecedence-and-associativity) section of the OCaml Manual. They can be summarized the following way. The first character of an operator dictates its associativity and priority. Here are the groups operators of first character, each group has same associativity and precedence, groups are sorted in increasing precedence order.
1. Left associative: `$` `&` `<` `=` `>` `|`
1. Right associative: `@` `^`
1. Left associative: `+` `-`
1. Left associative: `%` `*` `/`
1. Left associative: `#`

## Binding Operators

OCaml allows creation of custom `let` operator. This is often used on functions such as `Option.bind`
 or `Fun.flip List.concat_map`. In the following example, we use that mechanism to write a function which produces a list of Friday the 13th month between two years.

```ocaml
# let ( let* ) u f = List.concat_map f u;;
val ( let* ) : 'a list -> ('a -> 'b list) -> 'b list = <fun>

# let range m =
    let rec loop u i = if i < m then u else loop (i :: u) (i - 1) in loop [];;
val range : int -> int -> int list = <fun>

# let day_of_week y m d =
    let t = [| 0; 3; 2; 5; 0; 3; 5; 1; 4; 6; 2; 4 |] in
    let y = y - if m < 3 then 1 else 0 in
    (y + y / 4 - y / 100 + y / 400 + t.(m - 1) + d) mod 7
val day_of_week : int -> int -> int -> int = <fun>

# let friday13 lo hi =
    let* year = range lo hi in
    let* month = range 1 12 in
    if day_of_week year month 13 = 5 then [(13, month, year)] else []
val friday13 : int -> int -> (int * int * int) list = <fun>

# friday13 2020 2030;;
- : (int * int * int) list =
[(13, 3, 2020); (13, 11, 2020); (13, 8, 2021); (13, 5, 2022); (13, 1, 2023);
 (13, 10, 2023); (13, 9, 2024); (13, 12, 2024); (13, 6, 2025); (13, 2, 2026);
 (13, 3, 2026); (13, 11, 2026); (13, 8, 2027); (13, 10, 2028); (13, 4, 2029);
 (13, 7, 2029); (13, 9, 2030); (13, 12, 2030)]
```

https://blog.shaynefletcher.org/2016/09/custom-operators-in-ocaml.html