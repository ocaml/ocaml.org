---
id: "reading-errors"
title: "Reading OCaml Errors"
short_title: "Reading Errors"
description: |
  A systematic method for reading and understanding OCaml compiler errors and warnings.
category: "Resources"
prerequisite_tutorials:
  - "basic-data-types"
  - "modules"
recommended_next_tutorials:
  - "common-errors"
  - "debugging"
---

## Introduction

OCaml's compiler produces precise, structured error messages. Once you learn to read them systematically, they tell you exactly what's wrong — and often suggest the fix. This tutorial teaches a method for reading any OCaml error, then walks through the most common error families.

For a catalogue of specific errors and their fixes, see [Common Error Messages](/docs/common-errors). This tutorial focuses on *how to read* errors, not *what each error means*.

All the transcripts below were produced with OCaml 5.5. The exact wording evolves between compiler versions — for instance, OCaml 5.3 replaced some "This expression has type" messages with the more precise "The constant 42 has type", and OCaml 5.2 and 5.3 wrap code fragments in double quotes in plain (non-terminal) output — but the structure of the messages is stable.

## Anatomy of an Error Message

Every OCaml error has the same structure. Given this program:

```ocaml
let greet name =
  "Hello, " ^ name

let () =
  print_int (greet "Ana")
```

the compiler reports:

```text
File "main.ml", line 5, characters 12-25:
5 |   print_int (greet "Ana")
                ^^^^^^^^^^^^^
Error: This expression has type string but an expression was expected of type
         int
```

The parts:

1. **Location**: `File "main.ml", line 5, characters 12-25:` — which file, which line, which characters. The carets (`^^^^`) show the exact span.
2. **Source excerpt**: the relevant line of code, with the problematic span highlighted.
3. **Error tag**: `Error:` (compilation fails) or `Warning N [name]:` (compilation continues, but something is suspicious).
4. **Message body**: what went wrong.
5. **Sub-messages** (sometimes): hints, extra locations, or "Did you mean ..." suggestions.

**Important**: the location points to the place where the compiler found a contradiction, which is not always where your mistake is. If the compiler flags line 5, the actual mistake might be on line 3, where a type was set up incorrectly. Keep this in mind throughout.

## Rule 1: Fix the First Error

The compiler stops at the first error it finds in a file: one compilation, one error report. This file contains three type errors, but only the first is reported:

```ocaml
let a : int = "one"
let b : int = "two"
let c : bool = 42
```

```text
File "main.ml", line 1, characters 14-19:
1 | let a : int = "one"
                  ^^^^^
Error: This constant has type string but an expression was expected of type
         int
```

When a build prints several errors at once, they come from the build system, not the compiler: Dune compiles many files and collects one error from each file that fails. Fixing an error can therefore reveal new ones: the rest of the fixed file gets type-checked, and files that depend on it can now be compiled.

The practical consequence is to **fix the first error, then rebuild**, and repeat until the build is clean. This is especially important for automated tools and LLM coding agents: do not try to fix all reported errors at once.

## Type Mismatches

The most common error family. The pattern:

```text
Error: This expression has type X but an expression was expected of type Y
```

This means:

- **"has type X"** — what the expression actually is
- **"was expected of type Y"** — what the surrounding code requires

The first words vary with what the compiler is pointing at — `This expression`, `This constant`, `The value greeting`, `The function add1` — but the shape is always the same. Example:

```ocaml
let greeting : string = 42
```

```text
File "main.ml", line 1, characters 24-26:
1 | let greeting : string = 42
                            ^^
Error: The constant 42 has type int but an expression was expected of type
         string
```

The compiler points at `42` (which has type `int`) because the context expects `string`.

### Which Side Is Wrong?

The compiler points to the expression where it finds a contradiction. Type-checking proceeds through your code accumulating constraints, and the error location is where the constraints became unsatisfiable — not a judgement about which part of the code is mistaken. Consider:

```ocaml
let shout s = String.uppercase_ascii s
let result = shout 42
```

```text
File "main.ml", line 2, characters 19-21:
2 | let result = shout 42
                       ^^
Error: The constant 42 has type int but an expression was expected of type
         string
```

