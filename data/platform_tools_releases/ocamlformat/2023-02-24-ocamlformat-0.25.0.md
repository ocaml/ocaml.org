---
title: OCamlFormat 0.25.0
tags:
- ocamlformat
- platform
authors:
contributors:
changelog: |
    ### Library

    *   The declaration of options is a regular module instead of a functor. ([#2193](https://github.com/ocaml-ppx/ocamlformat/pull/2193), [@EmileTrotignon](https://github.com/EmileTrotignon))

    ### Bug fixes

    *   Fix indentation when ocamlformat is disabled on an expression ([#2129](https://github.com/ocaml-ppx/ocamlformat/pull/2129), [@gpetiot](https://github.com/gpetiot))
    *   Reset max-indent when the `max-indent` option is not set ([#2131](https://github.com/ocaml-ppx/ocamlformat/pull/2131), [@hhugo](https://github.com/hhugo), [@gpetiot](https://github.com/gpetiot))
    *   Add missing parentheses around immediate objects having attributes attached in 4.14 ([#2144](https://github.com/ocaml-ppx/ocamlformat/pull/2144), [@gpetiot](https://github.com/gpetiot))
    *   Fix dropped comment attached to the identifier of an open-expression ([#2155](https://github.com/ocaml-ppx/ocamlformat/pull/2155), [@gpetiot](https://github.com/gpetiot))
    *   Correctly format chunks of file in presence of `enable`/`disable` floating attributes ([#2156](https://github.com/ocaml-ppx/ocamlformat/pull/2156), [@gpetiot](https://github.com/gpetiot))
    *   Remove abusive normalization in docstrings references ([#2159](https://github.com/ocaml-ppx/ocamlformat/pull/2159), [#2162](https://github.com/ocaml-ppx/ocamlformat/pull/2162), [@EmileTrotignon](https://github.com/EmileTrotignon))
    *   Fix parentheses around symbols in if-then-else branches ([#2169](https://github.com/ocaml-ppx/ocamlformat/pull/2169), [@gpetiot](https://github.com/gpetiot))
    *   Preserve position of comments around variant identifiers ([#2179](https://github.com/ocaml-ppx/ocamlformat/pull/2179), [@gpetiot](https://github.com/gpetiot))
    *   Fix parentheses around symbol identifiers ([#2185](https://github.com/ocaml-ppx/ocamlformat/pull/2185), [@gpetiot](https://github.com/gpetiot))
    *   Fix alignment inconsistency between let-binding and let-open ([#2187](https://github.com/ocaml-ppx/ocamlformat/pull/2187), [@gpetiot](https://github.com/gpetiot))
    *   Fix reporting of operational settings origin in presence of profiles ([#2188](https://github.com/ocaml-ppx/ocamlformat/pull/2188), [@EmileTrotignon](https://github.com/EmileTrotignon))
    *   Fix alignment inconsistency of if-then-else in apply ([#2203](https://github.com/ocaml-ppx/ocamlformat/pull/2203), [@gpetiot](https://github.com/gpetiot))
    *   Fix automated Windows build ([#2205](https://github.com/ocaml-ppx/ocamlformat/pull/2205), [@nojb](https://github.com/nojb))
    *   Fix spacing between recursive module bindings and recursive module declarations ([#2217](https://github.com/ocaml-ppx/ocamlformat/pull/2217), [@gpetiot](https://github.com/gpetiot))
    *   ocamlformat-rpc: use binary mode for stdin/stdout ([#2218](https://github.com/ocaml-ppx/ocamlformat/pull/2218), [@rgrinberg](https://github.com/rgrinberg))
    *   Fix interpretation of glob pattern in `.ocamlformat-ignore` under Windows ([#2206](https://github.com/ocaml-ppx/ocamlformat/pull/2206), [@nojb](https://github.com/nojb))
    *   Remove conf mutability, and correctly display the conventional profile when using print-config ([#2233](https://github.com/ocaml-ppx/ocamlformat/pull/2233), [@EmileTrotignon](https://github.com/EmileTrotignon))
    *   Preserve position of comments around type alias ([#2239](https://github.com/ocaml-ppx/ocamlformat/pull/2239), [@EmileTrotignon](https://github.com/EmileTrotignon))
    *   Preserve position of comments around constructor record ([#2237](https://github.com/ocaml-ppx/ocamlformat/pull/2237), [@EmileTrotignon](https://github.com/EmileTrotignon))
    *   Preserve position of comments around external declaration strings ([#2238](https://github.com/ocaml-ppx/ocamlformat/pull/2238), [@EmileTrotignon](https://github.com/EmileTrotignon), [@gpetiot](https://github.com/gpetiot))
    *   Preserve position of comments around module pack expressions ([#2234](https://github.com/ocaml-ppx/ocamlformat/pull/2234), [@EmileTrotignon](https://github.com/EmileTrotignon), [@gpetiot](https://github.com/gpetiot))
    *   Correctly parenthesize array literals with attributes in argument positions ([#2250](https://github.com/ocaml-ppx/ocamlformat/pull/2250), [@ccasin](https://github.com/ccasin))

    ### Changes

    *   Indent 2 columns after `initializer` keyword ([#2145](https://github.com/ocaml-ppx/ocamlformat/pull/2145), [@gpetiot](https://github.com/gpetiot))
    *   Preserve syntax of generative modules (`(struct end)` vs `()`) ([#2135](https://github.com/ocaml-ppx/ocamlformat/pull/2135), [#2146](https://github.com/ocaml-ppx/ocamlformat/pull/2146), [@trefis](https://github.com/trefis), [@gpetiot](https://github.com/gpetiot))
    *   Preserve syntax of module unpack with type constraint (`((module X) : (module Y))` vs `(module X : Y)`) ([#2136](https://github.com/ocaml-ppx/ocamlformat/pull/2136), [@trefis](https://github.com/trefis), [@gpetiot](https://github.com/gpetiot))
    *   Normalize location format for warning and error messages ([#2139](https://github.com/ocaml-ppx/ocamlformat/pull/2139), [@gpetiot](https://github.com/gpetiot))
    *   Preserve syntax and improve readability of indexop-access expressions ([#2150](https://github.com/ocaml-ppx/ocamlformat/pull/2150), [@trefis](https://github.com/trefis), [@gpetiot](https://github.com/gpetiot))
        *   Break sequences containing indexop-access assignments
        *   Remove unnecessary parentheses around indices
    *   Mute warnings for odoc code blocks whose syntax is not specified ([#2151](https://github.com/ocaml-ppx/ocamlformat/pull/2151), [@gpetiot](https://github.com/gpetiot))
    *   Improve formatting of odoc links ([#2152](https://github.com/ocaml-ppx/ocamlformat/pull/2152), [@gpetiot](https://github.com/gpetiot))
    *   Preserve sugared extension node attached to an `if` carrying attributes ([#2167](https://github.com/ocaml-ppx/ocamlformat/pull/2167), [@trefis](https://github.com/trefis), [@gpetiot](https://github.com/gpetiot))
    *   Remove unnecessary parentheses around partially applied infix operators with attributes ([#2198](https://github.com/ocaml-ppx/ocamlformat/pull/2198), [@gpetiot](https://github.com/gpetiot))
    *   JaneStreet profile: doesn't align infix ops with open paren ([#2204](https://github.com/ocaml-ppx/ocamlformat/pull/2204), [@gpetiot](https://github.com/gpetiot))
    *   Re-use the type let\_binding from the parser instead of value\_binding, improve the spacing of let-bindings regarding of having extension or comments ([#2219](https://github.com/ocaml-ppx/ocamlformat/pull/2219), [@gpetiot](https://github.com/gpetiot))
    *   The `ocamlformat` package now only contains the binary, the library is available through the `ocamlformat-lib` package ([#2230](https://github.com/ocaml-ppx/ocamlformat/pull/2230), [@gpetiot](https://github.com/gpetiot))

    ### New features

    *   Add a `break-colon` option to decide whether to break before or after the `:` symbol in value binding declarations and type constraints. This behavior is no longer ensured by `ocp-indent-compat`. ([#2149](https://github.com/ocaml-ppx/ocamlformat/pull/2149), [@gpetiot](https://github.com/gpetiot))
    *   Format `.mld` files as odoc documentation files ([#2008](https://github.com/ocaml-ppx/ocamlformat/pull/2008), [@gpetiot](https://github.com/gpetiot))
    *   New value `vertical` for option `if-then-else` ([#2174](https://github.com/ocaml-ppx/ocamlformat/pull/2174), [@gpetiot](https://github.com/gpetiot))
    *   New value `vertical` for option `break-cases` ([#2176](https://github.com/ocaml-ppx/ocamlformat/pull/2176), [@gpetiot](https://github.com/gpetiot))
    *   New value `wrap-or-vertical` for option `break-infix` that only wraps high precedence infix ops ([#1865](https://github.com/ocaml-ppx/ocamlformat/pull/1865), [@gpetiot](https://github.com/gpetiot))
versions:
backstage: false
ignore: false
github_release_tags:
- 0.25.0
---

OCamlFormat 0.25.0 is now available with expanded formatting capabilities!

This release addresses numerous inconsistencies and bugs, particularly around comment positioning, parentheses handling, and alignment issues. Key fixes include proper indentation when OCamlFormat is disabled on expressions, correct formatting of chunks with enable/disable attributes, and improved handling of comments around variant identifiers, type aliases, and constructor records. The release also resolves several platform-specific issues, including Windows build automation and glob pattern interpretation in `.ocamlformat-ignore` files.

New formatting options provide developers with more control over code layout. The `break-colon` option allows customization of line breaks around colons in value bindings and type constraints. Both `if-then-else` and `break-cases` options now support a `vertical` value for consistent vertical formatting. Additionally, OCamlFormat can now format `.mld` files as odoc documentation, and a new `wrap-or-vertical` value for `break-infix` provides more nuanced control over high-precedence infix operator wrapping.