---
id: toplevel-introduction
title: Introduction to the OCaml Toplevel
description: |
  This page will give you a brief introduction to the OCaml toplevel.
category: "Tooling"
language: English
---

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

Lines ending with double semicolons trigger the parsing, type checking, and evaluation of everything typed between the prompt and the double semicolon. The interpretation of that double semicolon isn't made by the OCaml interpreter; it is made by UTop. Once the evaluation of a double semicolon terminated entry is over, the REPL waits for another piece of input.

Code samples beginning with `#` are intended to be copied/pasted into UTop.

For instance, consider the following code snippet:

```ocaml
# 2 + 2;;
- : int = 4
```

In the code snippet above, `2 + 2;;` is the user's input, and `- : int = 4` is the output of OCaml.

If you need to amend the code before hitting `Enter`, you can use your keyboard's right and left arrows to move inside the text. The up and down arrows allow navigation through previously evaluated expressions. Typing `Enter` without a double semicolon `;;` will create a new line, so you can write multiple-line expressions this way.

Commands beginning with a hash character `#`, such as `#quit` or `#help`, are not evaluated by OCaml; they are interpreted as commands by UTop.

You're now ready to hack with UTop! If you hit any issue with the toplevel, don't hesitate to [ask on Discuss](https://discuss.ocaml.org/).

> Note: The double semicolon `;;` is also a valid token in the OCaml syntax outside the toplevel. In OCaml source code, it is a [no-op](https://en.wikipedia.org/wiki/NOP_(code)), i.e., it does not trigger any behaviour, so it is ignored by the compiler. If your intention is to compile or interpret files as scripts, double semicolons can and should be avoided when writing in OCaml. Leaving them does not raise errors, but they are useless. The compiler tolerates them to allow copy-paste from UTop to a file without having to remove them.

## Using Packages in UTop

### Loading Libraries In UTop

If you want to use a library from a package installed in the current opam switch in UTop, enter

```ocaml
# #require "<LIBRARY_NAME>";;
```

into the toplevel to make all definitions from the library available. For, example, try

```ocaml
# Str.quote {|"hello"|};;
Error: Unbound module Str

# #require "str";;

# Str.quote {|"hello"|};;
- : string = "\"hello\""
```

**Tip**: UTop knows about the available libraries and completion works. Outside `utop` you can use `ocamlfind list` to display the complete list of libraries. Note that opam package may bundle several libraries and libraries may bundle several modules.

### Using a Pre-Processor Extension (PPX) in UTop

Pre-Processor Extensions enable code generation through annotations of your code
(for an example, see [section "Using the Preprocessor to Generate Code" in "Your First OCaml Program"](/docs/your-first-program#using-the-preprocessor-to-generate-code).

To activate a PPX in UTop, all you need to do is to load the corresponding library.

Assuming that the [`ppx_deriving`](https://ocaml.org/p/ppx_deriving/latest) package is installed in your opam switch, you run `#require "ppx_deriving.show"`.
