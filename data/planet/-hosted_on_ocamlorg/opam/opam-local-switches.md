---
title: "new opam features: local switches"
authors: [ "Louis Gesbert" ]
date: 2017-04-27T00:00:00-00:00
description: "Presentation of the local switches feature introduced in opam 2.0"
source:
  name: Opam blog
  url: ""
  tag: "personnal blog"
---

Among the areas we wanted to improve on for opam 2.0 was the handling of
_switches_. In opam 1.2, they are simply accessed by a name (the OCaml version
by default), and are always stored into `~/.opam/<name>`. This is fine, but can
get a bit cumbersome when many switches are in presence, as there is no way to
sort them or associate them with a given project.

> ### A reminder about _switches_
> 
> For those unfamiliar with it, switches, in opam, are independent prefixes with
> their own compiler and set of installed packages. The `opam switch` command
> allows to create and remove switches, as well as select the currently active
> one, where operations like `opam install` will operate.
> 
> Their uses include easily juggling between versions of OCaml, or of a library,
> having incompatible packages installed separately but at the same time, running
> tests without damaging your "main" environment, and, quite often, separation of
> environment for working on different projects.
>
> You can also select a specific switch for a single command, with
>
>     opam install foo --switch other
>
> or even for a single shell session, with
>
>     eval $(opam env --switch other)

What opam 2.0 adds to this is the possibility to create so-called _local
switches_, stored below a directory of your choice. This gets users back in
control of how switches are organised, and wiping the directory is a safe way to
get rid of the switch.

### Using within projects

This is the main intended use: the user can define a switch within the source of
a project, for use specifically in that project. One nice side-effect to help
with this is that, if a "local switch" is detected in the current directory or a
parent, opam will select it automatically. Just don't forget to run `eval $(opam
env)` to make the environment up-to-date before running `make`.

### Interface

The interface simply overloads the `switch-name` arguments, wherever they were
present, allowing directory names instead. So for example:

    cd ~/src/project
    opam switch create ./

will create a local switch in the directory `~/src/project`. Then, it is for
example equivalent to run `opam list` from that directory, or `opam list
--switch=~/src/project` from anywhere.

Note that you can bypass the automatic local-switch selection if needed by using
the `--switch` argument, by defining the variable `OPAMSWITCH` or by using `eval
$(opam env --switch <name>)`

### Implementation

In practice, the switch contents are placed in a `_opam/` subdirectory. So if
you create the switch `~/src/project`, you can browse its contents at
`~/src/project/_opam`. This is the direct prefix for the switch, so e.g.
binaries can be found directly at `_opam/bin/`: easier than searching the opam
root! The opam metadata is placed below that directory, in a `.opam-switch/`
subdirectory.

Local switches still share the opam root, and in particular depend on the
repositories defined and cached there. It is now possible, however, to select
different repositories for different switches, but that is a subject for another
post.

Finally, note that removing that `_opam` directory is handled transparently by
opam, and that if you want to share a local switch between projects, symlinking
the `_opam` directory is allowed.

### Current status

This feature has been present in our dev builds for a while, and you can already
use it in the
[current beta](https://github.com/ocaml/opam/releases/tag/2.0.0-beta2).

### Limitations and future extensions

It is not, at the moment, possible to move a local switch directory around,
mainly due to issues related to relocating the OCaml compiler.

Creating a new switch still implies to recompile all the packages, and even the
compiler itself (unless you rely on a system installation). The projected
solution is to add a build cache, avoiding the need to recompile the same
package with the same dependencies. This should actually be possible with the
current opam 2.0 code, by leveraging the new hooks that are made available. Note
that relocation of OCaml is also an issue for this, though.

Editing tools like `ocp-indent` or `merlin` can also become an annoyance with
the multiplication of switches, because they are not automatically found if not
installed in the current switch. But the `user-setup` plugin (run `opam
user-setup install`) already handles this well, and will access `ocp-indent` or
`tuareg` from their initial switch, if not found in the current one. You will
still need to install tools that are tightly bound to a compiler version, like
`merlin` and `ocp-index`, in the switches where you need them, though.

> NOTE: this article is cross-posted on
> [opam.ocaml.org](https://opam.ocaml.org/blog/) and
> [ocamlpro.com](http://www.ocamlpro.com/category/blog/). Please head to the
> latter for the comments!
