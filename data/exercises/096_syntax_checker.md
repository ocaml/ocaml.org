---
title: Syntax Checker
slug: "96"
difficulty: intermediate
tags: []
description: "Check whether a given string conforms to the syntax rules of a legal identifier in a programming language."
tutorials: [ "basic-data-types" ]
---

# Solution

```ocaml
# let identifier =
    let is_letter c = 'a' <= c && c <= 'z' in
    let is_letter_or_digit c = is_letter c || ('0' <= c && c <= '9') in
    let rec is_valid s i not_after_dash =
      if i < 0 then not_after_dash
      else if is_letter_or_digit s.[i] then is_valid s (i - 1) true
      else if s.[i] = '-' && not_after_dash then is_valid s (i - 1) false
      else false in
    fun s -> (
        let n = String.length s in
      n > 0 && is_letter s.[n - 1] && is_valid s (n - 2) true);;
val identifier : string -> bool = <fun>
```

# Statement

![Syntax graph](/media/problems/syntax-graph.gif)

In a certain programming language (Ada) identifiers are defined by the
syntax diagram (railroad chart) opposite. Transform the syntax diagram
into a system of syntax diagrams which do not contain loops; i.e. which
are purely recursive. Using these modified diagrams, write a function
`identifier : string -> bool` that can check whether or not a given
string is a legal identifier.

```ocaml
# identifier "this-is-a-long-identifier";;
- : bool = true
```
