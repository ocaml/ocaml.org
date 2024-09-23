---
id: "dune-developer-preview"
title: "Dune Developer Preview"
description: Description about the goals and the links for the Developer Preview Program
category: "Dune"
---

## Context of the Dune Developer Preview

Since 2012, [opam](https://opam.ocaml.org) has been the default system to
manage package in the OCaml ecosystem. It allows interacting with a central
package repository called `opam-repository`. It contains around 5000 packages of
the OCaml ecosystem.

With time, the OCaml Community has suggested having a unified tool to manage an
OCaml project from build to dependency management. One of the principal
objectives of the [OCaml Platform
roadmap](/tools/platform-roadmap#g1-dune-is-the-frontend-of-the-ocaml-platform)
is to have a unified Fronted for all of this feature. `Dune` - the recommended
OCaml build system - has endorsed this responsibility.

In this context, the Dune developers have decided to provide an "early" access
version of the functionalities developed to achieve this goal to get feedback
from the users regularly.

If you want to help us improve `dune`, you can either open an issue on
[ocaml/dune](https://github.com/ocaml/dune/issues/new/choose) if you face a bug
or fill the [Google Form
survey](https://docs.google.com/forms/d/e/1FAIpQLSda-mOTHIdATTt_e9dFmNgUCy-fD55Qzr3bGGsxpfY_Ecfyxw/viewform?usp=sf_link)
to give us feedback about your experience with it.

## Access the Dune Developer Preview Binaries

We build the binaries on a daily basis using GitHub Actions in the
[dune-binary-distribution](https://github.com/tarides/dune-binary-distribution)
repository. The builds are done on the [dune](https://github.com/ocaml/dune)
`main` branch. They activate all the preview features by default (package
management, ...).

To download the binaries, follow the instructions on
[dune.ci.dev](https://dune.ocaml.org).

Note these binaries are unstable as they are built directly from the `main`
branch. Use at your **own risks**.

## How-to Start With Dune Package Management

To start with Dune Package Management you need to start a project with `dune
init proj` or update your already existing `dune-project` file to
[generate](https://dune.readthedocs.io/en/stable/howto/opam-file-generation.html)
opam files. Using package management is simple: you need to generate a lock
file and `dune` will know it has to use package management. Simply run the
command `dune pkg lock`. It will take time to solve the dependencies and
install `ocaml` the first time you run it. Once completed, you can run `dune
build`, and it automatically downloads and build the missing dependencies. And
voilà! To know more about it, you can follow [this
tutorial](https://dune.readthedocs.com/TODO) from the `dune` documentation
