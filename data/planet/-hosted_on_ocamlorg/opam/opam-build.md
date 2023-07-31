---
title: "new opam features: \"opam build\""
authors: [ "Louis Gesbert" ]
date: 2017-03-16T00:00:00-00:00
description: "Presentation of the opam build command introduced in opam 2.0"
source:
  name: Opam blog
  url: ""
  tag: "personnal blog"
---

> UPDATE: after discussions following this post, this feature was abandoned with
> the interface presented below. See [this post](../opam-install-dir) for
> the details and the new interface!

The new opam 2.0 release, currently in beta, introduces several new features.
This post gets into some detail on the new `opam build` command, its purpose,
its use, and some implementation aspects.

**`opam build` is run from the source tree of a project, and does not rely on a
pre-existing opam installation.** As such, it adds a new option besides the
existing workflows based on managing shared OCaml installations in the form of
switches.


### What does it do ?

Typically, this is used in a fresh git clone of some OCaml project. Like when
pinning the package, opam will find and leverage package definitions found in
the source, in the form of `opam` files.

- if opam hasn't been initialised (no `~/.opam`), this is taken care of.
- if no switch is otherwise explicitely selected, a _local switch_ is used, and
  created if necessary (_i.e._ in `./_opam/`)
- the metadata for the current project is registered, and the package installed
  after its dependencies, as opam usually does


This is particularly useful for **distributing projects** to people not used to
opam and the OCaml ecosystem: the setup steps are automatically taken care of,
and a single `opam build` invocation can take care of resolving the dependency
chains for your package.

If building the project directly is preferred, adding `--deps-only` is a good
way to get the dependencies ready for the project:

```
opam build --deps-only
eval $(opam config env)
./configure; make; etc.
```

Note that if you just want to handle project-local opam files, `opam build` can
also be used in your existing switches: just specify `--no-autoinit`, `--switch`
or make sure the `OPAMSWITCH` variable is set. _E.g._ `opam build --no-autoinit
--deps-only` is a convenient way to get the dependencies for the local project
ready in your current switch.

### Additional functions

#### Installation

The installation of the packages happens as usual to the prefix corresponding to
the switch used (`<project-root>/_opam/` for a local switch). But it is
possible, with `--install-prefix`, to further install the package to the system:

```
opam build --install-prefix ~/local
```

will install the results of the package found in the current directory below
~/local.

The dependencies of the package won't be installed, so this is intended for
programs, assuming they are relocatable, and not for libraries.


#### Choosing custom repositories

The user can pre-select the repositories to use on the creation of the local
switch with:

```
opam build --repositories <repos>
```

where `<repos>` is a comma-separated list of repositories, specified either as
`name=URL`, or `name` if already configured on the system.


#### Multiple packages

Multiple packages are commonly found to share a single repository. In this case,
`opam build` registers and builds all of them, respecting cross-dependencies.
The opam files to use can also be explicitely selected on the command-line.

In this case, specific opam files must be named `<package-name>.opam`.


### Implementation details

The choice of the compiler, on automatic initialisation, is either explicit,
using the `--compiler` option, or automatic. In the latter case, the default
selection is used (see `opam init --help`, section "CONFIGURATION FILE" for
details), but a compiler compatible with the local packages found is searched
from that. This allows, for example, to choose a system compiler when available
and compatible, avoiding a recompilation of OCaml.

When using `--install-prefix`, the normal installation is done, then the
tracking of package-installed files, introduced in opam 2.0, is used to extract
the installed files from the switch and copy them to the prefix.

The packages installed through `opam build` are not registered in any
repository, and this is not an implicit use of `opam pin`: the rationale is that
packages installed this way will also be updated by repeating `opam build`. This
means that when using other commands, _e.g._ `opam upgrade`, opam won't try to
keep the packages to their local, source version, and will either revert them to
their repository definition, or remove them, if they need recompilation.

### Planned extensions

This is still in beta: there are still rough edges, please experiment and give
feedback! It is still possible that the command syntax and semantics change
significantly before release.

Another use-case that we are striving to improve is sharing of development
setups (share sets of pinned packages, depend on specific remotes or git hashes,
etc.). We have [many](https://github.com/ocaml/opam/issues/2762)
[ideas](https://github.com/ocaml/opam/issues/2495) to
[improve](https://github.com/ocaml/opam/issues/1734) on this, but `opam build`
is not, as of today, a direct solution to this. In particular, installing this
way still relies on the default opam repository; a way to define specific
options for the switch that is implicitely created on `opam build` is in the
works.

> NOTE: this article is cross-posted on [opam.ocaml.org](https://opam.ocaml.org/blog/) and [ocamlpro.com](http://www.ocamlpro.com/category/blog/). Please head to the latter for the comments!
