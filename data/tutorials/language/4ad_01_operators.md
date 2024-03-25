---
id: operators
title: Operators
description: |
  Binary and prefix operators, how to use and define them, how they are parsed and evaluated.
category: "Advanced Topics"
---

## Goals

The learning goals of this tutorial are:
- Using operators as functions and reciprocally, using functions as operators
- Assign the right associativity and precedence to a custom operator
- Use and define custom `let` binders

## Using Binary Operators

In OCaml, almost all binary operators are regular functions. The function underlying an operator is referred by surrounding the operator symbol with parentheses. Here are the addition, string concatenation, and equality functions:
```ocaml
# (+);;
- : int -> int -> int = <fun>
# (^);;
- : string -> string -> string = <fun>
# (=);;
- : 'a -> 'a -> bool = <fun>
```

**Note**: the operator symbol for multiplication is ` * `, but can't be referred as `(*)`. This is because comments in OCaml are delimited by `(*` and `*)`. To resolve the parsing ambiguity, space characters must be inserted to get the multiplication function.
```ocaml
# ( * );;
- : int -> int -> int = <fun>
```

Using operators as functions is convenient when combined with partial application. For instance, here is how to get the values that are greater than or equal to 10 in a list of integers, using the function `List.filter` and an operator.
```ocaml
# List.filter;;
- : ('a -> bool) -> 'a list -> 'a list = <fun>

# List.filter (( <= ) 10);;
- : int list -> int list = <fun>

# List.filter (( <= ) 10) [6; 15; 7; 14; 8; 13; 9; 12; 10; 11];;
- : int list = [15; 14; 13; 12; 10; 11]

# List.filter (fun n -> 10 <= n) [6; 15; 7; 14; 8; 13; 9; 12; 10; 11];;
- : int list = [15; 14; 13; 12; 10; 11]
```

The first two lines and the last line are informative only.

1. The first shows the `List.filter` type, which is a function taking two parameters. The first parameter is a function; the second is a list.
2. The second is the partial application of `List.filter` to `( <= ) 10`, a function returning `true` if applied to a number that is greater or equal than 10.

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

It is a recommended practice to define operators in two steps, like shown in the example. The first definition contains the function's logic. The second definition is merely an alias of the first one. This provides a default pronunciation to the operator and clearly indicates that the operator is _syntactic sugar_: a means to ease reading by rendering the text more compact.

## Unary Operators

Unary operators are also called prefix operators. In some contexts, it can make sense to shorten a function's name into a symbol. This is often used as a way to shorten the name of a function that performs some sort of conversion over its argument.
```ocaml
# let ( !! ) = Lazy.force;;
val ( !! ) : 'a lazy_t -> 'a = <fun>

# let rec transpose = function
   | [] | [] :: _ -> []
   | rows -> List.(map hd rows :: transpose (map tl rows));;
val transpose : 'a list list -> 'a list list = <fun>

# let ( ~: ) = transpose;;
val ( ~: ) : 'a list list -> 'a list list
```

This allows users to write more compact code. However, be careful not to write excessively terse code, as it is harder to maintain. Understanding operators must be obvious to most readers, otherwise they do more harm than good.

## Allowed Operators

OCaml has a subtle syntax; not everything is allowed as an operator symbol. An operator symbol is an identifier with a special syntax, so it must have the following structure:

**Prefix Operator**

1. First character, either:
    * `?` `~`
    * `!`
1. Following characters, at least one if the first character is `?` or `~`, optional otherwise:
    * `$` `&` `*` `+` `-` `/` `=` `>` `@` `^` `|`
    * `%` `<`

**Binary Operator**

1. First character, either:
    * `$` `&` `*` `+` `-` `/` `=` `>` `@` `^` `|`
    * `%` `<`
    * `#`
1. Following characters, at least one if the first character is `#`, optional otherwise:
    * `$` `&` `*` `+` `-` `/` `=` `>` `@` `^` `|`
    * `%` `<`
    * `!` `.` `:` `?` `~`

