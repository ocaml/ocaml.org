---
id: formatting-text
title: Formatting and Wrapping Text
description: >
  The Format module of Caml Light and OCaml's standard libraries
  provides pretty-printing facilities to get a fancy display for printing
  routines
category: "Tutorials"
---

The `Format` module of Caml Light and OCaml's standard libraries
provides pretty-printing facilities to get a fancy display for printing
routines. This module implements a “pretty-printing engine” that is
intended to break lines in a nice way (let's say “automatically when it
is necessary”).

## Principles

Line breaking is based on three concepts:

* **boxes**: a box is a logical pretty-printing unit, which defines a
 behaviour of the pretty-printing engine to display the material
 inside the box.
* **break hints**: a break hint is a directive to the pretty-printing
 engine that proposes to break the line here, if it is necessary to
 properly print the rest of the material. Otherwise, the
 pretty-printing engine never break lines (except “in case of
 emergency” to avoid very bad output). In short, a break hint tells
 the pretty printer that a line break here may be appropriate.
* **Indentation rules**: When a line break occurs, the pretty-printing
 engines fixes the indentation (or amount of leading spaces) of the
 new line using indentation rules, as follows:
  * A box can state the extra indentation of every new line opened
 in its scope. This extra indentation is named **box breaking
 indentation**.
  * A break hint can also set the additional indentation of the new
 line it may fire. This extra indentation is named **hint
 breaking indentation**.
  * If break hint `bh` fires a new line within box `b`, then the
 indentation of the new line is simply the sum of: the current
 indentation of box `b` `+` the additional box breaking
 indentation, as defined by box `b` `+` the additional hint
 breaking indentation, as defined by break hint `bh`.

## Boxes

There are 4 types of boxes. (The most often used is the “hov” box type,
so skip the rest at first reading).

* **horizontal box** (*h* box, as obtained by the `open_hbox`
 procedure): within this box, break hints do not lead to line breaks.
* **vertical box** (*v* box, as obtained by the `open_vbox`
 procedure): within this box, every break hint lead to a new line.
* **vertical/horizontal box** (*hv* box, as obtained by the
 `open_hvbox` procedure): if it is possible, the entire box is
 written on a single line; otherwise, every break hint within the box
 leads to a new line.
