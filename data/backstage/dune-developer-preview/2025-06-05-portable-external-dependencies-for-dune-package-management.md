---
title: "Dune Developer Preview: Portable External Dependencies for Dune Package Management"
tags: [dune, developer-preview]
---

_Discuss this post on
[discuss](https://discuss.ocaml.org/t/portable-external-dependencies-for-dune-package-management/16767)!_

Dune lock directories record the names of any system packages needed to build
projects or their dependencies. Currently this information is not portable
because Dune only stores the names of system packages within the package
repository on the machine where the lock directory is generated. We've recently
changed how Dune stores the names of system packages in the [Dune Developer
Preview](https://preview.dune.build?utm_source=ocaml.org&utm_medium=referral&utm_campaign=changelog) so that the names of packages in all
known package repositories are stored. This allows a lock directory generated
on one machine to be used on a different machine.

## Background on `depexts` in Opam

A system package, or external dependency, or `depext` as I'll refer to them
from now on, is a piece of software which can't be installed by Opam directly,
but which must be installed in order for some Opam package to be built or for
code in an Opam package to be executed at runtime. These packages must be
installed by the system package manager, or by some other non-Opam means such
as manually building and installing the package from source. Common types of
`depext` are build tools such as the `pkg-config` command, often run to
determine linker flags while building a package, or shared libraries such as
`libgtk`, which an OCaml project might link against to create GUIs.

Opam usually installs `depexts` automatically. Opam knows how to invoke many
different system package managers (such as `apt` or `pacman`), so when
installing a package with `depexts` Opam can run the commands appropriate to the
current system to install the required packages using the system's package
manager. For this to work, Opam needs to know the name of the package within the
package repository appropriate to the current system, and these names can vary
from system to system. For example the `pkg-config` command is in a package
named simply `pkg-config` in the `apt` package manager on Ubuntu/Debian
systems, whereas in the third-party `homebrew` package manager on MacOS it's in
a package named `pkgconf`. In order to determine the right package name for the
current system, the package metadata for Opam packages with `depexts` contains
a list of all the different known package names along with the conditions under
which that name is correct. Here is that list for the `conf-pkg-config` Opam
package:

```opam
depexts: [
  ["pkg-config"] {os-family = "debian" | os-family = "ubuntu"}
  ["pkgconf"] {os-distribution = "arch"}
  ["pkgconf-pkg-config"] {os-family = "fedora"}
  ["pkgconfig"] {os-distribution = "centos" & os-version <= "7"}
  ["pkgconf-pkg-config"] {os-distribution = "mageia"}
  ["pkgconfig"] {os-distribution = "rhel" & os-version <= "7"}
  ["pkgconfig"] {os-distribution = "ol" & os-version <= "7"}
  ["pkgconf"] {os-distribution = "alpine"}
  ["pkg-config"] {os-distribution = "nixos"}
  ["pkgconf"] {os = "macos" & os-distribution = "homebrew"}
  ["pkgconfig"] {os = "macos" & os-distribution = "macports"}
  ["pkgconf"] {os = "freebsd"}
  ["pkgconf-pkg-config"] {os-distribution = "rhel" & os-version >= "8"}
  ["pkgconf-pkg-config"] {os-distribution = "centos" & os-version >= "8"}
  ["pkgconf-pkg-config"] {os-distribution = "ol" & os-version >= "8"}
  ["system:pkgconf"] {os = "win32" & os-distribution = "cygwinports"}
  ["pkgconf"] {os-distribution = "cygwin"}
]
```

## `depexts` in Dune

Dune doesn't install `depexts` automatically as the Dune developers are a little
nervous about running commands that would modify the global system state. This
may change at some point, but for now Dune only provides support for listing the
names of `depexts`, leaving it up to the user to install them as they see fit.

The `dune show depexts` command can be used to list the `depexts` of a project.
For that command to work the project must have a lock directory. Here's an
example of listing the `depexts` of a project:

```text
$ dune pkg lock
...
$ dune show depexts
libao
libffi
pkgconf
sdl2
```

I ran these commands on a Mac with homebrew installed, so the package names are
from the homebrew package repo. Each package listed there is one of the
`depexts` of a package whose lockfile appears in the project's lock directory.
Let's look at how this information is stored. Using `pkg-config` as an example:

```text
$ cat dune.lock/conf-pkg-config.pkg
(version 4)

(build
 (run pkgconf --version))

(depexts pkgconf)
```

The relevant part for us is the `depexts` field. The current released version of
Dune only stores the package's `depexts` for the system where `dune pkg lock`
was run. The command `dune show depexts` simply concatenates the `depexts`
fields from each lockfile in the lock directory.

When thinking about portable lock directories I always like to imagine what the
experience would be using Dune for a project where the lock directory is checked
into version control. I frequently switch between using two different machines
for development - one running Linux and the other running MacOS. If I was to
check in the lock directory I just generated on my Mac, and then check it out on
Linux and continue development, `dune show depexts` would show me a list of
packages for the wrong system!

## Portable `depexts` in Dune

To make `depexts` portable, one's first instinct might be to use the same
approach as taken with the `depends` field outlined in a [previous
post](https://ocaml.org/changelog/2025-05-19-portable-lock-directories-for-dune-package-management),
listing the `depexts` for each platform for which the solver was run. Indeed
such a change was added to the Dune Developer Preview when we first introduced
portable lock directories, however we quickly realized a problem.

The `depends`, `build`, and `install` fields of a package rarely vary between OS
distribution. It's reasonably common for those fields to be different on
different OSes, but very rare for them to also be different on different OS
_distributions_. As such, it's expected that users will elect to solve their
projects for each common OS, but there would be little value in solving projects
for each OS distro. In fact solving for multiple distros would slow down solving
and bloat the lock directory, and users would somehow need to come up with a
definitive list of distros to solve for.

_But_ the `depexts` field is highly-dependent on the OS distro since package
names are specific to the package repository for a particular distro. Recall
that the `depexts` field in Opam package metadata lists package names along with
the conditions under which that package name should be used, e.g.:

```opam
["pkg-config"] {os-family = "debian" | os-family = "ubuntu"}
["pkgconf"] {os-distribution = "arch"}
["pkgconf-pkg-config"] {os-family = "fedora"}
["pkgconfig"] {os-distribution = "centos" & os-version <= "7"}
```

These conditions almost always involve the name of the OS distro, and to make
matters worse they also sometimes involve the OS _version_, as packages can
change their names between different versions of the same OS. Evaluating these
conditions at solve time for platforms with no distro or version specified
tends to result in lockfiles with _no_ `depexts` at all, since all the
conditions evaluate to `false`.

The use case we have in mind for `depexts` in Dune is that a user will solve
their project coarsely, usually just for each common OS with no consideration
for distribution or version. Then when they run `dune show depexts`, the
`depexts` will be listed using names appropriate to the current machine. This
means Dune needs to store enough metadata about `depexts` to compute
system-specific `depext` names at a later time. This means storing the same
names and conditions as are currently stored in Opam files, and deferring
evaluation of the conditions until as late as possible, such as right when
`dune show depexts` is run.

The latest version of the Dune Developer Preview does just this; translating the
`depexts` field from each package's Opam file into a Dune-friendly S-expression.
After this change, the `depexts` field of `conf-pkg-config`'s lockfile is:

```text
$ cat dune.lock/conf-pkg-config.4.pkg
...
(depexts
 ((pkg-config)
  (or_absorb_undefined_var
   (= %{os_family} debian)
   (= %{os_family} ubuntu)))
 ((pkgconf)
  (= %{os_distribution} arch))
 ((pkgconf-pkg-config)
  (= %{os_family} fedora))
 ((pkgconfig)
  (and_absorb_undefined_var
   (= %{os_distribution} centos)
   (<= %{os_version} 7)))
 ((pkgconf-pkg-config)
  (= %{os_distribution} mageia))
 ((pkgconfig)
  (and_absorb_undefined_var
   (= %{os_distribution} rhel)
   (<= %{os_version} 7)))
 ((pkgconfig)
  (and_absorb_undefined_var
   (= %{os_distribution} ol)
   (<= %{os_version} 7)))
 ((pkgconf)
  (= %{os_distribution} alpine))
 ((pkg-config)
  (= %{os_distribution} nixos))
 ((pkgconf)
  (and_absorb_undefined_var
   (= %{os} macos)
   (= %{os_distribution} homebrew)))
 ((pkgconfig)
  (and_absorb_undefined_var
   (= %{os} macos)
   (= %{os_distribution} macports)))
 ((pkgconf)
  (= %{os} freebsd))
 ((pkgconf-pkg-config)
  (and_absorb_undefined_var
   (= %{os_distribution} rhel)
   (>= %{os_version} 8)))
 ((pkgconf-pkg-config)
  (and_absorb_undefined_var
   (= %{os_distribution} centos)
   (>= %{os_version} 8)))
 ((pkgconf-pkg-config)
  (and_absorb_undefined_var
   (= %{os_distribution} ol)
   (>= %{os_version} 8)))
 ((system:pkgconf)
  (and_absorb_undefined_var
   (= %{os} win32)
   (= %{os_distribution} cygwinports)))
 ((pkgconf)
  (= %{os_distribution} cygwin)))
```

That's a 1:1 translation of the `depexts` field from `conf-pkg-config`'s Opam
file. There's enough information there so that the appropriate package name can
be computed on demand rather than just at solve time.

This bring us a step closer to a world where Dune users can check their lock
directories into version control with confidence that their builds are
reproducible across different platforms. To try out the latest version of the
Dune Developer Preview, go to [preview.dune.build](https://preview.dune.build?utm_source=ocaml.org&utm_medium=referral&utm_campaign=changelog).
