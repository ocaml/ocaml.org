---
title: OCamlformat 0.27.0
tags: [ocamlformat, platform]
github_release_tags: [0.27.0, "0.27.0-20250228", "0.27.0+20250228"]
changelog: |
  ### Highlight
  
  - \* Support OCaml 5.2 syntax (#2519, #2544, #2590, #2596, #2621, #2628, @Julow, @EmileTrotignon, @hhugo)
    This includes local open in types, raw identifiers, and the new
    representation for functions.
    This might change the formatting of some functions due to the formatting code
    being completely rewritten.
  
  - Support OCaml 5.3 syntax (#2609, #2610, #2611, #2622, #2623, #2562, #2624, #2625, #2627, @Julow, @Zeta611)
    This adds support for effect patterns, short functor type arguments and utf8
    identifiers.
    To format code using the new `effect` syntax, add this option to your
    `.ocamlformat`:
    ```
    ocaml-version = 5.3
    ```
  
  - Documentation comments are now formatted by default (#2390, @Julow)
    Use the option `parse-docstrings = false` to restore the previous behavior.
  
  - \* Consistent indentation of polymorphic variant arguments (#2427, @Julow)
    Increases the indentation by one to make the formatting consistent with
    normal variants. For example:
    ```
      ...
      (* before *)
        (`Msg
          (foo bar))
      (* after *)
        (`Msg
           (foo bar))
    ```
  
  - Build on OCaml 5.3 (#2603, @adamchol, @Julow)
  
  ### Added
  
  - Improve the emacs plugin (#2577, #2600, @gridbugs, @thibautbenjamin)
    Allow a custom command to be used to run ocamlformat and add compatibility
    with emacs ocaml tree-sitter modes.
  
  - Added option `let-binding-deindent-fun` (#2521, @henrytill)
    to control the indentation of the `fun` in:
    ```
    let f =
     fun foo ->
      bar
    ```
  
  - Added back the flag `--disable-outside-detected-project` (#2439, @gpetiot)
    It was removed in version 0.22.
  
  - Support newer Odoc syntax (#2631, #2632, #2633, @Julow)
  
  ### Changed
  
  - \* Consistent formatting of comments (#2371, #2550, @Julow)
    This is mostly an internal change but some comments might be formatted differently.
  
  - \* Improve formatting of type constraints with type variables (#2437, @gpetiot)
    For example:
    ```
    let f : type a b c.
        a -> b -> c =
      ...
    ```
  
  - \* Improve formatting of functor arguments (#2505, @Julow)
    This also reduce the indentation of functor arguments with long signatures.
  
  - Improvements to the Janestreet profile (#2445, #2314, #2460, #2593, #2612, @Julow, @tdelvecchio-jsc)
  
  - \* Undo let-bindings and methods normalizations (#2523, #2529, @gpetiot)
    This remove the rewriting of some forms of let-bindings and methods:
    + `let f x = (x : int)` is no longer rewritten into `let f x : int = x`
    + `let f (type a) (type b) ...` is no longer rewritten into `let f (type a b) ...`
    + `let f = fun x -> ...` is no longer rewritten into `let f x = ...`
  
  - \* The `break-colon` option is now taken into account for method type constraints (#2529, @gpetiot)
  
  - \* Force a break around comments following an infix operator (fix non-stabilizing comments) (#2478, @gpetiot)
    This adds a line break:
    ```
      a
      ||
      (* this comment is now on its own line *)
      b
    ```
  
  ### Fixed
  
  - Fix placement of comments in some cases (#2471, #2503, #2506, #2540, #2541, #2592, #2617, @gpetiot, @Julow)
    Some comments were being moved or causing OCamlformat to crash.
    OCamlformat refuses to format if a comment would be missing in its output, to avoid loosing code.
  
  - Fix attributes being dropped or moved (#2247, #2459, #2551, #2564, #2602, @EmileTrotignon, @tdelvecchio-jsc, @Julow)
    OCamlformat refuses to format if the formatted code has a different meaning than the original code, for example, if an attribute is removed.
    We also try to avoid moving attributes even if that doesn't change the original code, for example we no longer format `open[@attr] M` as `open M [@@attr]`.
  
  - Remove trailing space inside a wrapping empty signature (#2443, @Julow)
  - Fix extension-point spacing in structures (#2450, @Julow)
  - \* Consistent break after string constant argument (#2453, @Julow)
  - \* Fix cinaps comment formatting to not change multiline string contents (#2463, @tdelvecchio-jsc)
  - \* Fix the indentation of tuples in attributes and extensions (#2488, @Julow)
  - \* Fix weird indentation and line breaks after comments (#2507, #2589, #2606, @Julow)
  - \* Fix unwanted alignment in if-then-else (#2511, @Julow)
  - Fix missing parentheses around constraint expressions with attributes (#2513, @alanechang)
  - Fix formatting of type vars in GADT constructors (#2518, @Julow)
  - Fix `[@ocamlformat "disable"]` in some cases (#2242, #2525, @EmileTrotignon)
    This caused a bug inside `class type` constructs and when attached to a `let ... in`
  - Display `a##b` instead of `a ## b` and similarly for operators that start with # (#2580, @v-gb)
  - \* Fix arrow type indentation with `break-separators=before` (#2598, @Julow)
  - Fix missing parentheses around a let in class expressions (#2599, @Julow)
  - Fix formatting of paragraphs in lists in documentation (#2607, @Julow)
  - Avoid unwanted space in references and links text in documentation (#2608, @Julow)
  - \* Improve the indentation of attributes in patterns (#2613, @Julow)
  - \* Avoid large indentation in patterns after `let%ext` (#2615, @Julow)
---

After almost a year of work, OCamlformat 0.27.0 is finally available with
support for 5.3 syntax!

This release includes the new function syntax from OCaml 5.2, the `effect`
keyword from OCaml 5.3 and a large number of bug fixes and improvements.

An other notable change, is that comments are now formatted by default.