* **vertical or horizontal box** (*hov* box, as obtained by the
 open_box or open_hovbox procedures): within this box, break hints
 are used to cut the line when there is no more room on the line.
 There are two kinds of “hov” boxes, you can find the details
 [below](#refinement-on-hov-boxes). In first approximation, let me consider these
 two kinds of “hov” boxes as equivalent and obtained by calling the
 `open_box` procedure.

Let me give an example. Suppose we can write 10 chars before the right
margin (that indicates no more room). We represent any char as a `-`
sign; characters `[` and `]` indicates the opening and closing of a box
and `b` stands for a break hint given to the pretty-printing engine.

The output "--b--b--" is displayed like this (the b symbol stands for
the value of the break that is explained below):

* within a “h” box:

    ```text
    --b--b--
    ```

* within a “v” box:

    ```text
    --b
    --b
    --
    ```

* within a “hv” box:

    If there is enough room to print the box on the line:

    ```text
    --b--b--
    ```

    But "---b---b---" that cannot fit on the line is written

    ```text
    ---b
    ---b
    ---
    ```

* within a “hov” box:

    If there is enough room to print the box on the line:

    ```text
    --b--b--
    ```

    But if "---b---b---" cannot fit on the line, it is written as

    ```text
    ---b---b
    ---
    ```

    The first break hint does not lead to a new line, since there is
    enough room on the line. The second one leads to a new line since
    there is no more room to print the material following it. If the
    room left on the line were even shorter, the first break hint may
    lead to a new line and "---b---b---" is written as:

    ```text
    ---b
    ---b
    ---
    ```

## Printing Spaces

Break hints are also used to output spaces (if the line is not split
when the break is encountered, otherwise the new line indicates properly
the separation between printing items). You output a break hint using
`print_break sp indent`, and this `sp` integer is used to print “sp”
spaces. Thus `print_break sp ...` may be thought as: print `sp` spaces
or output a new line.

For instance, if b is `break 1 0` in the output "--b--b--", we get

* within a “h” box:

    ```text
    -- -- --
    ```

* within a “v” box:

    ```text
    --
    --
    --
    ```

* within a “hv” box:

    ```text
    -- -- --
    ```

    or, according to the remaining room on the line:

    ```text
    --
    --
    --
    ```

* and similarly for “hov” boxes.

Generally speaking, a printing routine using "format", should not
directly output white spaces: the routine should use break hints
instead. (For instance `print_space ()` that is a convenient
abbreviation for `print_break 1 0` and outputs a single space or break
the line.)

## Indentation of New Lines

The user gets 2 ways to fix the indentation of new lines:

* **when defining the box**: when you open a box, you can fix the
 indentation added to each new line opened within that box.<br />
 For instance: `open_hovbox 1` opens a “hov” box with new lines
 indented 1 more than the initial indentation of the box. With output
 "---[--b--b--b--", we get:

    ```text
    ---[--b--b
         --b--
    ```

    with `open_hovbox 2`, we get

    ```text
    ---[--b--b
          --b--
    ```

    Note: the `[` sign in the display is not visible on the screen, it
    is just there to materialise the aperture of the pretty-printing
    box. Last “screen” stands for:

    ```text
    -----b--b
         --b--
    ```

* **when defining the break that makes the new line**. As said above,
 you output a break hint using `print_break     sp           indent`.
 The `indent` integer is used to fix the additional indentation of
 the new line. Namely, it is added to the default indentation offset
 of the box where the break occurs.<br />
 For instance, if `[` stands for the opening of a “hov” box with 1
 as extra indentation (as obtained by `open_hovbox 1`), and b is
 `print_break       1       2`, then from output "---[--b--b--b--",
 we get:

    ```text
    ---[-- --
          --
          --
    ```

## Refinement on “hov” Boxes

### Packing and Structural “hov” Boxes

The “hov” box type is refined into two categories.

* **the vertical or horizontal *packing* box** (as obtained by the
 open_hovbox procedure): break hints are used to cut the line when
 there is no more room on the line; no new line occurs if there is
 enough room on the line.
* **vertical or horizontal *structural* box** (as obtained by the
 open_box procedure): similar to the “hov” packing box, the break
 hints are used to cut the line when there is no more room on the
 line; in addition, break hints that can show the box structure lead
 to new lines even if there is enough room on the current line.

### Differences Between a Packing and a Structural “hov” Box

The difference between a packing and a structural “hov” box is shown by
a routine that closes boxes and parentheses at the end of printing: with
packing boxes, the closure of boxes and parentheses do not lead to new
lines if there is enough room on the line, whereas with structural boxes
each break hint will lead to a new line. For instance, when printing
`[(---[(----[(---b)]b)]b)]`, where `b` is a break hint without extra
indentation (`print_cut ()`). If `[` means opening of a packing “hov”
box (open_hovbox), `[(---[(----[(---b)]b)]b)]` is printed as follows:

```text
(---
 (----
  (---)))
```

If we replace the packing boxes by structural boxes (open_box), each
break hint that precedes a closing parenthesis can show the boxes
structure, if it leads to a new line; hence `[(---[(----[(---b)]b)]b)]`
is printed like this:

```text
(---
 (----
  (---
  )
 )
)
```

## Practical Advice

When writing a pretty-printing routine, follow these simple rules:

1. Boxes must be opened and closed consistently (`open_*` and
 `close_box` must be nested like parentheses).
1. Never hesitate to open a box.
1. Output many break hints, otherwise the pretty-printer is in a bad
 situation where it tries to do its best, which is always “worse than
 your bad”.
1. Do not try to force spacing using explicit spaces in the character
 strings. For each space you want in the output emit a break hint
 (`print_space ()`), unless you explicitly don't want the line to be
 broken here. For instance, imagine you want to pretty print an OCaml
 definition, more precisely a `let rec ident =     expression` value
 definition. You will probably treat the first three spaces as
 “unbreakable spaces” and write them directly in the string constants
 for keywords, and print `"let rec "` before the identifier, and
 similarly write `=` to get an unbreakable space after the
 identifier; in contrast, the space after the `=` sign is certainly a
 break hint, since breaking the line after `=` is a usual (and
 elegant) way to indent the expression part of a definition. In
 short, it is often necessary to print unbreakable spaces; however,
 most of the time a space should be considered a break hint.
1. Do not try to force new lines, let the pretty-printer do it for you:
 that's its only job. In particular, do not use `force_newline`: this
 procedure effectively leads to a newline, but it also as the
 unfortunate side effect to partially reinitialise the
 pretty-printing engine, so that the rest of the printing material is
 noticeably messed up.
1. Never put newline characters directly in the strings to be printed:
 pretty printing engine will consider this newline character as any
 other character written on the current line and this will completely
 mess up the output. Instead of new line characters use line break
 hints: if those break hints must always result in new lines, it just
 means that the surrounding box must be a vertical box!
1. End your main program by a `print_newline ()` call, that flushes the
 pretty-printer tables (hence the output). (Note that the top-level
 loop of the interactive system does it as well, just before a new
 input.)

## Printing to `stdout`: Using `printf`

The `format` module provides a general printing facility “à la”
`printf`. In addition to the usual conversion facility provided by
`printf`, you can write pretty-printing indications directly inside the
format string (opening and closing boxes, indicating breaking hints,
etc).

Pretty-printing annotations are introduced by the `@` symbol, directly
into the string format. Almost any function of the `format` module can
be called from within a `printf` format string. For instance

* “`@[`” open a box (`open_box     0`). You may precise the type as an
 extra argument. For instance `@[<hov n>` is equivalent to
 `open_hovbox       n`.
* “`@]`” close a box (`close_box       ()`).
* “`@` ” output a breakable space (`print_space ()`).
* “`@,`” output a break hint (`print_cut       ()`).
* “`@;<n m>`” emit a “full” break hint (`print_break n m`).
* “`@.`” end the pretty-printing, closing all the boxes still opened
 (`print_newline ()`).

For instance

```ocaml
# Format.printf "@[<1>%s@ =@ %d@ %s@]@." "Price" 100 "Euros";;
Price = 100 Euros
- : unit = ()
```

## A Concrete Example

Let me give a full example: the shortest non trivial example you could
imagine, that is the λ-calculus. :)

