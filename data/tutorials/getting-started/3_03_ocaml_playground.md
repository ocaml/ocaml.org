---
id: ocaml-playground
title: Using the OCaml Playground
short_title: The OCaml Playground
description: |
  This page will walk you through the OCaml Playground
category: "Resources"
language: English
---

Welcome to OCaml's in-browser playground!

The [OCaml Playground](https://ocaml.org/play) is made to make it easier for users, especially beginners, to get started with OCaml without worrying about installing anything. Everything is ready to use once you open it.

It has a simple interface of two panels: the _editor panel_ on the left and the _output panel_ on the right.

The editor panel is where you write code, and the output panel is where answers are displayed. Easy-peasy.

In a sense, the playground is much simpler than the [toplevel](https://ocaml.org/docs/toplevel-introduction), where you don't need to enter your code line by line on a prompt, instead type or copy code directly into the editor panel. And also, it is not required to end expressions with `;;`. To run the code in the editor panel, click on the "Run" button at the bottom of the editor panel.

Think of it like a file where you write your OCaml code. You can also clear the output anytime by clicking on the "Clear output" button on the output panel. Don't worry, it doesn't affect your code on the editor panel.

You can also share the code that you have written with others by clicking on the "Share" button (left of the "Run" button at the bottom of the editor panel). After you click on "Share", just copy the URL and share it with others.

If you ever get stuck, you can also look up the Standard library using the search bar at the top.

## Let's Enter Some Code

When you first enter the playground, you'll see the following.

![Ocaml Playground](/media/tutorials/get-started/playground.png)

Don't panic! It's just a bunch of instructions and some sample code on the editor panel and OCaml version and compilation information on the output panel.

You can clear the editor panel by simply pressing Ctrl+A and Backspace and start writing OCaml code. Likewise, you can press the "Clear output" button on the output panel to clear the panel.

Let's start with something simple. Type the following on your editor panel and click Run.

```ocaml
2+3
```

You should see the following output.

`- : int = 5`

Now, clear the output and also delete the things on the editor panel. Let's try out some strings. Go ahead and type the following editor panel and click Run.

```ocaml
"OCaml is amazing"
```

You should see the following output.

`- : string = "OCaml is amazing"`

That's amazing! You are doing great. Now let's write a short program. I'll be using the code sample that we saw when we entered the playground.

```ocaml
let num_domains = 2
let n = 20

let rec fib n =
  if n < 2 then 1
  else fib (n-1) + fib (n-2)

let rec fib_par n d =
  if d <= 1 then fib n
  else
    let a = fib_par (n-1) (d-1) in
    let b = Domain.spawn (fun _ -> fib_par (n-2) (d-1)) in
    a + Domain.join b

let () =
  let res = fib_par n num_domains in
  Printf.printf "fib(%d) = %d\n" n res
```

The output will be the following.

```text
fib(20) = 10946

val num_domains : int = 2
val n : int = 20
val fib : int -> int = <fun>
val fib_par : int -> int -> int = <fun>
```

## Autocomplete

The playground also supports code completion. It helps users by suggesting and completing their input based on the context.

![Autocomplete in the OCaml Playground](/media/tutorials/get-started/playground-autocomplete.png)

## Caveat

As you can see from the above code samples, you don't need to use `;;` at the end of definitions.

A little caveat here is that the playground behaves differently from the OCaml toplevel.
All expressions and definitions are evaluated in order, every time you click the "Run" button.
When you write `2+3` and in the next line write a string `"this is a string"` ([see here](/play#code=MiszCiJ0aGlzIGlzIGEgc3RyaW5nIg%3D%3D)), you will see an error saying:

```text
Line 1, characters 2-3:
Error: This expression has type int
       This is not a function; it cannot be applied.
```

In contrast, when you separate these expressions with a `;;`, [like this](/play#code=MiszOzsKInRoaXMgaXMgYSBzdHJpbmci), or when you bind them to names, [like this](/play#code=bGV0IHggPSAyKzMKbGV0IHkgPSAidGhpcyBpcyBhIHN0cmluZyI%3D), they are evaluated successfully, one after another.

## Bottom Line

Congratulations! You have made it to the end. Hopefully, by now, you have a better idea how to use the [OCaml Playground](/play). Use this to practice the OCaml code and have fun. Happy Hacking!
