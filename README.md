Typed and Versioned Data for OCaml.org v3
-----------------------------------------

Status: Not yet open for contributions. Contact @avsm.

This repository contains data for the OCaml.org website along with a suite of
tools for managing that data. In particular:

 - `data`: stores all of the data
 - `lib`: consumed by `src/lib`, this library (called `ood`) simply exposes the types for the various bits of data. The reason for the separation is to have the types exposed with zero dependencies. This should make it possible for lots of different platforms to consume that library (ReScript for example).
 - `src`: contains the code for `ood-cli`, a CLI tool for linting the data.

For more information about the ocaml.org site, please see the main repository
at <https://github.com/ocaml/v3.ocaml.org>.

**Current OCaml Version: 4.10.2** -- in order for the mdx tests to be consistent (for example some list the functions available from the `List` module) you should only run them with the current version of OCaml this repository is using. 