The error points at `42` because `shout`'s parameter was already inferred to be a `string`. But the fix depends on your intent: perhaps the argument should be converted (`shout (string_of_int 42)`), or perhaps `shout` itself should work on something other than strings. The compiler can't know which.

**Reading strategy**: when you see a type mismatch, ask yourself which side should change — the expression the compiler points at, or the context that constrains its type.

### Reading a Multi-Step Error Trace

When the mismatched types are structured (lists, tuples, functions), the message first compares the whole types, then narrows down to the precise point of disagreement:

```ocaml
let names = ["Ana"; "Luis"]
let ids : int list = names
```

```text
File "main.ml", line 2, characters 21-26:
2 | let ids : int list = names
                         ^^^^^
Error: The value names has type string list
       but an expression was expected of type int list
       Type string is not compatible with type int
```

The first two lines compare the whole types (`string list` vs `int list`). Each following `Type X is not compatible with type Y` line zooms one step into the structure, down to the actual conflict. **Read the last line first**: it names the real disagreement, and the lines above tell you where inside the larger type it sits.

This matters when the outer types are big and the conflict is small:

```ocaml
let apply_twice (f : int -> int) x = f (f x)
let () = print_int (apply_twice string_of_int 3)
```

```text
File "main.ml", line 2, characters 32-45:
2 | let () = print_int (apply_twice string_of_int 3)
                                    ^^^^^^^^^^^^^
Error: The value string_of_int has type int -> string
       but an expression was expected of type int -> int
       Type string is not compatible with type int
```

The last line tells you the conflict is between `string` and `int`, and the lines above show where: in the *return* type of the function argument. The arguments' types agree; the results' types don't.

### Common Causes

- Wrong function argument type (passing `string` where `int` is expected)
- Forgetting to unwrap an `option` (passing `Some x` where `x` is expected)
- Returning different types in `if`/`else` branches
- Mixing `int` and `float` arithmetic (OCaml never converts implicitly; use `+.` and `float_of_int`)

## Unbound Identifiers

The second most common family:

```text
Error: Unbound value foo
```

This means the name `foo` is not in scope. The variants:

### `Unbound value`

The variable or function doesn't exist where it's used. Common causes:

- Typo in the name — the compiler usually adds a hint:

```text
Error: Unbound value String.upercase_ascii
Hint:   Did you mean String.uppercase_ascii?
```

- Missing `open` for the module that defines it, or missing qualification (`List.map`, not `map`)
- The value is defined later in the file (OCaml reads top-to-bottom; use `let rec` for recursive definitions)

### `Unbound module`

```text
Error: Unbound module Yojson
```

This is very often a **Dune configuration issue**, not a code error. The module exists in a library, but that library isn't listed in `(libraries ...)` in your `dune` file. The fix:

1. Find which opam package provides the module (e.g., `yojson` provides `Yojson`)
2. Add it to `(libraries ...)` in the `dune` file
3. Add it to `(depends ...)` in `dune-project`
4. Install it: `opam install yojson`

Only if the module truly doesn't exist is it a code error.

### `Unbound type constructor`

```text
Error: Unbound type constructor foo
```

The type name isn't in scope. Usually needs an `open` or a qualified path (`Module.type_name`).

### `Unbound record field` / `Unbound constructor`

```text
Error: Unbound record field x
```

No record type with a field of that name is in scope. Either the type's module isn't open, or you opened a module that shadows the type you meant. Check which module defines the record and qualify the field (`Point.x`) or open that module.

### The Spellchecking Hint

The "Did you mean" hint comes from a spellchecker: the compiler compares the unknown name against the names actually in scope and suggests the closest matches. It's a fuzzy match on spelling, not an analysis of what you meant. Still, if the error looks like a typo, it is generally a good idea to trust the hint. When the suggestion looks unrelated to what you wrote, the cause is usually not spelling: the value may live in a module you haven't opened, or in a library that isn't linked (see above).

## Function Application Errors

### "This Is Not a Function"

```ocaml
let x = 42
let y = x 3
```

