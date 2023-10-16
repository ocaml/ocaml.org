---
id: toplevel-introduction
title: Introduction to the OCaml Toplevel
description: |
  This page will give you a brief introduction to the OCaml toplevel.
category: "Tooling"
---

# Introduction to the OCaml Toplevel

An OCaml toplevel is a chat between the user and OCaml. The user writes OCaml code, and UTop evaluates it. This is why it is also called a Read-Eval-Print-Loop (REPL). Several OCaml toplevels exist, like `ocaml` and `utop`. We recommend using UTop, which is part of the [OCaml Platform](/docs/platform) toolchain. 

To run UTop, we use the `utop` command, which looks like this:
```shell
$ utop
────────┬─────────────────────────────────────────────────────────────┬─────────
        │ Welcome to utop version 2.12.1 (using OCaml version 5.0.0)! │
        └─────────────────────────────────────────────────────────────┘

Type #utop_help for help about using utop.

─( 17:00:09 )─< command 0 >──────────────────────────────────────{ counter: 0 }─
utop #
```

Press `Ctrl-D` (end of file) or enter `#quit;;` to exit `utop`.

UTop displays a hash prompt `#`, similar to the `$` in the CLI. This `#` means it is waiting for input, so you can start writing your code after the prompt. To evaluate it, add a double semicolon `;;` to signal the end of the expression and press `Enter`.

For instance, consider the following code snippet:
```ocaml
# 2 + 2;;
- : int = 4
```

In the code snippet above, `2 + 2;;` is the user's input, and `- : int = 4` is the output of OCaml.

If you need to amend the code before hitting `Enter`, you can use your keyboard's right and left arrows to move inside the text. The up and down arrows allow navigation through previously evaluated expressions. Typing `Enter` without a double semicolon `;;` will create a new line, so you can write multiple-line expressions this way.

Commands beginning with a hash character `#`, such as `#quit` or `#help`, are not evaluated by OCaml; they are interpreted as commands by UTop.

You're now ready to hack with UTop! If you hit any issue with the toplevel, don't hesitate to [ask on Discuss](https://discuss.ocaml.org/).
