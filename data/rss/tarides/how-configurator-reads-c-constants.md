---
title: How configurator reads C constants
description:
url: https://dune.build/blog/configurator-constants/
date: 2019-01-03T00:00:00-00:00
preview_image:
featured:
---

<p>Dune comes with a library to query OS-specific information, called configurator.
It is able to evaluate C expressions and turn them into OCaml value.
Surprisingly, it even works when compiling for a different architecture. How can
it do that?</p>
