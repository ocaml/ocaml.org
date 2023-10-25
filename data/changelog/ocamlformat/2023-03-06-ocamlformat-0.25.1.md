---
title: Ocamlformat 0.25.1
date: "2023-03-06"
tags: [ocamlformat, platform]
changelog: |
  ### Library

  - The declaration of options is a regular module instead of a functor. (#2193, @EmileTrotignon)

  ### Bug fixes

  - Fix indentation when ocamlformat is disabled on an expression (#2129, @gpetiot)
  - Reset max-indent when the `max-indent` option is not set (#2131, @hhugo, @gpetiot)
  - Add missing parentheses around immediate objects having attributes attached in 4.14 (#2144, @gpetiot)
  - Fix dropped comment attached to the identifier of an open-expression (#2155, @gpetiot)
  - Correctly format chunks of file in presence of `enable`/`disable` floating attributes (#2156, @gpetiot)
  - Remove abusive normalization in docstrings references (#2159, #2162, @EmileTrotignon)
  - Fix parentheses around symbols in if-then-else branches (#2169, @gpetiot)
  - Preserve position of comments around variant identifiers (#2179, @gpetiot)
  - Fix parentheses around symbol identifiers (#2185, @gpetiot)
  - Fix alignment inconsistency between let-binding and let-open (#2187, @gpetiot)
  - Fix reporting of operational settings origin in presence of profiles (#2188, @EmileTrotignon)
  - Fix alignment inconsistency of if-then-else in apply (#2203, @gpetiot)
  - Fix automated Windows build (#2205, @nojb)
  - Fix spacing between recursive module bindings and recursive module declarations (#2217, @gpetiot)
  - ocamlformat-rpc: use binary mode for stdin/stdout (#2218, @rgrinberg)
  - Fix interpretation of glob pattern in `.ocamlformat-ignore` under Windows (#2206, @nojb)
  - Remove conf mutability, and correctly display the conventional profile when using print-config (#2233, @EmileTrotignon)
  - Preserve position of comments around type alias (#2239, @EmileTrotignon)
  - Preserve position of comments around constructor record (#2237, @EmileTrotignon)
  - Preserve position of comments around external declaration strings (#2238, @EmileTrotignon, @gpetiot)
  - Preserve position of comments around module pack expressions (#2234, @EmileTrotignon, @gpetiot)
  - Correctly parenthesize array literals with attributes in argument positions (#2250, @ccasin)
  - Janestreet: Fix indentation of functions passed as labelled argument (#2259, @Julow)

  ### Changes

  - Indent 2 columns after `initializer` keyword (#2145, @gpetiot)
  - Preserve syntax of generative modules (`(struct end)` vs `()`) (#2135, #2146, @trefis, @gpetiot)
  - Preserve syntax of module unpack with type constraint (`((module X) : (module Y))` vs `(module X : Y)`) (#2136, @trefis, @gpetiot)
  - Normalize location format for warning and error messages (#2139, @gpetiot)
  - Preserve syntax and improve readability of indexop-access expressions (#2150, @trefis, @gpetiot)
    + Break sequences containing indexop-access assignments
    + Remove unnecessary parentheses around indices
  - Mute warnings for odoc code blocks whose syntax is not specified (#2151, @gpetiot)
  - Improve formatting of odoc links (#2152, @gpetiot)
  - Preserve sugared extension node attached to an `if` carrying attributes (#2167, @trefis, @gpetiot)
  - Remove unnecessary parentheses around partially applied infix operators with attributes (#2198, @gpetiot)
  - JaneStreet profile: doesn't align infix ops with open paren (#2204, @gpetiot)
  - Re-use the type let_binding from the parser instead of value_binding, improve the spacing of let-bindings regarding of having extension or comments (#2219, @gpetiot)
  - The `ocamlformat` package now only contains the binary, the library is available through the `ocamlformat-lib` package (#2230, @gpetiot)

  ### New features

  - Add a `break-colon` option to decide whether to break before or after the `:` symbol in value binding declarations and type constraints. This behavior is no longer ensured by `ocp-indent-compat`. (#2149, @gpetiot)
  - Format `.mld` files as odoc documentation files (#2008, @gpetiot)
  - New value `vertical` for option `if-then-else` (#2174, @gpetiot)
  - New value `vertical` for option `break-cases` (#2176, @gpetiot)
  - New value `wrap-or-vertical` for option `break-infix` that only wraps high precedence infix ops (#1865, @gpetiot)

---

We are pleased to announce the release of OCamlFormat 0.25.1! This release contains several bug fixes, changes, and new features.

The library is also available through the `ocamlformat-lib` package on opam. The `ocamlformat` package only contains the binary.

---

We would like to thank all contributors for their valuable contributions to this release. Please see the [complete changelog](https://github.com/ocaml-ppx/ocamlformat/releases/tag/0.25.0) for more details.

We hope you enjoy this release and continue to find OCamlFormat a valuable tool for your OCaml projects. You can download `ocamlformat.0.25.1` from the opam repository or GitHub.

Thank you for your support and feedback, and please don't hesitate to reach out if you have any questions or issues.

The OCamlFormat team

## 🌟 Spotlight Feature

1. **New `if-then-else` and `break-cases` options**

  Starting in OCamlFormat 0.25.1, we've also added new values to the `if-then-else` and `break-cases` options. Now you can use the `vertical` value to format these expressions in a more readable and consistent way.

  These options are not set by default but you can try them out by customizing your `.ocamlformat` file as usual.

  Here are a few examples:

  - `if-then-else = vertical`
  ```diff
  -  let epi = if Option.is_some next then fmt "@\n" else fmt_opt epi in
  +  let epi =
  +    if Option.is_some next then
  +      fmt "@\n"
  +    else
  +      fmt_opt epi
  +  in
  ```

  ```diff
  -    if tree_depth tree > depth then node_depth_truncate_ depth node
  -    else (* already short enough; don't bother truncating *)
  +    if tree_depth tree > depth then
  +      node_depth_truncate_ depth node
  +    else
  +      (* already short enough; don't bother truncating *)
        node
  ```

  - `break-cases = vertical`

  ```diff
  -| Ok (`Version | `Help) -> Stdlib.exit 0
  -| Error _ -> Stdlib.exit 1
  +| Ok (`Version | `Help) ->
  +    Stdlib.exit 0
  +| Error _ ->
  +    Stdlib.exit 1
  ```

  ```diff
  -    ~f:(function `Int _ | `Float _ -> true | _ -> false)
  +    ~f:(function
  +      | `Int _
  +      | `Float _ ->
  +          true
  +      | _ ->
  +          false)
  ```

2. **Formatting .mld files**

  Formatting `.mld` files as odoc documentation files is now possible! This will make it much easier to maintain high-quality documentation alongside your OCaml code.

  This feature is only available in `ocamlformat` for now, but keep an eye on the future `dune` releases to know when `dune fmt` will be able to format your `.mld` files!


3. **Various improvements and bugfixes**

  We fixed various issues related to indentation, alignment, and comments positioning.

  Here are a few examples:

  - More consistent indentation inside a parenthesized expression:

  ```diff
          | [ node ] ->
              ( (if List.mem node ~set:integer_graph.(node)
  -              then Has_loop [ numbering.forth.(node) ]
  -              else No_loop numbering.forth.(node))
  +               then Has_loop [ numbering.forth.(node) ]
  +               else No_loop numbering.forth.(node))
              , component_edges.(component) )
  ```

  ```diff
      (let open Memo.O in
  -    let+ w = Dune_rules.Workspace.workspace () in
  -    Dune_engine.Execution_parameters.builtin_default
  -    |> Dune_rules.Workspace.update_execution_parameters w);
  +     let+ w = Dune_rules.Workspace.workspace () in
  +     Dune_engine.Execution_parameters.builtin_default
  +     |> Dune_rules.Workspace.update_execution_parameters w);
  ```

  - More consistent formatting of module expressions:

  ```diff
  -  module Sel = (val if is_osx () then (module Mac)
  -                    else if Sys.unix then (module Unix)
  -                    else (module Fail) : Unix_socket)
  +  module Sel =
  +    (val if is_osx () then (module Mac)
  +         else if Sys.unix then (module Unix)
  +         else (module Fail)
  +        : Unix_socket)
  ```