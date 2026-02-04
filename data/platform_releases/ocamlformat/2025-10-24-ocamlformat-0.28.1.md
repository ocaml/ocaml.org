---
title: OCamlFormat 0.28.1
tags:
- ocamlformat
- platform
authors: []
contributors:
changelog: |
  CHANGES:

  *   \* Support for OCaml 5.4 ([#2717](https://github.com/ocaml-ppx/ocamlformat/pull/2717), [#2720](https://github.com/ocaml-ppx/ocamlformat/pull/2720), [@Julow](https://github.com/Julow), [@Octachron](https://github.com/Octachron))  
      OCamlformat now supports OCaml 5.4 syntax.  
      Module packing of the form `((module M) : (module S))` are no longer  
      rewritten to `(module M : S)` because these are now two different syntaxes.
      
  *   \* Reduce indentation after `|> map (fun` ([#2694](https://github.com/ocaml-ppx/ocamlformat/pull/2694), [@EmileTrotignon](https://github.com/EmileTrotignon))  
      Notably, the indentation no longer depends on the length of the infix  
      operator, for example:
      
      ```ocaml
      (* before *)
      v
      |>>>>>> map (fun x ->
                  x )
      (* after *)
      v
      |>>>>>> map (fun x ->
          x )
      ```
      
      `@@ match` can now also be on one line.
      
  *   Added option `module-indent` option ([#2711](https://github.com/ocaml-ppx/ocamlformat/pull/2711), [@HPRIOR](https://github.com/HPRIOR)) to control the indentation  
      of items within modules. This affects modules and signatures. For example,  
      module-indent=4:
      
      ```ocaml
      module type M = sig
          type t
      
          val f : (string * int) list -> int
      end
      ```
      
  *   `exp-grouping=preserve` is now the default in `default` and `ocamlformat`  
      profiles. This means that its now possible to use `begin ... end` without  
      tweaking ocamlformat. ([#2716](https://github.com/ocaml-ppx/ocamlformat/pull/2716), [@EmileTrotignon](https://github.com/EmileTrotignon))
      
  *   Starting in this release, ocamlformat can use cmdliner >= 2.0.0. When that is  
      the case, the tool no longer accepts unambiguous option names prefixes. For  
      example, `--max-iter` is not accepted anymore, you have to pass the full  
      option `--max-iters`. This does not apply to the keys in the `.ocamlformat`  
      configuration files, which have always required the full name.  
      See [dbuenzli/cmdliner#200](https://github.com/dbuenzli/cmdliner/issues/200).  
      ([#2680](https://github.com/ocaml-ppx/ocamlformat/pull/2680), [@emillon](https://github.com/emillon))
      
  *   \* The formatting of infix extensions is now consistent with regular  
      formatting by construction. This reduces indentation in `f @@ match%e`  
      expressions to the level of indentation in `f @@ match`. Other unknown  
      inconsistencies might also be fixed. ([#2676](https://github.com/ocaml-ppx/ocamlformat/pull/2676), [@EmileTrotignon](https://github.com/EmileTrotignon))
      
  *   \* The spacing of infix attributes is now consistent across keywords. Every  
      keyword but `begin` `function`, and `fun` had attributes stuck to the keyword:  
      `match[@a]`, but `fun [@a]`. Now its also `fun[@a]`. ([#2676](https://github.com/ocaml-ppx/ocamlformat/pull/2676), [@EmileTrotignon](https://github.com/EmileTrotignon))
      
  *   \* The formatting of`let a = b in fun ...` is now consistent with other  
      contexts like `a ; fun ...`. A check for the syntax `let a = fun ... in ...`  
      was made more precise. ([#2705](https://github.com/ocaml-ppx/ocamlformat/pull/2705), [@EmileTrotignon](https://github.com/EmileTrotignon))
      
  *   \* `|> begin`, `~arg:begin`, `begin if`, `lazy begin`, `begin match`,  
      `begin fun` and `map li begin fun` can now be printed on the same line, with  
      one less indentation level for the body of the inner expression.  
      ([#2664](https://github.com/ocaml-ppx/ocamlformat/pull/2664), [#2666](https://github.com/ocaml-ppx/ocamlformat/pull/2666), [#2671](https://github.com/ocaml-ppx/ocamlformat/pull/2671), [#2672](https://github.com/ocaml-ppx/ocamlformat/pull/2672), [#2681](https://github.com/ocaml-ppx/ocamlformat/pull/2681), [#2685](https://github.com/ocaml-ppx/ocamlformat/pull/2685), [#2693](https://github.com/ocaml-ppx/ocamlformat/pull/2693), [@EmileTrotignon](https://github.com/EmileTrotignon))  
      For example :
      
      ```ocaml
      (* before *)
      begin
        fun x ->
          some code
      end
      (* after *)
      begin fun x ->
        some code
      end
      ```
      
  *   \* `break-struct=natural` now also applies to `sig ... end`. ([#2682](https://github.com/ocaml-ppx/ocamlformat/pull/2682), [@EmileTrotignon](https://github.com/EmileTrotignon))
      
  *   Fixed `wrap-comments=true` not working with the janestreet profile ([#2645](https://github.com/ocaml-ppx/ocamlformat/pull/2645), [@Julow](https://github.com/Julow))  
      Asterisk-prefixed comments are also now formatted the same way as with the  
      default profile.
      
  *   Fixed `nested-match=align` not working with `match%ext` ([#2648](https://github.com/ocaml-ppx/ocamlformat/pull/2648), [@EmileTrotignon](https://github.com/EmileTrotignon))
      
  *   Fixed the AST generated for bindings of the form `let pattern : type = function ...`  
      ([#2651](https://github.com/ocaml-ppx/ocamlformat/pull/2651), [@v-gb](https://github.com/v-gb))
      
  *   Print valid syntax for the corner case (1).a ([#2653](https://github.com/ocaml-ppx/ocamlformat/pull/2653), [@v-gb](https://github.com/v-gb))
      
  *   `Ast_mapper.default_mapper` now iterates on the location of `in` in `let+ .. in ..`  
      ([#2658](https://github.com/ocaml-ppx/ocamlformat/pull/2658), [@v-gb](https://github.com/v-gb))
      
  *   Fix missing parentheses in `let+ (Cstr _) : _ = _` ([#2661](https://github.com/ocaml-ppx/ocamlformat/pull/2661), [@Julow](https://github.com/Julow))  
      This caused a crash as the generated code wasn't valid syntax.
      
  *   Fix bad indentation of `let%ext { ...` ([#2663](https://github.com/ocaml-ppx/ocamlformat/pull/2663), [@EmileTrotignon](https://github.com/EmileTrotignon))  
      with `dock-collection-brackets` enabled.
      
  *   ocamlformat is now more robust when used as a library to print modified ASTs  
      ([#2659](https://github.com/ocaml-ppx/ocamlformat/pull/2659), [@v-gb](https://github.com/v-gb))
      
  *   Fix crash due to edge case with asterisk-prefixed comments ([#2674](https://github.com/ocaml-ppx/ocamlformat/pull/2674), [@Julow](https://github.com/Julow))
      
  *   Fix crash when formatting `mld` files that cannot be lexed as ocaml (e.g.  
      containing LaTeX or C code) ([#2684](https://github.com/ocaml-ppx/ocamlformat/pull/2684), [@emillon](https://github.com/emillon))
      
  *   \* Fix double parens around module constraint in functor application :  
      `module M = F ((A : T))` becomes `module M = F (A : T)`. ([#2678](https://github.com/ocaml-ppx/ocamlformat/pull/2678), [@EmileTrotignon](https://github.com/EmileTrotignon))
      
  *   Fix misplaced `;;` due to interaction with floating doc comments.  
      ([#2691](https://github.com/ocaml-ppx/ocamlformat/pull/2691), [@EmileTrotignon](https://github.com/EmileTrotignon))
      
  *   The formatting of attributes of expression is now aware of the attributes  
      infix or postix positions: `((fun [@a] x -> y) [@b])` is formatted without  
      moving attributes. ([#2676](https://github.com/ocaml-ppx/ocamlformat/pull/2676), [@EmileTrotignon](https://github.com/EmileTrotignon))
      
  *   `begin%e ... end` and `begin [@a] ... end` nodes are always preserved.  
      ([#2676](https://github.com/ocaml-ppx/ocamlformat/pull/2676), [@EmileTrotignon](https://github.com/EmileTrotignon))
      
  *   `begin end` syntax for `()` is now preserved. ([#2676](https://github.com/ocaml-ppx/ocamlformat/pull/2676), [@EmileTrotignon](https://github.com/EmileTrotignon))
      
  *   Fix a crash on `type 'a t = A : 'a. {a: 'a} -> 'a t`. ([#2710](https://github.com/ocaml-ppx/ocamlformat/pull/2710), [@EmileTrotignon](https://github.com/EmileTrotignon))
      
  *   Fix a crash where `type%e nonrec t = t` was formatted as `type nonrec%e t = t`,  
      which is invalid syntax. ([#2712](https://github.com/ocaml-ppx/ocamlformat/pull/2712), [@EmileTrotignon](https://github.com/EmileTrotignon))
      
  *   Fix commandline parsing being quadratic in the number of arguments  
      ([#2724](https://github.com/ocaml-ppx/ocamlformat/pull/2724), [@let-def](https://github.com/let-def))
      
  *   \* Fix `;;` being added after a documentation comment ([#2683](https://github.com/ocaml-ppx/ocamlformat/pull/2683), [@EmileTrotignon](https://github.com/EmileTrotignon))  
      This results in more `;;` being inserted, for example:
      
      ```ocaml
      (* before *)
      print_endline "foo"
      let a = 3
      
      (* after *)
      print_endline "foo" ;;
      let a = 3
      ```
versions:
experimental: false
ignore: false
released_on_github_by: Julow
github_release_tags:
- 0.28.1
---

We're happy to announce the release of OCamlFormat `0.28.1`!

### Highlight

- \* Support for OCaml 5.4
  (#2717, #2720, #2732, #2733, #2735, @Julow, @Octachron, @cod1r, @EmileTrotignon)
  OCamlformat now supports OCaml 5.4 syntax.
  Module packing of the form `((module M) : (module S))` are no longer
  rewritten to `(module M : S)` because these are now two different syntaxes.
- \* Reduce indentation after `|> map (fun` (#2694, @EmileTrotignon)
  Notably, the indentation no longer depends on the length of the infix
  operator, for example:
  ```ocaml
  (* before *)
  v
  |>>>>>> map (fun x ->
              x )
  (* after *)
  v
  |>>>>>> map (fun x ->
      x )
  ```
  `@@ match` can now also be on one line.
