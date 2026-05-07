---
title: OCamlFormat 0.29.0
tags:
- ocamlformat
- platform
contributors:
changelog: |
  ### Added

  - Added option `letop-punning` (#2746, @WardBrian) to control whether
    punning is used in extended binding operators.
    For example, the code `let+ x = x in ...` can be formatted as
    `let+ x in ...` when `letop-punning=always`. With `letop-punning=never`, it
    becomes `let+ x = x in ...`. The default is `preserve`, which will
    only use punning when it exists in the source.
    This also applies to `let%ext` bindings (#2747, @WardBrian).

  - Support the unnamed functor parameters syntax in module types
    (#2755, #2759, @Julow)
    ```ocaml
    module type F = ARG -> S
    ```
    The following lines are now formatted as they are in the source file:
    ```ocaml
    module M : (_ : S) -> (_ : S) -> S = N
    module M : S -> S -> S = N
    (* The preceding two lines are no longer turned into this: *)
    module M : (_ : S) (_ : S) -> S = N
    ```

  ### Fixed

  - Fix dropped comment in `(function _ -> x (* cmt *))` (#2739, @Julow)

  - \* `cases-matching-exp-indent=compact` does not impact `begin end` nodes that
    don't have a match inside. (#2742, @EmileTrotignon)
    ```ocaml
    (* before *)
    begin match () with
    | () -> begin
      f x
    end
    end
    (* after *)
    begin match () with
    | () -> begin
        f x
      end
    end
    ```

  - `Ast_mapper` now iterates on *all* locations inside of Longident.t,
    instead of only some.
    (#2737, @v-gb)

  - Remove line break in `M with module N = N (* cmt *)` (#2779, @Julow)

  ### Internal

  - Added information on writing tests to `CONTRIBUTING.md` (#2838, @WardBrian)

  ### Changed

  - indentation of the `end` keyword in a match-case is now always at least 2. (#2742, @EmileTrotignon)
    ```ocaml
    (* before *)
    begin match () with
    | () -> begin
      match () with
      | () -> ()
    end
    end
    (* after *)
    begin match () with
    | () -> begin
      match () with
      | () -> ()

  - \* use shortcut `begin end` in `match` cases and `if then else` body. (#2744, @EmileTrotignon)
    ```ocaml
    (* before *)
    match () with
    | () -> begin
        match () with
        | () ->
      end
    end
    (* after *)
    match () with
    | () ->
      begin match () with
        | () ->
      end
    end
    ```

  - \* Set the `ocaml-version` to `5.4` by default (#2750, @EmileTrotignon)
    The main difference is that the `effect` keyword is recognized without having
    to add `ocaml-version=5.3` to the configuration.
    In exchange, code that use `effect` as an identifier must use
    `ocaml-version=5.2`.

  - The work to support OCaml 5.5 come with several improvements:
    + Improve the indentation of `let structure-item` with the
      `[@ocamlformat "disable"]` attribute.
      `let structure-item` means `let module`, `let open`, `let include` and
      `let exception`.
    + `(let open M in e)[@a]` is turned into `let[@a] open M in e`.
    + Long `let open ... in` no longer exceed the margin.
    + Improve indentation of `let structure-item` within parentheses:
      ```ocaml
      (* before *)
      (let module M = M in
      M.foo)
      (* after *)
      (let module M = M in
       M.foo)
      ```
versions:
authors: []
experimental: false
ignore: false
released_on_github_by: Julow
github_release_tags:
- 0.29.0
---

We're happy to announce the release of OCamlFormat 0.29.0.

This release adds support for OCaml 5.5 syntax ([#2772](https://github.com/ocaml-ppx/ocamlformat/pull/2772), [#2774](https://github.com/ocaml-ppx/ocamlformat/pull/2774), [#2775](https://github.com/ocaml-ppx/ocamlformat/pull/2775), [#2777](https://github.com/ocaml-ppx/ocamlformat/pull/2777), [#2780](https://github.com/ocaml-ppx/ocamlformat/pull/2780), [#2781](https://github.com/ocaml-ppx/ocamlformat/pull/2781), [#2782](https://github.com/ocaml-ppx/ocamlformat/pull/2782), [#2783](https://github.com/ocaml-ppx/ocamlformat/pull/2783)); the update brings several tiny formatting changes, listed in the full changelog below. The vendored Odoc parser is updated to 3.0 ([#2757](https://github.com/ocaml-ppx/ocamlformat/pull/2757)): the indentation of OCaml code-blocks is reduced by two to avoid changing the generated documentation, and indentation within code-blocks is now significant in Odoc and shows up in generated documentation. The default `ocaml-version` is now 5.4 ([#2750](https://github.com/ocaml-ppx/ocamlformat/pull/2750)), so the `effect` keyword is recognized without extra configuration (code that uses `effect` as an identifier must set `ocaml-version=5.2`). A new `letop-punning` option (`preserve` by default) controls whether bindings like `let+ x = x in ...` are punned to `let+ x in ...` ([#2746](https://github.com/ocaml-ppx/ocamlformat/pull/2746), [#2747](https://github.com/ocaml-ppx/ocamlformat/pull/2747)).

For more details, see the full changelog below.
