---
title: "OPAM 1.2 and Travis CI"
authors: [ "Thomas Gazagnaire" ]
date: 2014-12-18T00:00:00-00:00
description: "OPAM 1.2 and Travis CI"
source:
  name: Opam blog
  url: ""
  tag: "personnal blog"
---

The [new pinning feature][pin] of OPAM 1.2 enables new interesting
workflows for your day-to-day development in OCaml projects. I will
briefly describe one of them here: simplifying continuous testing with
[Travis CI][travis] and
[GitHub][github].

## Creating an `opam` file

As explained in the [previous post][pin], adding an `opam` file at the
root of your project now lets you pin development versions of your
project directly. It's very easy to create a default template with OPAM 1.2:

```
$ opam pin add <my-project-name> . --edit
[... follow the instructions ...]
```

That command should create a fresh `opam` file; if not, you might
need to fix the warnings in the file by re-running the command. Once
the file is created, you can edit it directly and use `opam lint` to
check that is is well-formed.

If you want to run tests, you can also mark test-only dependencies with the
`{test}` constraint, and add a `build-test` field. For instance, if you use
`oasis` and `ounit`, you can use something like:

```opam
build: [
  ["./configure" "--prefix=%{prefix}%" "--%{ounit:enable}%-tests"]
  [make]
]
build-test: [make "test"]
depends: [
  ...
  "ounit" {test}
  ...
]
```

Without the `build-test` field, the continuous integration scripts
will just test the compilation of your project for various OCaml
compilers.
OPAM doesn't run tests by default, but you can make it do so by
using `opam install -t` or setting the `OPAMBUILDTEST`
environment variable in your local setup.

## Installing the Travis CI scripts

<img style="float:right; padding: 5px"
     src="https://travis-ci.com/img/travis-mascot-200px.png"
     width="200px">
</img>

[Travis CI][travis] is a free service that enables continuous testing on your
GitHub projects. It uses Ubuntu containers and runs the tests for at most 50
minutes per test run.

To use Travis CI with your OCaml project, you can follow the instructions on
<https://github.com/ocaml/ocaml-travisci-skeleton>. Basically, this involves:

- adding
  [.travis.yml](https://github.com/ocaml/ocaml-travisci-skeleton/blob/master/.travis.yml)
  at the root of your project. You can tweak this file to test your
  project with different versions of OCaml. By default, it will use
  the latest stable version (today: 4.02.1, but it will be updated for
  each new compiler release).  For every OCaml version that you want to
  test (supported values for `<VERSION>` are `3.12`, `4.00`,
  `4.01` and `4.02`) add the line:

```yml
env:
 - OCAML_VERSION=<VERSION>
```


- signing in at [TravisCI](https://travis-ci.org/) using your GitHub account and
  enabling the tests for your project (click on the `+` button on the
  left pane).

And that's it, your project now has continuous integration, using the OPAM 1.2
pinning feature and Travis CI scripts.

## Testing Optional Dependencies

By default, the script will not try to install the [optional
dependencies][depopts] specified in your `opam` file. To do so, you
need to manually specify which combination of optional dependencies
you want to tests using the `DEPOPTS` environment variable. For
instance, to test `cohttp` first with `lwt`, then with `async` and
finally with both `lwt` and `async` (but only on the `4.01` compiler)
you should write:

```yml
env:
   - OCAML_VERSION=latest DEPOPTS=lwt
   - OCAML_VERSION=latest DEPOPTS=async
   - OCAML_VERSION=4.01   DEPOPTS="lwt async"
```

As usual, your contributions and feedback on this new feature are [gladly welcome][issues].

[pin]: https://opam.ocaml.org/blog/opam-1-2-pin/
[travis]: https://travis-ci.org/
[github]: https://github.com/
[issues]: https://github.com/ocaml/ocaml-travisci-skeleton/issues/
[depopts]: https://opam.ocaml.org/doc/manual/dev-manual.html#sec9
