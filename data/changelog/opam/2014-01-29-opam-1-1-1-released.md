---
title: "OPAM 1.1.1 released"
authors: [ "Louis Gesbert" ]
date: "2014-01-29"
description: "Release announcement for OPAM 1.1.1"
tags: [opam, platform]
changelog: |
  From the changelog:  
  * Fix `opam-admin make <packages> -r` (#990)
  * Explicitly prettyprint list of lists, to fix `opam-admin depexts` (#997)
  * Tell the user which fields is invalid in a configuration file (#1016)
  * Add `OpamSolver.empty_universe` for flexible universe instantiation (#1033)
  * Add `OpamFormula.eval_relop` and `OpamFormula.check_relop` (#1042)
  * Change `OpamCompiler.compare` to match `Pervasives.compare` (#1042)
  * Add `OpamCompiler.eval_relop` (#1042)
  * Add `OpamPackage.Name.compare` (#1046)
  * Add types `version_constraint` and `version_formula` to `OpamFormula` (#1046)
  * Clearer command aliases. Made `info` an alias for `show` and added the alias
  `uninstall` (#944)
  * Fixed `opam init --root=<relative path>` (#1047)
  * Display OS constraints in `opam info` (#1052)
  * Add a new 'opam-installer' script to make `.install` files usable outside of opam (#1026)
  * Add a `--resolve` option to `opam-admin make` that builds just the archives you need for a specific installation (#1031)
  * Fixed handling of spaces in filenames in internal files (#1014)
  * Replace calls to `which` by a more portable call (#1061)
  * Fixed generation of the init scripts in some cases (#1011)
  * Better reports on package patch errors (#987, #988)
  * More accurate warnings for unknown package dependencies (#1079)
  * Added `opam config report` to help with bug reports (#1034)
  * Do not reinstall dev packages with `opam upgrade <pkg>` (#1001)
  * Be more careful with `opam init` to a non-empty root directory (#974)
  * Cleanup build-dir after successful compiler installation to save on space (#1006)
  * Improved OSX compatibility in the external solver tools (#1074)
  * Fixed messages printed on update that were plain wrong (#1030)
  * Improved detection of meaningful changes from upstream packages to trigger recompilation
---

We are proud to announce that *OPAM 1.1.1* has just been released.

This minor release features mostly stability and UI/doc improvements over
OPAM 1.1.0, but also focuses on improving the API and tools to be a better
base for the platform (functions for `opam-doc`, interface with tools like
`opamfu` and `opam-installer`). Lots of bigger changes are in the works, and
will be merged progressively after this release.


## Installing ##

Installation instructions are available
[on the wiki](https://opam.ocaml.org/doc/Install.html).

Note that some packages may take a few days until they get out of the
pipeline. If you're eager to get 1.1.1, either use our
[binary installer](https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh) or
[compile from source](https://github.com/ocaml/opam/releases/tag/1.1.1).

The 'official' package repository is now hosted at [opam.ocaml.org][],
synchronised with the Git repository at
[http://github.com/ocaml/opam-repository][repo],
where you can contribute new packages descriptions. Those are under a CC0
license, a.k.a. public domain, to ensure they will always belong to the
community.

Thanks to all of you who have helped build this repository and made OPAM
such a success.

[opam.ocaml.org]: https://opam.ocaml.org
[repo]: http://github.com/ocaml/opam-repository
