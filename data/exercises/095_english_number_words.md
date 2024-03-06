---
title: English Number Words
slug: "95"
difficulty: intermediate
tags: []
description: "Given a non-negative integer number, return its representation in full words."
tutorials: [ "arrays" ]
---

# Solution

```ocaml
# let full_words =
    let digit = [|"zero"; "one"; "two"; "three"; "four"; "five"; "six";
                  "seven"; "eight"; "nine"|] in
    let rec words w n =
      if n = 0 then (match w with [] -> [digit.(0)] | _ -> w)
      else words (digit.(n mod 10) :: w) (n / 10)
    in
      fun n -> String.concat "-" (words [] n);;
val full_words : int -> string = <fun>
```

# Statement

On financial documents, like cheques, numbers must sometimes be written
in full words. Example: 175 must be written as one-seven-five. Write a
function `full_words` to print (non-negative) integer numbers in full
words.

```ocaml
# full_words 175;;
- : string = "one-seven-five"
```