This is defined in the [Prefix and Infix symbols](/manual/lex.html#sss:lex-ops-symbols) section of The OCaml Manual.

Tips:
  * Don't define wide scope operators. Restrict their scope to module or function.
  * Don't use many of them.
  * Before defining a custom binary operator, check that the symbol is not already used. This can be done in two ways:
    - By surrounding the candidate symbol with parentheses in UTop and see if it responds with a type or with an `Unbound value` error
    - Use [Sherlocode](https://sherlocode.com/) to check if it is already used in some OCaml project
  * Avoid shadowing existing operators.

## Operator Associativity and Precedence

Let's illustrate operator associativity with an example. The following function concatenates its string arguments, surrounded by `|` characters and separated by a `_` character.
```ocaml
# let par s1 s2 = "|" ^ s1 ^ "_" ^ s2 ^ "|";;
val par : string -> string -> string = <fun>

# par "hello" "world";;
- : string = "|hello_world|"
```

Let's turn `par` into two different operators:
```ocaml
# let ( @^ ) = par;;
val ( @^ ) : string -> string -> string = <fun>

# let ( &^ ) = par;;
val ( &^ ) : string -> string -> string = <fun>
```

At first sight, operators `@^` and `&^` are the same. However, the OCaml parser allows forming expressions using several operators without parentheses.
```ocaml
# "foo" @^ "bar" @^ "bus";;
- : string = "|foo_|bar_bus||"

# "foo" &^ "bar" &^ "bus";;
- : string = "||foo_bar|_bus|"
```

Although both expressions are calling the same function (`par`), they are evaluated in different orders.
1. Expression `"foo" @^ "bar" @^ "bus"` is evaluated as if it was `"foo" @^ ("bar" @^ "bus")`. Parentheses are added at the right, therefore `@^` _associates to the right_
1. Expression `"foo" &^ "bar" &^ "bus"` is evaluated as if it was `"(foo" &^ "bar") &^ "bus"`. Parentheses are added at the left, therefore `&^` _associates to the left_

Operator _precedence_ rules how expressions combining different operators without parentheses are interpreted. For instance, using the same operators, here is how expressions using both are evaluated:
```ocaml
# "foo" &^ "bar" @^ "bus";;
- : string = "|foo_|bar_bus||"

# "foo" @^ "bar" &^ "bus";;
- : string = "||foo_bar|_bus|"
```

In both cases, values are passed to `@^` before `&^`. Therefore, it is said that `@^` has _precedence_ over `&^`. Rules for operator priorities are detailed in the [Expressions](/manual/expr.html#ss%3Aprecedence-and-associativity) section of the OCaml Manual. They can be summarised the following way. The first character of an operator dictates its associativity and priority. Here are the first characters of the groups' operators. Each group has the same associativity and precedence. Groups are sorted in increasing precedence order.
1. Left associative: `$` `&` `<` `=` `>` `|`
1. Right associative: `@` `^`
1. Left associative: `+` `-`
1. Left associative: `%` `*` `/`
1. Left associative: `#`

The complete list of precedence is longer because it includes the predefined operators that are not allowed to be used as custom operators. The OCaml Manual has a [table](/api/Ocaml_operators.html) that sums up the operator associativity rules.

## Binding Operators

OCaml allows the creation of custom `let` operators. This is often used on monad-related functions such as `Option.bind` or `List.concat_map`. See [Monads](/docs/monads) for more on this topic.

The `doi_parts` function attempts to extract the registrant and identifier parts from string expected to contain a [Digital Object Identifier (DOI)](https://en.wikipedia.org/wiki/Digital_object_identifier).
```ocaml
# let ( let* ) = Option.bind;;
val ( let* ) : 'a option -> ('a -> 'b option) -> 'b option = <fun>

# let doi_parts s =
  let open String in
  let* slash = rindex_opt s '/' in
  let* dot = rindex_from_opt s slash '.' in
  let prefix = sub s 0 dot in
  let len = slash - dot - 1 in
  if len >= 4 && ends_with ~suffix:"10" prefix then
    let registrant = sub s (dot + 1) len in
    let identifier = sub s (slash + 1) (length s - slash - 1) in
    Some (registrant, identifier)
  else
    None;;

# doi_parts "doi:10.1000/182";;
- : (string * string) option = Some ("1000", "182")

# doi_parts "https://doi.org/10.1000/182";;
- : (string * string) option = Some ("1000", "182")

```

This function is using `Option.bind` as a custom binder over the calls to `rindex_opt` and `rindex_from_opt`. This allows to only consider the case where both searches are successful and return the positions of the found characters. If any of them fails, `doi_parts` implicitly returns `None`.

The `let open String in` construct allows calling functions `rindex_opt`, `rindex_from_opt`, `length`, `ends_with` and `sub` from module `String` without prefixing each of them with `String.` within the scope of the definition of `doi_parts`.

The rest of the function applies if relevant delimiting characters have been found. It does performs additional checks and extracts registrant and identifier form the string `s`, if possible.

 <!-- TODO: move this into the list tutorial
 In the following example, we use that mechanism to write a function which produces the list of Friday 13th dates between two years.

```ocaml
# let ( let* ) u f = List.concat_map f u;;
val ( let* ) : 'a list -> ('a -> 'b list) -> 'b list = <fun>

# let range lo =
    let rec loop u hi = if hi < lo then u else loop (hi :: u) (hi - 1) in loop [];;
val range : int -> int -> int list = <fun>

# let day_of_week y m d =
    let t = [| 0; 3; 2; 5; 0; 3; 5; 1; 4; 6; 2; 4 |] in
    let y = y - if m < 3 then 1 else 0 in
    (y + y / 4 - y / 100 + y / 400 + t.(m - 1) + d) mod 7;;
val day_of_week : int -> int -> int -> int = <fun>

# let friday13 lo hi =
    let* year = range lo hi in
    let* month = range 1 12 in
    if day_of_week year month 13 = 5 then [(13, month, year)] else [];;
val friday13 : int -> int -> (int * int * int) list = <fun>

# friday13 2020 2030;;
- : (int * int * int) list =
[(13, 3, 2020); (13, 11, 2020); (13, 8, 2021); (13, 5, 2022); (13, 1, 2023);
 (13, 10, 2023); (13, 9, 2024); (13, 12, 2024); (13, 6, 2025); (13, 2, 2026);
 (13, 3, 2026); (13, 11, 2026); (13, 8, 2027); (13, 10, 2028); (13, 4, 2029);
 (13, 7, 2029); (13, 9, 2030); (13, 12, 2030)]
```

Calling `range lo hi` returns a increasing list of consecutive integers between `lo` and `hi`, including both.

The function `day_of_week` calculates the day of the week for a given date. Generative large language model chatbots such as ChatGPT do a very good job at explaining such a function. Have a look at the result of a prompt such as “Explain how this code works” followed by the code, if you want to learn more about this function.

The `friday13` function uses an algorithm with two nested loops. Each `let*` acts almost like a `for` loop with a counter, a starting value, and an ending value. Each inner loop iteration produces a list. The global result is the concatenation and the flattening of those lists into a single one.
-->
