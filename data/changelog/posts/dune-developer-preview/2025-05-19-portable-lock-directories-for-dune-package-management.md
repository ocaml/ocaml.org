---
title: "Dune Developer Preview: Portable Lock Directories for Dune Package Management"
tags: [dune, developer-preview]
---

_Discuss this post on [Discuss](https://discuss.ocaml.org/t/portable-lock-directories-for-dune-package-management/16669)!_

We've recently made a change to how lock directories work in the [Dune Developer
Preview](https://preview.dune.build/).

Previously when Dune would solve dependencies for a project and generate a lock
directory, the lock directory would be specialized for the computer where it was
generated, with no guarantee it would work on a different computer. This posed a
problem for checking lock directories into version control for projects with
multiple developers, since one developer might lock the project on their Mac,
say, only for another developer on Linux to be unable to build it due to its
MacOS-specific lock directory.

This post is to announce that Dune now supports generating _portable_ lock
directories; a lock directory generated on one computer will now contain a
dependency solution for a range of different computers, making it safe to check
lock directories into version control.

## Technical Details

In Opam the dependencies of a package can be different depending on properties
of the computer where the package is being installed. A package might have a
different set of dependencies when being installed on MacOS verses Linux versus
Windows, or the dependencies might vary depending on the CPU architecture. It's
even possible (though quite rare in practice) for the dependencies of a package
to vary between operating system distributions, or even operating system
versions.

This expressive power makes Opam very flexible as it allows packages to be
specialized for the environment where they will be installed. The drawback of
this approach is that there might not be a single solution to a dependency
problem that works everywhere. Each combination of
OS/architecture/distro/version could, in theory, require a different dependency
solution. There are way too many combinations of those properties to run Dune's
dependency solver once for each combination in a reasonable amount of time.
Instead we elected to compromise and have Dune only generate a solution for
common platforms by default, while allowing users to specify a custom list of
platforms to solve for in their `dune-workspace` file.

Lockfiles now look a little different to account for the fact that they now
contain multiple different platform-specific dependency solutions. For example,
formerly, the lockfile for the `ocaml-compiler` package on an x86 machine running
Windows, you might have had a `depends` field like:

```scheme
(depends arch-x86_64 system-mingw mingw-w64-shims flexdll)
```

Most of these dependencies are specific to Windows; it's unlikely that you'll be
able to install any of these dependencies on Linux or MacOS.

With the portable lock directories feature enabled, this field now might look like:

```scheme
(depends
 (choice
  ((((arch x86_64)
     (os linux))
    ((arch arm64)
     (os linux))
    ((arch x86_64)
     (os macos)
     (os-distribution homebrew)
     (os-family homebrew))
    ((arch arm64)
     (os macos)
     (os-distribution homebrew)
     (os-family homebrew)))
   ())
  ((((arch x86_64)
     (os win32)
     (os-distribution cygwin)
     (os-family windows)))
   (arch-x86_64 system-mingw mingw-w64-shims flexdll))
  ((((arch arm64)
     (os win32)
     (os-distribution cygwin)
     (os-family windows)))
   (system-mingw mingw-w64-shims flexdll))))
```

This new syntax is similar to a match-statement, listing the dependencies for
each platform for which Dune's solver ran. You can change the platforms Dune
will solve for by adding something like this to `dune-workspace`:

```scheme
(lock_dir
 (solve_for_platforms
  ((arch arm64)
   (os openbsd))
  ((arch x86_32)
   (os win32))))
```

After running `dune pkg lock` again, the lockfile for `ocaml-compiler` will be
updated with these dependencies:

```scheme
(depends
 (choice
  ((((arch arm64) (os openbsd))) ())
  ((((arch x86_32)
     (os win32)))
   (system-mingw ocaml-option-bytecode-only flexdll))))
```

A few other fields of lockfiles now also use the new syntax. Dune lockfiles
contain the commands needed to build and install each package, as well as the
names of any system packages needed by the Opam package, and each of these fields
can also have platform-specific values.

Lockfile names now include the version number of the package. The
`ocaml-compiler` package used to have a lockfile named `ocaml-compiler.pkg` but
now has a name like `ocaml-compiler.5.3.0.pkg` instead. This is because it's
possible that different platforms may require different versions of the same
package in the dependency solution, so the lock directory needs to be able to
contain multiple lockfiles for the same package without them colliding on
filename.

## How do I get it?

This feature is live in the latest version of the [Dune Developer
Preview](https://preview.dune.build/). Follow the instructions on that page to
install a version of Dune with this feature. With portable lock directories
enabled, Dune will temporarily remain backwards compatible with the original
lock directory format, though support will likely be dropped at some point.
Generate a new lock directory by running `dune pkg lock`. You'll know your lock
directory is portable if each file inside it has a version number in its
filename.

Happy reproducible building!
