---
title: OCaml, modules, and import schemes
description:
url: https://xvw.lol/en/articles/modules-import.html
date: 2025-06-30T00:00:00-00:00
preview_image:
authors:
- xvw, Xavier Van de Woestyne
source:
ignore:
---


      The [OCaml](https://ocaml.org) module system can be intimidating, and it typically involves the use of many keywords—for example, `open` and `include`, which allow importing definitions into a module. Since version OCaml `4.08`, the `open` primitive has been *generalized* to allow the opening of **arbitrary module expressions**. In this article, we’ll explore how to use this generalization to reproduce a common practice in other languages, what I somewhat pompously call _import strategies_, to describe patterns like `import {a, b as c} from K`, without relying on a (_sub-_)language dedicated specifically to importing.
    
