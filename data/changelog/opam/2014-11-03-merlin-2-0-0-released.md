---
title: "Merlin 2.0 release"
authors: [ "Frederic Bour", "Thomas Refis" ]
date: "2014-11-03"
description: "Release announcement for Merlin 2.0"
tags: [opam, platform, release]
---

After a few months of development, we are pleased to announce the
[stable release](https://github.com/the-lambda-church/merlin/blob/master/CHANGELOG - [404 Not Found]) of
[Merlin 2.0](https://github.com/the-lambda-church/merlin).  
Supported OCaml versions range from 4.00.1 to 4.02.1.

### Overview

Merlin is a tool focused on helping you code in OCaml by providing features
such as:
* automatic completion of identifiers, using scope and type information,
* interactively typing definitions and expressions during edition,
* jumping to the definition of any identifier,
* quickly reporting errors in the editor.

We provide integration into Vim and Emacs.  An external plugin is also
available for [Sublime Text](https://github.com/def-lkb/sublime-text-merlin).

### What's new

This release provides great improvements in robustness and quality of analysis.
Files that changed on disk are now automatically reloaded. 
The parsing process is finer grained to provide more accurate recovery and error
messages.
Integration with Jane Street Core and js\_of\_ocaml has also improved.

Vim & Emacs are still the main targeted editors. 
Thanks to [Luc Rocher](https://github.com/Cynddl), preliminary support for
Sublime Text is also available, see
[Sublime-text-merlin](https://github.com/def-lkb/sublime-text-merlin).
Help is welcome to improve and extend supported editing environments.

Windows support also received some fixes.  Merlin is now distributed in
[WODI](http://wodi.forge.ocamlcore.org/).  Integration in
[OCaml-on-windows](http://protz.github.io/ocaml-installer/) is planned.

### Installation

This new version of Merlin is already available with opam using `opam install
merlin`, and can also be built from the sources which are available at
[the-lambda-church/merlin](http://github.com/the-lambda-church/merlin).

### Changelog

This is a major release which we worked on for several months, rewriting many
parts of the codebase. An exhaustive list of changes is therefore impossible to
give, but here are some key points (from an user perspective):

* support for OCaml 4.02.{0,1}
* more precise recovery in presence of syntax errors
* more user-friendly messages for syntax errors
* locate now works on MLI files
* automatic reloading of .merlin files (when they are update or created), it
  is no longer necessary to restart Merlin
* introduced a small refactoring command: rename, who renames all occurences
  of an identifier. See [here](http://yawdp.com/~host/merlin_rename.webm - [1 Client error: Couldn't resolve host name]).

This release also contains contributions from: Yotam Barnoy, Jacques-Pascal
Deplaix, Geoff Gole, Rudi Grinberg, Steve Purcell and Jan Rehders.

We also thank Gabriel Scherer and Jane Street for their continued support.
