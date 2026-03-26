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

## Anatomy of an Error Message

Every OCaml error has the same structure:

```
File "foo.ml", line 5, characters 10-15:
5 |   let x = "hello"
              ^^^^^^^
Error: This expression has type "string" but an expression was expected of type
         "int"
```

The parts:

1. **Location**: `File "foo.ml", line 5, characters 10-15:` — which file, which line, which characters. The caret (`^^^^^^^`) shows the exact span.
2. **Source excerpt**: the relevant line of code, with the problematic span highlighted.
3. **Error tag**: `Error:` (compilation fails) or `Warning N [name]:` (compilation continues, but something is suspicious).
4. **Message body**: what went wrong.
5. **Sub-messages** (sometimes): hints, expected types, or "did you mean ..." suggestions.

**Important**: the location points to the *symptom*, not always the *cause*. If the compiler says line 5 is wrong, the actual mistake might be on line 3 (where a type was set up incorrectly). Keep this in mind.

## Rule 1: Fix the First Error

When the compiler reports multiple errors, **fix only the first one**, then rebuild. Later errors are often cascading consequences — the compiler gets confused after the first error and produces misleading follow-up messages.

This is especially important for automated tools and LLM coding agents: do not try to fix all errors at once. Fix one, rebuild, repeat.

## Type Mismatches

The most common error family. The pattern:

```
Error: This expression has type X but an expression was expected of type Y
```

This means:
- **"has type X"** — what the expression actually is
- **"was expected of type Y"** — what the surrounding code requires

Example:

```ocaml
let greeting : string = 42
```

```
Error: This expression has type "int" but an expression was expected of type
         "string"
```

The compiler points at `42` (which has type `int`) because the context expects `string`.

### Which side is wrong?

The compiler points at the expression it considers wrong. But sometimes the *context* needs changing instead. Consider:

```ocaml
let add x y = x + y
let result = add "hello" "world"
```

The error will point at `"hello"` saying it has type `string` but `int` was expected. The expression `"hello"` isn't wrong per se — you might have intended `add` to work on strings. The question is: should `add` use `^` (string concatenation) instead of `+`? Or should the arguments be integers? The compiler can't know your intent.

**Reading strategy**: when you see a type mismatch, ask yourself which side should change — the expression, or the context that expects a different type.

### Common causes

- Wrong function argument type (passing `string` where `int` is expected)
- Forgetting to unwrap an `option` (passing `Some x` where `x` is expected)
- Using `=` (comparison) instead of `:=` (assignment), or vice versa
- Returning different types in `if`/`else` branches

## Unbound Identifiers

The second most common family:

```
Error: Unbound value foo
```

This means the name `foo` is not in scope. The variants:

### `Unbound value`

The variable or function doesn't exist where it's used. Common causes:
- Typo in the name (the compiler often suggests: "Hint: Did you mean `bar`?")
- Missing `open` for the module that defines it
- The value is defined later in the file (OCaml reads top-to-bottom; use `let rec` for recursive definitions)

### `Unbound module`

```
Error: Unbound module Yojson
```

This is very often a **dune configuration issue**, not a code error. The module exists in a library, but that library isn't listed in `(libraries ...)` in your `dune` file. The fix:

1. Find which opam package provides the module (e.g., `yojson` provides `Yojson`)
2. Add it to `(libraries ...)` in the `dune` file
3. Add it to `(depends ...)` in `dune-project`
4. Install it: `opam install yojson`

Only if the module truly doesn't exist is it a code error.

### `Unbound type constructor`

```
Error: Unbound type constructor foo
```

The type name isn't in scope. Usually needs an `open` or a qualified path (`Module.type_name`).

### `Unbound record field` / `Unbound constructor`

```
Error: Unbound record field x
```

The wrong type is in scope — perhaps you opened a module that shadows a type with the same name. Check which module should be open.

### Trust the suggestions

When the compiler says "Hint: Did you mean `String.uppercase_ascii`?", it's almost always right. Trust it.

## Function Application Errors

### "This is not a function"

```ocaml
let x = 42
let y = x 3
```