```text
File "main.ml", line 2, characters 8-9:
2 | let y = x 3
            ^
Error: This expression has type int
       This is not a function; it cannot be applied.
```

You're trying to call something that isn't a function. Common causes:

- Missing an operator: `f x y` when you meant `f x + y` (precedence issue)
- A missing `;` between two expressions, making the second look like an argument to the first
- A value that was supposed to be a function but isn't

### "Applied to Too Many Arguments"

```ocaml
let add1 x = x + 1
let () = print_int (add1 1 2)
```

```text
File "main.ml", line 2, characters 20-28:
2 | let () = print_int (add1 1 2)
                        ^^^^^^^^
Error: The function add1 has type int -> int
       It is applied to too many arguments
File "main.ml", line 2, characters 27-28:
2 | let () = print_int (add1 1 2)
                               ^
  This extra argument is not expected.
```

The message shows the function's type and points at the first argument it cannot accept. As with "this is not a function", a frequent cause is a missing pair of parentheses: `f g x` applies `f` to two arguments, while `f (g x)` may be what you meant.

### Label Issues

```text
Warning 6 [labels-omitted]: labels name, greeting were omitted in the
  application of this function.
```

You're calling a function that has labelled arguments without writing the labels. The call still compiles — the arguments are matched positionally — but it is fragile and easy to get wrong. Write the labels explicitly (`~name:"World"`).

## Pattern Matching

### Non-Exhaustive Match (Warning 8)

```ocaml
type color = Red | Green | Blue
let name = function
  | Red -> "red"
  | Green -> "green"
```

```text
File "main.ml", lines 2-4, characters 11-20:
2 | ...........function
3 |   | Red -> "red"
4 |   | Green -> "green"
Warning 8 [partial-match]: this pattern-matching is not exhaustive.
  Here is an example of a case that is not matched: Blue
```

The compiler tells you exactly which case is missing. Add it. If you intentionally want a partial match, add a wildcard: `| _ -> failwith "unexpected"` — but think hard before doing this, as it disables the compiler's ability to warn you when new variants are added.

### Unused Match Case (Warning 11)

```text
Warning 11 [redundant-case]: this match case is unused.
```

A pattern can never be reached — it's shadowed by an earlier, more general pattern. Usually this means a wildcard `_` comes too early in the match, or a specific pattern is duplicated.

## Record and Constructor Errors

### Missing Fields

```ocaml
type point = { x : int; y : int; z : int }
let p = { x = 1; y = 2 }
```

```text
File "main.ml", line 2, characters 8-24:
2 | let p = { x = 1; y = 2 }
            ^^^^^^^^^^^^^^^^
Error: Some record fields are undefined: z
```

All fields must be provided when constructing a record. Add the missing field, or, when building a variant of an existing value, use functional update: `{ q with z = 0 }`.

### Same Field Names, Different Types

When two record types share field names, a bare record literal is resolved against the expected type when the compiler knows it, and otherwise against the most recently defined matching type. That resolution can pick a different type than you intended:

```ocaml
type vec2 = { x : float; y : float }
type point = { x : int; y : int }

let magnitude (v : vec2) = sqrt ((v.x *. v.x) +. (v.y *. v.y))
let p = { x = 1; y = 2 }
let len = magnitude p
```

```text
File "main.ml", line 6, characters 20-21:
6 | let len = magnitude p
                        ^
Error: The value p has type point but an expression was expected of type vec2
```

Here `{ x = 1; y = 2 }` silently resolved to `point`, the most recent type with those fields. Annotate the binding (`let p : vec2 = ...`) or qualify a field to say which record type you mean.

### Not Mutable

```text
Error: The record field x is not mutable
```

You're trying to assign (`<-`) to a field that wasn't declared `mutable`. Either add `mutable` to the field in the type definition or use a functional update that builds a new record: `{ p with x = 5 }`.

## Module Errors

### Signature Mismatch

```text
File "main.ml", line 1:
Error: The implementation main.ml does not match the interface main.mli:
       The value foo is required but not provided
       File "main.mli", line 1, characters 0-13: Expected declaration
```

