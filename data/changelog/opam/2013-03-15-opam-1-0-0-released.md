---
title: "OPAM 1.0.0 released"
authors: [ "Thomas Gazagnaire" ]
date: "2013-03-15"
description: "Release announcement for OPAM 1.0.0"
tags: [opam, platform]
changelog: |
  The full change-log since the beta release in January:

  1.0.0 \[Mar 2013\]
  * Improve the lexer performance (thx to @oandrieu)
  * Fix various typos (thx to @chaudhuri)
  * Fix build issue (thx to @avsm)

  0.9.6 \[Mar 2013\]
  * Fix installation of pinned packages on BSD (thx to @smondet)
  * Fix configuration for zsh users (thx to @AltGr)
  * Fix loading of `~/.profile` when using dash (eg. in Debian/Ubuntu)
  * Fix installation of packages with symbolic links (regression introduced in 0.9.5)

  0.9.5 \[Mar 2013\]
  * If necessary, apply patches and substitute files before removing a package
  * Fix `opam remove <pkg> --keep-build-dir` keeps the folder if a source archive is extracted
  * Add build and install rules using ocamlbuild to help distro packagers
  * Support arbitrary level of nested subdirectories in packages repositories
  * Add `opam config exec "CMD ARG1 ... ARGn" --switch=SWITCH` to execute a command in a subshell
  * Improve the behaviour of `opam update` wrt. pinned packages
  * Change the default external solver criteria (only useful if you have aspcud installed on your machine)
  * Add support for global and user configuration for OPAM (`opam config setup`)
  * Stop yelling when OPAM is not up-to-date
  * Update or generate `~/.ocamlinit` when running `opam init`
  * Fix tests on *BSD (thx Arnaud Degroote)
  * Fix compilation for the source archive

  0.9.4 \[Feb 2013\]
  * Disable auto-removal of unused dependencies. This can now be enabled on-demand using `-a`
  * Fix compilation and basic usage on Cygwin
  * Fix BSD support (use `type` instead of `which` to detect existing commands)
  * Add a way to tag external dependencies in OPAM files
  * Better error messages when trying to upgrade pinned packages
  * Display `depends` and `depopts` fields in `opam info`
  * `opam info pkg.version` shows the metadata for this given package version
  * Add missing `doc` fields in `.install` files
  * `opam list` now only shows installable packages

  0.9.3 \[Feb 2013\]
  * Add system compiler constraints in OPAM files
  * Better error messages in case of conflicts
  * Cleaner API to install/uninstall packages
  * On upgrade, OPAM now perform all the remove action first
  * Use a cache for main storing OPAM metadata: this greatly speed-up OPAM invocations
  * after an upgrade, propose to reinstall a pinned package only if there were some changes
  * improvements to the solver heuristics
  * better error messages on cyclic dependencies

  0.9.2 \[Jan 2013\]
  * Install all the API files
  * Fix `opam repo remove repo-name`
  * speed-up `opam config env`
  * support for `opam-foo` scripts (which can be called using `opam foo`)
  * 'opam update pinned-package' works
  * Fix 'opam-mk-repo -a'
  * Fix 'opam-mk-repo -i'
  * clean-up pinned cache dir when a pinned package fails to install

  0.9.1 \[Jan 2013\]
  * Use ocaml-re 1.2.0
---

I am *very* happy to announce the first official release of OPAM!

Many of you already know and use OPAM so I won't be long. Please read
[http://www.ocamlpro.com/blog/2013/01/17/opam-beta.html][opam-beta] for a
longer description.

1.0.0 fixes many bugs and add few new features to the previously announced
beta-release.

The most visible new feature, which should be useful for beginners with
OCaml and OPAM,  is an auto-configuration tool. This tool easily enables all
the features of OPAM (auto-completion, fix the loading of scripts for the
toplevel, opam-switch-eval alias, etc). This tool runs interactively on each
`opam init` invocation. If you don't like OPAM to change your configuration
files, use `opam init --no-setup`. If you trust the tool blindly,  use
`opam init --auto-setup`. You can later review the setup by doing
`opam config setup --list` and call the tool again using `opam config setup`
(and you can of course manually edit your ~/.profile (or ~/.zshrc for zsh
users), ~/.ocamlinit and ~/.opam/opam-init/*).

Please report:
- Bug reports and feature requests for the OPAM tool: http://github.com/OCamlPro/opam/issues
- Packaging issues or requests for a new packages: http://github.com/OCamlPro/opam-repository/issues
- General queries to: https://lists.ocaml.org/listinfo/platform
- More specific queries about the internals of OPAM to: https://lists.ocaml.org/listinfo/opam-devel

## Install ##

Packages for Debian and OSX (at least homebrew) should follow shortly and
I'm looking for volunteers to create and maintain rpm packages. The binary
installer is up-to-date for Linux and Darwin 64-bit architectures, the
32-bit version for Linux should arrive shortly.

If you want to build from sources, the full archive (including dependencies)
is available here:

  http://www.ocamlpro.com/pub/opam-full-latest.tar.gz

### Upgrade ###

If you are upgrading from 0.9.* you won't  have anything special to do apart
installing the new binary. You can then update your package metadata by
running `opam update`. If you want to use the auto-setup feature, remove the
"eval `opam config env` line you have previously added in your ~/.profile
and run `opam config setup --all`.

So everything should be fine. But you never know ... so if something goes
horribly wrong in the upgrade process (of if your are upgrading from an old
version of OPAM) you can still trash your ~/.opam, manually remove what OPAM
added in  your ~/.profile (~/.zshrc for zsh users) and ~/.ocamlinit, and
start again from scratch. 

### Random stats ###

Great success on github. Thanks everybody for the great contributions!

https://github.com/OCamlPro/opam: +2000 commits, 26 contributors
https://github.com/OCamlPro/opam-repository: +1700 commits, 75 contributors, 370+ packages

on http://opam.ocamlpro.com/
+400 unique visitor per week, 15k 'opam update' per week
+1300 unique visitor per month, 55k 'opam update' per month
3815 unique visitor since the alpha release

[opam-beta]: http://www.ocamlpro.com/blog/2013/01/17/opam-beta.html
