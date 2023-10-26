---
title: "opam 2.0 preview release!"
authors: [ "Louis Gesbert" ]
date: "2016-09-20"
description: "Release announcement for opam 2.0.0~preview"
tags: [opam, platform]
---

<style type="text/css"><!--
  .opam {font-family: Tahoma,Verdana,sans-serif; font-size: 110%; font-weight: lighter; line-height: 90.9%}
--></style>

We are pleased to announce a preview release for <span class="opam">opam</span> 2.0, with over 700
patches since [1.2.2](https://opam.ocaml.org/blog/opam-1-2-2-release/). Version
[2.0~alpha4](https://github.com/ocaml/opam/releases/2.0-alpha4) has just been
released, and is ready to be more widely tested.

This version brings many new features and changes, the most notable one being
that OCaml compiler packages are no longer special entities, and are replaced
by standard package definition files. This in turn means that <span class="opam">opam</span> users have
more flexibility in how switches are managed, including for managing non-OCaml
environments such as [Coq](https://web.archive.org/web/20170410035834/http://coq.io/opam) using the same familiar tools.

## A Few Highlights

This is just a sample, see the full
[changelog](https://github.com/ocaml/opam/blob/2.0-alpha4/CHANGES) for more:

- **Sandboxed builds:** Command wrappers can be configured to, for example,
  restrict permissions of the build and install processes using Linux
  namespaces, or run the builds within Docker containers.

- **Compilers as packages:** This brings many advantages for <span class="opam">opam</span> workflows,
  such as being able to upgrade the compiler in a given switch, better tooling for
  local compilers, and the possibility to define `coq` as a compiler or even
  use <span class="opam">opam</span> as a generic shell scripting engine with dependency tracking.

- **Local switches:** Create switches within your projects for easier
  management. Simply run `opam switch create <directory> <compiler>` to get
  started.

- **Inplace build:** Use <span class="opam">opam</span> to build directly from
  your source directory. Ensure the package is pinned locally then run `opam
  install --inplace-build`.

- **Automatic file tracking:**: <span class="opam">opam</span> now tracks the files installed by packages
  and is able to cleanly remove them when no existing files were modified.
  The `remove:` field is now optional as a result.

- **Configuration file:** This can be used to direct choices at `opam init`
  automatically (e.g. specific repositories, wrappers, variables, fetch
  commands, or the external solver). This can be used to override all of <span class="opam">opam</span>'s
  OCaml-related settings.

- **Simpler library:** the OCaml API is completely rewritten and should make it
  much easier to write external tools and plugins. Existing tools will need to be
  ported.

- **Better error mitigation:** Through clever ordering of the shell actions and
  separation of `build` and `install`, most build failures can keep your current
  installation intact, not resulting in removed packages anymore.

## Roll out

You are very welcome to try out the alpha, and report any issues. The repository
at `opam.ocaml.org` will remain in 1.2 format (with a 2.0 mirror at
`opam.ocaml.org/2.0~dev` in sync) until after the release is out, which means
the extensions can not be used there yet, but you are welcome to test on local
or custom repositories, or package pinnings. The reverse translation (2.0 to
1.2) is planned, to keep supporting 1.2 installations after that date.

The documentation for the new version is available at
https://opam.ocaml.org/doc/2.0/. This is still work in progress, so please do ask
if anything is unclear.

## Interface changes

Commands `opam switch` and `opam list` have been rehauled for more consistency
and flexibility: the former won't implicitly create new switches unless called
with the `create` subcommand, and `opam list` now allows to combine filters and
finely specify the output format. They may not be fully backwards compatible, so
please check your scripts.

Most other commands have also seen fixes or improvements. For example, <span class="opam">opam</span>
doesn't forget about your set of installed packages on the first error, and the
new `opam install --restore` can be used to reinstall your selection after a
failed upgrade.

## Repository changes

While users of <span class="opam">opam</span> 1.2 should feel at home with the changes, the 2.0 repository
and package formats are not compatible. Indeed, the move of the compilers to
standard packages implies some conversions, and updates to the relationships
between packages and their compiler. For example, package constraints like

    available: [ ocaml-version >= "4.02" ]

are now written as normal package dependencies:

    depends: [ "ocaml" {>= "4.02"} ]

To make the transition easier,
- upgrade of a custom repository is simply a matter of running `opam-admin
  upgrade-format` at its root;
- the official repository at `opam.ocaml.org` already has a 2.0 mirror, to which
  you will be automatically redirected;
- packages definition are automatically converted when you pin a package.

Note that the `ocaml` package on the official repository is actually a wrapper
that depends on one of `ocaml-base-compiler`, `ocaml-system` or
`ocaml-variants`, which contain the different flavours of the actual compiler.
It is expected that it may only get picked up when requested by package
dependencies.

## Package format changes

The <span class="opam">opam</span> package definition format is very similar to before, but there are
quite a few extensions and some changes:

- it is now mandatory to separate the `build:` and `install:` steps (this allows
  tracking of installed files, better error recovery, and some optional security
  features);
- the url and description can now optionally be included in the `opam` file
  using the section `url {}` and fields `synopsis:` and `description:`;
- it is now possible to have dependencies toggled by globally-defined <span class="opam">opam</span>
  variables (_e.g._ for a dependency needed on some OS only), or even rely on
  the package information (_e.g._ have a dependency at the same version);
- the new `setenv:` field allows packages to export updates to environment
  variables;
- custom fields `x-foo:` can be used for extensions and external tools;
- allow `"""` delimiters around unescaped strings
- `&` is now parsed with higher priority than `|`
- field `ocaml-version:` can no longer be used
- the `remove:` field should not be used anymore for simple cases (just removing
  files)

## Let's go then -- how to try it ?

First, be aware that you'll be prompted to update your `~/.opam` to 2.0 format
before anything else, so if you value it, make a backup. Or just export
`OPAMROOT` to test the alpha on a temporary opam root.

Packages for opam 2.0 are already in the opam repository, so if you have a
working opam installation of opam (at least 1.2.1), you can bootstrap as easily
as:

    opam install opam-devel

This doesn't install the new opam to your PATH within the current opam root for
obvious reasons, so you can manually install it as e.g. "opam2" using:

    sudo cp $(opam config var "opam-devel:lib")/opam /usr/local/bin/opam2

You can otherwise install as usual:
- Using pre-built binaries (available for OSX and Linux x86, x86_64, armhf) and
  our install script:

    wget https://raw.github.com/ocaml/opam/2.0-alpha4-devel/shell/opam_installer.sh -O - | sh -s /usr/local/bin

  Equivalently,
  [pick your version](https://github.com/ocaml/opam/releases/2.0-alpha4) and
  download it to your PATH;

- Building from our inclusive source tarball:
  [download here](https://github.com/ocaml/opam/releases/download/2.0-alpha4/opam-full-2.0-alpha4.tar.gz)
  and build using `./configure && make lib-ext && make && make install` if you
  have OCaml >= 4.01 already available, `make cold && make install` otherwise;

- Or from [source](https://github.com/ocaml/opam/tree/2.0-alpha4), following the
  included instructions from the README. Some files have been moved around, so
  if your build fails after you updated an existing git clone, try to clean it
  up (`git clean -fdx`).