A module doesn't satisfy its signature (`.mli` file or functor argument). Read the sub-messages carefully — they name exactly which value, type, or module is missing or has the wrong type, and point at the declaration in the interface that isn't satisfied.

### Using a Functor Like a Module

```ocaml
let empty = Map.Make.empty
```

```text
File "main.ml", line 1, characters 12-20:
1 | let empty = Map.Make.empty
                ^^^^^^^^
Error: The module Map.Make is a functor, it cannot have any components
```

You're accessing a component of a functor (a module that takes arguments) as if it were a regular module. Apply it first: `module StringMap = Map.Make (String)`, then use `StringMap.empty`.

## Warnings Worth Understanding

Warnings don't stop compilation but often indicate real problems. Note that the set of enabled warnings depends on how you compile: bare `ocamlc` leaves several of them off, while Dune's default development profile enables a stricter set and makes most of them fatal, reporting them as `Error (warning 26 [unused-var])` — so the same code can compile silently with bare `ocamlc` and fail to build under Dune. The most useful ones:

| Warning | Name | Meaning | Typical fix |
|---------|------|---------|-------------|
| 6 | `labels-omitted` | Labels omitted when calling a labelled function | Write the labels (`~name:...`) |
| 8 | `partial-match` | Non-exhaustive pattern match | Add the missing cases |
| 11 | `redundant-case` | A match case can never be reached | Remove it, or reorder the patterns |
| 16 | `unerasable-optional-argument` | Optional argument can never be omitted | Add a final non-optional argument (often `unit`) |
| 20 | `ignored-extra-argument` | An argument the function will ignore | Remove the extra argument |
| 26 | `unused-var` | Unused `let`-bound variable | Remove it, or prefix its name with `_` |
| 27 | `unused-var-strict` | Unused function argument or pattern variable | Prefix its name with `_` |
| 32 | `unused-value-declaration` | Top-level value never used nor exported | Remove it, or add it to the `.mli` |
| 33 | `unused-open` | `open` that is never used | Remove the `open` |

### Silencing a Warning

The fixes in the table are the preferred response: they remove the warning's cause. When you have judged a warning acceptable instead — say, a binding kept deliberately even though it is unused — silence it explicitly, and as narrowly as possible, so the warning keeps protecting the rest of the code.

Attributes scope the silencing to a piece of code. On a single binding, use `[@warning ...]` with the warning number prefixed by `-`:

```ocaml
let () =
  let[@warning "-26"] retries = 3 in
  print_endline "connecting"
```

On a top-level definition, attach `[@@warning "-27"]` after the definition; to silence a warning for the whole rest of a file, use a floating attribute on a line of its own, which also accepts several numbers at once:

```ocaml
[@@@warning "-26-27"]
```

Warnings can also be disabled at build level: pass `-w -26` to the compiler, or set the flags for a whole library or executable in its `dune` stanza:

```dune
(library
 (name mylib)
 (flags (:standard -w -26-27)))
```

The specification also accepts mnemonic names (`-w -unused-var`), which are more readable in build files. Prefer the attribute forms over build-level flags: a `dune`-wide disable hides every future occurrence of the warning, including the ones that would have caught real bugs.

**`-warn-error`**: in CI or strict builds, `-warn-error +a` turns all warnings into errors. If your code compiles locally but fails in CI, check for warnings.

The complete list of warnings, their mnemonic names, and the `-w` option syntax are in the [warning reference section of the OCaml manual](/manual/comp.html#s:comp-warnings).

## A Method for Any Error

When faced with an unfamiliar error:

1. **Read the location** — which file, which line, which characters
2. **Read the tag** — `Error:` or `Warning N [name]:`?
3. **If a type mismatch**: identify "has type X" vs "expected of type Y" — and if there is a trace, read its last `Type ... is not compatible with type ...` line first, then decide which side should change
4. **If "unbound"**: decide whether it's a typo (trust the spellchecking hint), a missing `open`, or a missing library in the `dune` file
5. **Read the sub-messages** — hints and secondary locations often contain the answer
6. **Fix only the first error**, rebuild, and see what remains
