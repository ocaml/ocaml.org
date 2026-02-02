---
title: Opening up old release branches
description: "The spring-cleaning continues! When I originally prototyped Relocatable
  OCaml, it was during the OCaml 4.13 development cycle. The focus for the work originally
  was always about multiple versions of the compiler co-existing without interfering
  with each other, so even the early prototypes were done on both OCaml 4.12 and OCaml
  4.13. In fact, I see that in this talk, I even demo\u2019d it on both versions.
  My intention from the start had always been to be able to provide either backports
  or re-releases of older compilers, on the basis that it would be tedious to have
  only the latest releases of OCaml supporting the various fixes, given that the failing
  CI systems which had motivated the project would continue to test older versions
  for several/many years after completion. In 2021, OCaml 4.08 (from June 2019) was
  still a recent memory. From a technical perspective, OCaml 4.08 was a very important
  release. It\u2019s the first version of OCaml with a reliably namespaced Standard
  Library (the Stdlib module, though introduced in 4.07, had various issues with shadowing
  modules which weren\u2019t completely addressed until 4.08). For my work, it was
  the version where we switched the configuration system to autoconf, and thus introduced
  a configuration system for the Windows ports. It provided a natural baseline in
  2022 for the backports, and thus the workshop demonstration I gave in Ljubljana
  featured Windows and Linux for OCaml 4.08-4.14 as well as preview of OCaml 5.0."
url: https://www.dra27.uk/blog/platform/2026/01/16/dusting-off-the-branches.html
date: 2026-01-16T00:00:00-00:00
preview_image:
authors:
- ""
source:
ignore:
---
