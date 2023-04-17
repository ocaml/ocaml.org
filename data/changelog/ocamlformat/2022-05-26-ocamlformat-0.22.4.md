---
title: Ocamlformat 0.22.4
date: "2022-05-26"
tags: [ocamlformat, platform]
changelog: |
  ### Removed

  - Profiles `compact` and `sparse` are now removed (#2075, @gpetiot)
  - Options `align-cases`, `align-constructors-decl` and `align-variants-decl` are now removed (#2076, @gpetiot)
  - Option `disable-outside-detected-project` is now removed (#2077, @gpetiot)

  ### Deprecated

  - Cancel the deprecations of options that are not set by the preset profiles (#2074, @gpetiot)

  ### Bug fixes

  - emacs: Remove temp files in the event of an error (#2003, @gpetiot)
  - Fix unstable comment formatting around prefix op (#2046, @gpetiot)

  ### Changes

  - Qtest comments are not re-formatted (#2034, @gpetiot)
  - ocamlformat-rpc is now distributed through the ocamlformat package (#2035, @Julow)
  - Doc-comments code blocks with a language other than 'ocaml' (set in metadata) are not parsed as OCaml (#2037, @gpetiot)
  - More comprehensible error message in case of version mismatch (#2042, @gpetiot)
  - The global configuration file (`$XDG_CONFIG_HOME` or `$HOME/.config`) is only applied when no project is detected, `--enable-outside-detected-project` is set, and no applicable `.ocamlformat` file has been found. Global and local configurations are no longer used at the same time. (#2039, @gpetiot)
  - Set `ocaml-version` to a fixed version (4.04.0) by default to avoid reproducibility issues and surprising behaviours (#2064, @kit-ty-kate)
  - Split option `--numeric=X-Y` into `--range=X-Y` and `--numeric` (flag). For now `--range` can only be used with `--numeric`. (#2073, #2082, @gpetiot)

  ### New features

  - New syntax `(*= ... *)` for verbatim comments (#2028, @gpetiot)
  - Preserve the begin-end construction in the AST (#1785, @hhugo, @gpetiot)
  - Preserve position of comments located after the semi-colon of the last element of lists/arrays/records (#2032, @gpetiot)
  - Option `--print-config` displays a warning when an .ocamlformat file defines redundant options (already defined by a profile) (#2084, @gpetiot)
---