Thus the problem is to pretty-print the values of a concrete data type
that models a language of expressions that defines functions and their
applications to arguments.

First, I give the abstract syntax of lambda-terms:

```ocaml
# type lambda =
  | Lambda of string * lambda
  | Var of string
  | Apply of lambda * lambda;;
type lambda =
    Lambda of string * lambda
  | Var of string
  | Apply of lambda * lambda
```

I use the format library to print the lambda-terms:

```ocaml
open Format
let ident = print_string
let kwd = print_string

let rec print_exp0 = function
  | Var s ->  ident s
  | lam -> open_hovbox 1; kwd "("; print_lambda lam; kwd ")"; close_box ()
and print_app = function
  | e -> open_hovbox 2; print_other_applications e; close_box ()
and print_other_applications f =
  match f with
  | Apply (f, arg) -> print_app f; print_space (); print_exp0 arg
  | f -> print_exp0 f
and print_lambda = function
  | Lambda (s, lam) ->
      open_hovbox 1;
      kwd "\\"; ident s; kwd "."; print_space(); print_lambda lam;
      close_box()
  | e -> print_app e
```

In Caml Light, replace the first line by:

<!-- $MDX skip -->
```ocaml
#open "format";;
```

### Most General Pretty-Printing: Using `fprintf`

We use the `fprintf` function to write the most versatile version of the
pretty-printing functions for lambda-terms. Now, the functions get an
extra argument, namely a pretty-printing formatter (the `ppf` argument)
where printing will occur. This way the printing routines are more
general, since they can print on any formatter defined in the program
(either printing to a file, or to `stdout`, to `stderr`, or even to a
string). Furthermore, the pretty-printing functions are now
compositional, since they may be used in conjunction with the special
`%a` conversion, that prints a `fprintf` argument with a user's supplied
function (these user's supplied functions also have a formatter as first
argument).

Using `fprintf`, the lambda-terms printing routines can be written as
follows:

```ocaml
open Format

let ident ppf s = fprintf ppf "%s" s
let kwd ppf s = fprintf ppf "%s" s

let rec pr_exp0 ppf = function
  | Var s -> fprintf ppf "%a" ident s
  | lam -> fprintf ppf "@[<1>(%a)@]" pr_lambda lam
and pr_app ppf e =
  fprintf ppf "@[<2>%a@]" pr_other_applications e
and pr_other_applications ppf f =
  match f with
  | Apply (f, arg) -> fprintf ppf "%a@ %a" pr_app f pr_exp0 arg
  | f -> pr_exp0 ppf f
and pr_lambda ppf = function
  | Lambda (s, lam) ->
     fprintf ppf "@[<1>%a%a%a@ %a@]"
             kwd "\\" ident s kwd "." pr_lambda lam
  | e -> pr_app ppf e
```

Given those general printing routines, procedures to print to `stdout`
or `stderr` is just a matter of partial application:

```ocaml
let print_lambda = pr_lambda std_formatter
let eprint_lambda = pr_lambda err_formatter
```
