---
id: "compiler-release-cycle"
title: "The Compiler Release Cycle"
description: An overview of how the OCaml compiler gets released.
category: "OCaml Compiler"
---

## What Does an OCaml Version Mean?

OCaml releases follow a Linux-like scheme for their version string. The
OCaml version string consists in three numbers, optionally followed by
either a prerelease or development tag
(`%i.%i.%i[~alpha%i|~beta%i|~rc%i|+%s]`). For example, 4.14.1,
5.1.0~alpha2, and 5.3.0+dev0-2023-12-22 are valid OCaml versions.

- The first version number (4 in 4.14.1) is the major version of OCaml.
  This version number is updated when major new features are added to the OCaml
  language. For instance, OCaml 5 added shared memory parallelism and effect
  handlers and OCaml 4 introduced GADTs (Generalised Abstract Data Types).

- The second version number (14 in 4.14.1) is the minor version of OCaml.
  This number is increased for every new release of OCaml. In particular, a new
  minor version of OCaml can contain breaking changes. However, we strive to
  maintain backward compatibility as much as possible.

- The last number (1 in 4.14.1) is the bugfix number.
  Updating to the latest bugfix release is always safe, those bugfix versions
  are meant to be completely backward compatible and only contain important or
  very safe bug fixes.

- The prerelease tag `~alpha%i`, `~beta%i`, `~rc%i` (~alpha2 in
  5.1.0~alpha2) describes a prerelease version of the compiler that is
  currently being tested. See [below](## Prerelease versions) for
  a more thorough explanation.

- The development tag `+tag` indicates a development or experimental version of
  the compiler. +dev0-2023-12-22 in 5.3.0+dev0-2023-12-22 is an example of the
  tags of the form +dev%i-%date used by the compiler for its development
  versions.


## When Are New Versions Released?

Since OCaml 4.03, we are using a time-based release schedule:
a new minor version of OCaml is released every six months.

For instance, at the date of writing, the next planned releases of OCaml are:

- OCaml 5.2: around April 2024
- OCaml 5.3: around October 2024

The timing is approximate, as we often delay a release to ensure quality when
unforeseen issues come up. In consequence, releases are often late, typically by
up to two months.

We may release bugfix releases at any time.

## Bugfix Versions

Bugfix versions are published if we discover issues that significantly impede
the use of the initially released version. In that situation, it is not uncommon
that we backport safe bug fixes that were integrated in the trunk after the
release.

Most bugfix releases are M.m.1 releases that happened one or two months after
the M.m.0 minor release to fix an important issue that was not found during
prerelease testing.

Users are strongly encouraged to switch to the last bugfix versions as soon as
possible. We make this easy by doing our best to avoid any regression there.


## Exceptional LTS Versions

Switching from OCaml 4 to OCaml 5 required a full rewrite of the OCaml runtime.
This has negatively affected the stability of the releases of OCaml 5 in terms of

- Supported architectures
- Supported OS
- Performance stability
- Number of runtime bugs

To keep a stable version easily available, we are exceptionally maintaining
OCaml 4.14 as a long term support version of OCaml. New bugfix versions of OCaml
4.14 will be released in the future until OCaml 5 is considered mature enough.

User feedback is welcome on which fixes from OCaml 5 should be also included in
4.14.

Once OCaml 5 is stabilised, this extended support of OCaml 4.14 will stop.
Currently, we expect to support OCaml 4.14 until OCaml 5.4 (around April 2025).
