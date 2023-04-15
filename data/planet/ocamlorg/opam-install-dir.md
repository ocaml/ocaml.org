---
title: "new opam features: \"opam install <dir>\""
authors: [ "Louis Gesbert" ]
date: "2017-05-04"
description: "Presentation of the new opam install <dir> feature introduced in opam 2.0"
---

After the [opam build](../opam-build) feature was announced followed a lot of discussions, mainly having to do with its interface, and misleading name. The base features it offered, though, were still widely asked for:

- a way to work directly with the project in the current directory, assuming it contains definitions for one or more packages
- a way to copy the installed files of a package below a specified `destdir`
- an easier way to get started hacking on a project, even without an initialised opam

### Status of `opam build`

`opam build`, as described in a [previous post](../opam-build) has been dropped. It will be absent from the next Beta, where the following replaces it.

### Handling a local project

Consistently with what was done with local switches, it was decided, where meaningful, to overload the `<packages>` arguments of the commands, allowing directory names instead, and meaning "all packages defined there", with some side-effects.

For example, the following command is now allowed, and I believe it will be extra convenient to many:

    opam install . --deps-only

What this does is find `opam` (or `<pkgname>.opam`) files in the current directory (`.`), resolve their installations, and install all required packages. That should be the single step before running the source build by hand.

The following is a little bit more complex:

    opam install .

This also retrieves the packages defined at `.`, __pins them__ to the current source (using version-control if present), and installs them. Note that subsequent runs actually synchronise the pinnings, so that packages removed or renamed in the source tree are tracked properly (_i.e._ removed ones are unpinned, new ones pinned, the other ones upgraded as necessary).

`opam upgrade`, `opam reinstall`, and `opam remove` have also been updated to handle directories as arguments, and will work on "all packages pinned to that target", _i.e._ the packages pinned by the previous call to `opam install <dir>`. In addition, `opam remove <dir>` unpins the packages, consistently reverting the converse `install` operation.

`opam show` already had a `--file` option, but has also been extended in the same way, for consistency and convenience.

This all, of course, works well with a local switch at `./`, but the two features can be used completely independently. Note also that the directory name must be made unambiguous with a possible package name, so make sure to use `./foo` rather than just `foo` for a local project in subdirectory `foo`.

### Specifying a destdir

This relies on installed files tracking, but was actually independent from the other `opam build` features. It is now simply a new option to `opam install`:

    opam install foo --destdir ~/local/

will install `foo` normally (if it isn't installed already) and copy all its installed files, following the same hierarchy, into `~/local`. `opam remove --destdir` is also supported, to remove these files.

### Initialising

Automatic initialisation has been dropped for the moment. It was only saving one command (`opam init`, that opam will kindly print out for you if you forget it), and had two drawbacks:
- some important details (like shell setup for opam) were skipped
- the initialisation options were much reduced, so you would often have to go back to `opam init` anyway. The other possibility being to duplicate `init` options to all commands, adding lots of noise. Keeping things separate has its merits.

Granted, another command, `opam switch create .`, was made implicit. But using a local switch is a user choice, and worse, in contradiction with the previous de facto opam default, so not creating one automatically seems safer: having to specify `--no-autoinit` to `opam build` in order to get the more simple behaviour was inconvenient and error-prone.

One thing is provided to help with initialisation, though: `opam switch create <dir>` has been improved to handle package definitions at `<dir>`, and will use them to choose a compatible compiler, as `opam build` did. This avoids the frustration of creating a switch, then finding out that the package wasn't compatible with the chosen compiler version, and having to start over with an explicit choice of a different compiler.

If you would really like automatic initialisation, and have a better interface to propose, your feedback is welcome!

### More related options

A few other new options have been added to `opam install` and related commands, to improve the project-local workflows:

- `opam install --keep-build-dir` is now complemented with `--reuse-build-dir`, for incremental builds within opam (assuming your build-system supports it correctly). At the moment, you should specify both on every upgrade of the concerned packages, or you could set the `OPAMKEEPBUILDDIR` and `OPAMREUSEBUILDDIR` environment variables.
- `opam install --inplace-build` runs the scripts directly within the source dir instead of a dedicated copy. If multiple packages are pinned to the same directory, this disables parallel builds of these packages.
- `opam install --working-dir` uses the working directory state of your project, instead of the state registered in the version control system. Don't worry, opam will warn you if you have uncommitted changes and forgot to specify `--working-dir`.

> NOTE: this article is cross-posted on [opam.ocaml.org](https://opam.ocaml.org/blog/) and [ocamlpro.com](http://www.ocamlpro.com/category/blog/). Please head to the latter for the comments!
