---
title: Guarded methods in OCaml
description:
url: https://xvw.lol/en/articles/oop-refl.html
date: 2025-06-29T00:00:00-00:00
preview_image:
authors:
- xvw, Xavier Van de Woestyne
source:
ignore:
---


      **Guarded methods** allow attaching **constraints** to the receiver (`self`) **only for certain methods**, thus allowing these methods to be called only if the receiver satisfies these constraints (these _guards_). [OCaml](https://ocaml.org) does not syntactically allow defining this kind of method _directly_. In this note, we will see how to encode them using a **type equality witness**.
    
