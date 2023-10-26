---
title: "OPAM 1.1.0 released"
authors: [ "Thomas Gazagnaire" ]
date: "2013-11-08"
description: "Release announcement for OPAM 1.1.0"
tags: [opam, platform]
changelog: |
   Too many to list here, see
   [https://raw.github.com/OCamlPro/opam/1.1.0/CHANGES](https://raw.github.com/OCamlPro/opam/1.1.0/CHANGES)

   For packagers, some new fields have appeared in the OPAM description format:
   - `depexts` provides facilities for dealing with system (non ocaml) dependencies
   - `messages`, `post-messages` can be used to notify the user eg. of licensing information,
   or help her  troobleshoot at package installation.
   - `available` supersedes `ocaml-version` and `os` constraints, and can contain
   more expressive formulas

   Also, we have integrated the main package repository with Travis, which will
   help us to improve the quality of contributions (see [Anil's post][2]).

   [opam.ocaml.org]: https://opam.ocaml.org
   [opam.ocamlpro.com]: http://opam.ocamlpro.com
   [repo]: http://github.com/ocaml/opam-repository
   [1]: https://launchpad.net/~avsm/+archive/ppa/+builds?build_state=pending
   [2]: http://anil.recoil.org/2013/09/30/travis-and-ocaml.html
---

After a while staged as RC, we are proud to announce the final release of
*OPAM 1.1.0*!

Thanks again to those who have helped testing and fixing the last few issues.


## Important note ##

The repository format has been improved with incompatible new features; to
account for this, the *new* repository is now hosted at [opam.ocaml.org][],
and the legacy repository at [opam.ocamlpro.com][] is kept to support OPAM
1.0 installations, but is unlikely to benefit from many package updates.
Migration to [opam.ocaml.org][] will be done automatically as soon as you
upgrade your OPAM version.

You're still free, of course, to use any third-party repositories instead or
in addition.

## Installing ##

NOTE: When switching from 1.0, the internal state will need to be upgraded.
THIS PROCESS CANNOT BE REVERTED. We have tried hard to make it fault-
resistant, but failures might happen. In case you have precious data in your 
`~/.opam` folder, it is advised to **backup that folder before you upgrade
to 1.1.0**.

Using the binary installer:
- download and run http://www.ocamlpro.com/pub/opam_installer.sh

Using the .deb packages from Anil's PPA (binaries are [currently syncing][1]):
   add-apt-repository ppa:avsm/ppa
   apt-get update
   sudo apt-get install opam

For OSX users, the homebrew package will be updated shortly.

or build it from sources at :
- http://www.ocamlpro.com/pub/opam-full-1.1.0.tar.gz
- https://github.com/ocaml/opam/releases/tag/1.1.0

## For those who haven't been paying attention ##

OPAM is a source-based package manager for OCaml. It supports multiple
simultaneous compiler installations, flexible package constraints, and
a Git-friendly development workflow. OPAM is edited and
maintained by OCamlPro, with continuous support from OCamlLabs and the
community at large (including its main industrial users such as
Jane-Street and Citrix).

The 'official' package repository is now hosted at [opam.ocaml.org][],
synchronised with the Git repository at
[http://github.com/ocaml/opam-repository][repo], where you can contribute
new packages descriptions. Those are under a CC0 license, a.k.a. public
domain, to ensure they will always belong to the community.

Thanks to all of you who have helped build this repository and made OPAM
such a success.
