---
title: "new opam features: more expressive dependencies"
authors: [ "Louis Gesbert" ]
date: 2017-05-11T00:00:00-00:00
description: "Presentation of the new opam 2.0 features"
source:
  name: Opam blog
  url: ""
  tag: "personnal blog"
---

This blog will cover yet another aspect of the improvements opam 2.0 has over opam 1.2. I may be a little more technical than previous issues, as it covers a feature directed specifically at packagers and repository maintainers, and regarding the package definition format.


### Specifying dependencies in opam 1.2

Opam 1.2 already has an advanced way of specifying package dependencies, using formulas on packages and versions, with the following syntax:

    depends: [
      "foo" {>= "3.0" & < "4.0~"}
      ( "bar" | "baz" {>= "1.0"} )
    ]

meaning that the package being defined depends on both package `foo`, within the `3.x` series, and one of `bar` or `baz`, the latter with version at least `1.0`. See [here](https://opam.ocaml.org/doc/Manual.html#PackageFormulas) for a complete documentation.

This only allows, however, dependencies that are static for a given package.

Opam 1.2 introduced `build`, `test` and `doc` "dependency flags" that could provide some specifics for dependencies (_e.g._ `test` dependencies would only be needed when tests were requested for the package). These were constrained to appear before the version constraints, _e.g._ `"foo" {build & doc & >= "3.0"}`.


### Extensions in opam 2.0

Opam 2.0 generalises the dependency flags, and makes the dependencies specification more expressive by allowing to mix _filters_, _i.e._ formulas based on opam variables, with the version constraints. If that formula holds, the dependency is enforced, if not, it is discarded.

This is documented in more detail [in the opam 2.0 manual](https://opam.ocaml.org/doc/2.0/Manual.html#Filteredpackageformulas).

Note also that, since the compilers are now packages, the required OCaml version is now expressed using this mechanism as well, through a dependency to the (virtual) package `ocaml`, _e.g._ `depends: [ "ocaml" {>= "4.03.0"} ]`. This replaces uses of the `available:` field and `ocaml-version` switch variable.

#### Conditional dependencies

This makes it trivial to add, for example, a condition on the OS to a given dependency, using the built-in variable `os`:

    depends: [ "foo" {>= "3.0" & < "4.0~" & os = "linux"} ]

here, `foo` is simply not needed if the OS isn't Linux. We could also be more specific about other OSes using more complex formulas:

    depends: [
      "foo" { "1.0+linux" & os = "linux" |
              "1.0+osx" & os = "darwin" }
      "bar" { os != "osx" & os != "darwin" }
    ]

Meaning that Linux and OSX require `foo`, respectively versions `1.0+linux` and `1.0+osx`, while other systems require `bar`, any version.


#### Dependency flags

Dependency flags, as used in 1.2, are no longer needed, and are replaced by variables that can appear anywhere in the version specification. The following variables are typically useful there:

- `with-test`, `with-doc`: replace the `test` and `doc` dependency flags, and are `true` when the package's tests or documentation have been requested
- likewise, `build` behaves similarly as before, limiting the dependency to a "build-dependency", implying that the package won't need to be rebuilt if the dependency changes
- `dev`: this boolean variable holds `true` on "development" packages, that is, packages that are bound to a non-stable source (a version control system, or if the package is pinned to an archive without known checksum). `dev` sources often happen to need an additional preliminary step (e.g. `autoconf`), which may have its own dependencies.

Use `opam config list` for a list of pre-defined variables. Note that the `with-test`, `with-doc` and `build` variables are not available everywhere: the first two are allowed only in the `depends:`, `depopts:`, `build:` and `install:` fields, and the latter is specific to the `depends:` and `depopts:` fields.

For example, the `datakit.0.9.0` package has:

```opam
depends: [
  ...
  "datakit-server" {>= "0.9.0"}
  "datakit-client" {with-test & >= "0.9.0"}
  "datakit-github" {with-test & >= "0.9.0"}
  "alcotest" {with-test & >= "0.7.0"}
]
```

When running `opam install datakit.0.9.0`, the `with-test` variable is set to `false`, and the `datakit-client`, `datakit-github` and `alcotest` dependencies are filtered out: they won't be required. With `opam install datakit.0.9.0 --with-test`, the `with-test` variable is true (for that package only, tests on packages not listed on the command-line are not enabled!). In this case, the dependencies resolve to:

```opam
depends: [
  ...
  "datakit-server" {>= "0.9.0"}
  "datakit-client" {>= "0.9.0"}
  "datakit-github" {>= "0.9.0"}
  "alcotest" {>= "0.7.0"}
]
```
which is treated normally.

#### Computed versions

It is also possible to use variables, not only as conditions, but to compute the version values: `"foo" {= var}` is allowed and will require the version of package `foo` corresponding to the value of variable `var`.

This is useful, for example, to define a family of packages, which are released together with the same version number: instead of having to update the dependencies of each package to match the common version at each release, you can leverage the `version` package-variable to mean "that other package, at the same version as current package". For example, `foo-client` could have the following:

    depends: [ "foo-core" {= version} ]

It is even possible to use variable interpolations within versions, _e.g._ specifying an os-specific version differently than above:

    depends: [ "foo" {= "1.0+%{os}%"} ]

this will expand the `os` variable, resolving to `1.0+linux`, `1.0+darwin`, etc.

Getting back to our `datakit` example, we could leverage this and rewrite it to the more generic:
```opam
depends: [
  ...
  "datakit-server" {>= version}
  "datakit-client" {with-test & >= version}
  "datakit-github" {with-test & >= version}
  "alcotest" {with-test & >= "0.7.0"}
]
```

Since the `datakit-*` packages follow the same versioning, this avoids having to rewrite the opam file on every new version, with a risk of error each time.

As a side note, these variables are consistent with what is now used in the [`build:`](https://opam.ocaml.org/doc/2.0/Manual.html#opamfield-build) field, and the [`build-test:`](https://opam.ocaml.org/doc/2.0/Manual.html#opamfield-build-test) field is now deprecated. So this other part of the same `datakit` opam file:
```opam
build:
  ["ocaml" "pkg/pkg.ml" "build" "--pinned" "%{pinned}%" "--tests" "false"]
build-test: [
  ["ocaml" "pkg/pkg.ml" "build" "--pinned" "%{pinned}%" "--tests" "true"]
  ["ocaml" "pkg/pkg.ml" "test"]
]
```
would now be preferably written as:
```opam
build: ["ocaml" "pkg/pkg.ml" "build" "--pinned" "%{pinned}%" "--tests" "%{with-test}%"]
run-test: ["ocaml" "pkg/pkg.ml" "test"]
```
which avoids building twice just to change the options.

#### Conclusion

Hopefully this extension to expressivity in dependencies will make the life of packagers easier; feedback is welcome on your personal use-cases.

Note that the official repository is still in 1.2 format (served as 2.0 at `https://opam.ocaml.org/2.0`, through automatic conversion), and will only be migrated a little while after opam 2.0 is finally released. You are welcome to experiment on custom repositories or pinned packages already, but will need a little more patience before you can contribute package definitions making use of the above to the [official repository](https://github.com/ocaml/opam-repository).

> NOTE: this article is cross-posted on [opam.ocaml.org](https://opam.ocaml.org/blog/) and [ocamlpro.com](http://www.ocamlpro.com/category/blog/). Please head to the latter for the comments!
