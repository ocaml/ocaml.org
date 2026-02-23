---
id: "publishing-packages-w-dune"
title: "Publishing a Package with Dune"
short_title: "Publishing a Package"
description: |
  How to publish a package with Dune
category: "Libraries & Packages"
language: English
---

> **TL;DR**
>
> Create a `CHANGES.md` file and run `dune-release bistro`.

The opam package manager may differ from the package manager you're used to. In order to ensure the highest stability of the ecosystem, each package publication goes through two processes:

- An automated CI pipeline which tests if your package installs using multiple distributions and multiple OCaml compiler versions. It will also check that your new release does not break your reverse dependencies (those packages that require your package). A lower-bound check also ensures that your package installs with the lowest version of your package's dependencies.
- A manual review of the package metadata by an opam-repository maintainer.

This process starts with a PR to the opam-repository, with the addition of a file for the version of the package to publish. The file contains information such as the package name, description, VCS repository, and most importantly, the URL the sources can be downloaded from.

If everything looks good and the CI build passes, the PR is merged and the package becomes available in opam after an `opam update` to update the opam-repository.

If there is anything to change, an opam-repository maintainer will comment on the PR with some recommendations.

This is a heavy process, but hopefully, all of it is completely automated on the user side. The recommended way to publish a package is to use the `dune-release` command (provided by the opam package `dune-release`).

Once you're ready to publish your package on opam, simply create a `CHANGES.md` file with the following format:

```text
# <version>

<release note>

# <older version>

<release note>
```

and run `dune-release bistro`.

Dune Release will run some verification (such as running the tests, linting the opam file, etc.) and will open a PR for you on `opam-repository`. From there, all you have to do is wait for the PR to be merged, or for a maintainer to review your package publication.
