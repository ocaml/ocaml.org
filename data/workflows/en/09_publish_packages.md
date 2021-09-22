---
title: "Publishing packages"
---

> **TL;DR**
> 
> Create a `CHANGES.md` file and run `dune-release bistro`.

The opam package manager may differ from the package manager you're used to. In order to ensure the highest stability of the ecosystem, each package publication goes through two processes:

- An automated CI pipeline with different combinasion of version constraint to ensure that the package really works with the dependencies constraints it defines. (e.g. if the package defines a dependency on `base>=0.13.0`, does it really work with all version of base from `0.13.0` up to the latest version?)
- A manual review of the package metadata by the opam-repository maintainer.

This process starts with a PR to the opam-repository, with the addition of a file for the version of the package to publsh. The file contains information such as the package name, description, VCS repository, and most importantly, the URL the sources can be downloaded from.

If everything looks good and the CI build passes, the PR is merged and the package becomes available in opam after an `opam update` to update the opam-repository.

If there is anything to change, the opam-repository maintainer will comment on the PR with some recommendations.

This is a heavy process, but hopefully, all of it is completely automated on the user side. The recommended way to publish a package is `dune-release`.

Once you're ready to publish your package on opam, simply create a `CHANGES.md` file with the following format:

```
# <version>

<release note>

# <older version>

<release note>
```

and run `dune-release bistro`.

Dune Release will run some verification (such as running the tests, linting the opam file, etc.) and will open a PR for you on `opam-repository`. From there, all you have to do is wait for the PR to be merged, or for a maintainer to review your package publication.
