---
title: "Last stretch! Repository upgrade and opam 2.0.0 roadmap"
authors: [ "Raja Boujbel", "Louis Gesbert"]
date: "2018-08-02"
description: "opam respository upgrade and opam 2.0.0 roadmap"
---

A few days ago, we released [opam 2.0.0~rc4](https://opam.ocaml.org/blog/opam-2-0-0-rc4/), and explained that this final release candidate was expected be promoted to 2.0.0, in sync with an upgrade to the [opam package repository](https://github.com/ocaml/opam-repository). So here are the details about this!

## If you are an opam user, and don't maintain opam packages

- You are encouraged to [upgrade](https://opam.ocaml.org/blog/opam-2-0-0-rc4/)) as soon as comfortable, and get used to the [changes and new features](https://opam.ocaml.org/2.0-preview/doc/Upgrade_guide.html)

- All packages installing in opam 1.2.2 should exist and install fine on 2.0.0~rc4 (if you find one that doesn't, [please report](https://github.com/ocaml/opam/issues)!)

- If you haven't updated by **September 17th**, the amount of updates and new packages you receive may become limited[¹](#foot-1).

## So what will happen on September 17th ?

- Opam 2.0.0~rc4 gets officially released as 2.0.0

- On the `ocaml/opam-repository` Github repository, a 1.2 branch is forked, and the 2.0.0 branch is merged into the master branch

- From then on, pull-requests to `ocaml/opam-repository` need to be in 2.0.0 format. Fixes to the 1.2 repository can be merged if important: pulls need to be requested against the 1.2 branch in that case.

- The opam website shows the 2.0.0 repository by default (https://opam.ocaml.org/2.0-preview/ becomes https://opam.ocaml.org/)

- The http repositories for 1.2 and 2.0 (as used by `opam update`) are accordingly moved, with proper redirections put in place

## Advice for package maintainers

- Until September 17th, pull-requests filed to the master branch of `ocaml/opam-repository` need to be in 1.2.2 format

- The CI checks for all PRs ensure that the package passes on both 1.2.2 and 2.0.0. After the 17th of september, only 2.0.0 will be checked (and 1.2.2 only if relevant fixes are required).

- The 2.0.0 branch of the repository will contain the automatically updated 2.0.0 version of your package definitions

- You can publish 1.2 packages while using opam 2.0.0 by installing `opam-publish.0.3.5` (running `opam pin opam-publish 0.3.5` is recommended)

- You should only need to keep an opam 1.2 installation for more complex setups (multiple packages, or if you need to be able to test the 1.2 package installations locally). In this case you might want to use an alias, _e.g._ `alias opam.1.2="OPAMROOT=$HOME/.opam.1.2 ~/local/bin/opam.1.2`. You should also probably disable opam 2.0.0's automatic environment update in that case (`opam init --disable-shell-hook`)

- `opam-publish.2.0.0~beta` has a fully revamped interface, and many new features, like filing a single PR for multiple packages. It files pull-request **in 2.0 format only**, however. At the moment, it will file PR only to the 2.0.0 branch of the repository, but pushing 1.2 format packages to master is still preferred until September 17th.

- It is also advised to keep in-source opam files in 1.2 format until that date, so as not to break uses of `opam pin add --dev-repo` by opam 1.2 users. The small `opam-package-upgrade` plugin can be used to upgrade single 1.2 `opam` files to 2.0 format.

- [`ocaml-ci-script`](https://github.com/ocaml/ocaml-ci-scripts) already switched to opam 2.0.0. To keep testing opam 1.2.2, you can set the variable `OPAM_VERSION=1.2.2` in the `.travis.yml` file.

## Advice for custom repository maintainers

- The `opam admin upgrade` command can be used to upgrade your repository to 2.0.0 format. We recommand using it, as otherwise clients using opam 2.0.0 will do the upgrade locally every time. Add the option `--mirror` to continue serving both versions, with automatic redirects.

- It's your place to decide when/if you want to switch your base repository to 2.0.0 format. You'll benefit from many new possibilities and safety features, but that will exclude users of earlier opam versions, as there is no backwards conversion tool.



<a id="foot-1">¹</a> Sorry for the inconvenience. We'd be happy if we could keep maintaining the 1.2.2 repository for more time; repository maintainers are doing an awesome job, but just don't have the resources to maintain both versions in parallel.
