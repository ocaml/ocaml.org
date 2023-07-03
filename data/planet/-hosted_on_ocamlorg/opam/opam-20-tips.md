---
title: "opam 2.0 tips"
authors: [ "Louis Gesbert" ]
date: "2019-03-12"
description: "Some tips on the new features introduced in opam 2.0"
---

This blog post looks back on some of the improvements in opam 2.0, and gives
tips on the new workflows available.

## Package development environment management

Opam 2.0 has been vastly improved to handle locally defined packages. Assuming
you have a project `~/projects/foo`, defining two packages `foo-lib` and
`foo-bin`, you would have:

```
~/projects/foo
|-- foo-lib.opam
|-- foo-bin.opam
`-- src/ ...
```

(See also about
[computed dependency constraints](../opam-extended-dependencies/#Computed-versions)
for handling multiple package definitions with mutual constraints)

### Automatic pinning

The underlying mechanism is the same, but this is an interface improvement that
replaces most of the opam 1.2 workflows based on `opam pin`.

The usual commands (`install`, `upgrade`, `remove`, etc.) have been extended to
support specifying a directory as argument. So when working on project `foo`,
just write:

```
cd ~/projects/foo
opam install .
```

and both `foo-lib` and `foo-bin` will get automatically pinned to the current
directory (using git if your project is versioned), and installed. You may
prefer to use:

```
opam install . --deps-only
```

to just get the package dependencies ready before you start hacking on it.
[See below](#Reproducing-build-environments) for details on how to reproduce a
build environment more precisely. Note that `opam depext .` will not work at the
moment, which will be fixed in the next release when the external dependency
handling is integrated (opam will still list you the proper packages to install
for your OS upon failure).

If your project is versioned and you made changes, remember to either commit, or
add `--working-dir` so that your uncommitted changes are taken into account.


## Local switches

> Opam 2.0 introduced a new feature called "local switches". This section
> explains what it is about, why, when and how to use them.

Opam _switches_ allow to maintain several separate development environments,
each with its own set of packages installed. This is particularly useful when
you need different OCaml versions, or for working on projects with different
dependency sets.

It can sometimes become tedious, though, to manage, or remember what switch to
use with what project. Here is where "local switches" come in handy.


### How local switches are handled

A local switch is simply stored inside a `_opam/` directory, and will be
selected automatically by opam whenever your current directory is below its
parent directory.

> NOTE: it's highly recommended that you enable the new _shell hooks_ when using
> local switches. Just run `opam init --enable-shell-hook`: this will make sure
> your PATH is always set for the proper switch.
>
> You will otherwise need to keep remembering to run `eval $(opam env)` every
> time you `cd` to a directory containing a local switch. See also
> [how to display the current switch in your prompt](https://opam.ocaml.org/doc/Tricks.html#Display-the-current-quot-opam-switch-quot-in-the-prompt)

For example, if you have `~/projects/foo/_opam`, the switch will be selected
whenever in project `foo`, allowing you to tailor what it has installed for the
needs of your project.

If you remove the switch dir, or your whole project, opam will forget about it
transparently. Be careful not to move it around, though, as some packages still
contain hardcoded paths and don't handle relocation well (we're working on
that).


### Creating a local switch

This can generally start with:
```
cd ~/projects/foo
opam switch create . --deps-only
```

Local switch handles are just their path, instead of a raw name. Additionally,
the above will detect package definitions present in `~/projects/foo`, pick a
compatible version of OCaml (if you didn't explicitely mention any), and
automatically install all the local package dependencies.

Without `--deps-only`, the packages themselves would also get installed in the
local switch.

### Using an existing switch

If you just want an already existing switch to be selected automatically,
without recompiling one for each project, you can use `opam switch link`:

```
cd ~/projects/bar
opam switch link 4.07.1
```

will make sure that switch `4.07.1` is chosen whenever you are in project `bar`.
You could even link to `../foo` here, to share `foo`'s local switch between the
two projects.


## Reproducing build environments

#### Pinnings

If your package depends on development versions of some dependencies (e.g. you
had to push a fix upstream), add to your opam file:

```opam
depends: [ "some-package" ] # Remember that pin-depends are depends too
pin-depends: [
  [ "some-package.version" "git+https://gitfoo.com/blob.git#mybranch" ]
]
```

This will have no effect when your package is published in a repository, but
when it gets pinned to its dev version, opam will first make sure to pin
`some-package` to the given URL.

#### Lock-files

Dependency contraints are sometimes too wide, and you don't want to explore all
the versions of your dependencies while developing. For this reason, you may
want to reproduce a known-working set of dependencies. If you use:

```
opam lock .
```

opam will check what version of the dependencies are installed in your current
switch, and explicit them in `*.opam.locked` files. `opam lock` is a plugin at
the moment, but will get automatically installed when needed.

Then, assuming you checked these files into version control, any user can do

```
opam install . --deps-only --locked
```

to instruct opam to reproduce the same build environment (the `--locked` option
is also available to `opam switch create`, to make things easier).

The generated lock-files will also contain added constraints to reproduce the
presence/absence of optional dependencies, and reproduce the appropriate
dependency pins using `pin-depends`. Add the `--direct-only` option if you don't
want to enforce the versions of all recursive dependencies, but only direct
ones.