```
Error: This expression has type "int"
       This is not a function; it cannot be applied.
```

You're trying to call something that isn't a function. Common causes:
- Missing an operator: `f x y` when you meant `f x + y` (precedence issue)
- Extra argument to a function
- A value that was supposed to be a function but isn't

### "Too many arguments"

You're passing more arguments than the function accepts. Check the function's signature.

### Label issues

```
Warning 6 [labels-omitted]: labels name, greeting were omitted in the
application of this function.
```

You're calling a function with labelled arguments without using the labels. Either add the labels (`~name:"World"`) or reorder arguments to match the definition.

## Pattern Matching

### Non-exhaustive match (Warning 8)

```ocaml
type color = Red | Green | Blue
let name = function
  | Red -> "red"
  | Green -> "green"
```

```
Warning 8 [partial-match]: this pattern-matching is not exhaustive.
Here is an example of a case that is not matched:
Blue
```

The compiler tells you exactly which case is missing. Add it. If you intentionally want a partial match, add a wildcard: `| _ -> failwith "unexpected"` — but think hard before doing this, as it disables the compiler's ability to warn you when new variants are added.

### Unused match case (Warning 11)

A pattern can never be reached — it's shadowed by an earlier, more general pattern. Usually means a wildcard `_` is too early, or a specific pattern is duplicated.

## Record and Constructor Errors

### Missing fields

```ocaml
type point = { x : int; y : int; z : int }
let p = { x = 1; y = 2 }
```

```
Error: Some record fields are undefined: "z"
```

All fields must be provided when constructing a record. Add the missing field.

### Same field names, different types

```
Error: This expression has type { x : int; y : int }
       but an expression was expected of type { x : float; y : float }
```

Two types have fields with the same names but different types. This often happens in the toplevel when you redefine a type — the old bindings still reference the old type. In real code, qualify the type or use a module prefix.

### Not mutable

```
Error: The record field x is not mutable
```

You're trying to assign (`<-`) to a field that wasn't declared `mutable`. Either add `mutable` to the type definition or use a functional update: `{ p with x = 5 }`.

## Module Errors

### Signature mismatch

```
Error: Signature mismatch:
       ...
       The value `foo` is required but not provided
```

A module doesn't satisfy its signature (`.mli` file or functor argument). Read the sub-messages carefully — they tell you exactly which value, type, or module is missing or has the wrong type.

### Structure vs functor confusion

```
Error: This is a functor, it cannot have any components
```

You're treating a functor (a module that takes arguments) as a regular module. You need to apply it first: `module M = F(Arg)`.

## Warnings Worth Understanding

Warnings don't stop compilation but often indicate real problems. Here are the most useful ones:

| Warning | Meaning | Fix |
|---------|---------|-----|
| 8 `[partial-match]` | Non-exhaustive pattern match | Add missing cases |
| 11 `[redundant-case]` | Unreachable match case | Remove it or reorder patterns |
| 16 `[unerasable-optional-argument]` | Optional arg can't be erased | Add a `unit` argument at the end |
| 20 `[unused-function-argument]` | Function argument not used | Prefix with `_` |
| 26 `[unused-module-binding]` | Unused `open` or module binding | Remove it |
| 27 `[unused-var-strict]` | Unused variable | Prefix with `_` or remove |
| 32 `[unused-value-declaration]` | Unused `let` binding | Delete it or prefix with `_` |

**`-warn-error`**: In CI or strict builds, `-warn-error +a` turns all warnings into errors. If your code compiles locally but fails in CI, check for warnings.

## A Method for Any Error

When faced with an unfamiliar error:

1. **Read the location** — which file, which line, which characters
2. **Read the error tag** — `Error:` or `Warning N:`?
3. **If a type mismatch**: identify "has type X" vs "expected Y" — then decide which side should change
4. **If "unbound"**: check whether it's a code issue (typo, missing `open`) or a dune issue (missing library)
5. **Read sub-messages** — the compiler often says "Hint: Did you mean ..." or shows which signature component is wrong
6. **Fix only the first error**, rebuild, and see what remains
