---
title: 'Introduction to OCaml, part 5: exceptions, lists, and structural recursion'
description:
url: https://www.baturin.org/blog/introduction-to-ocaml-part-5-exceptions-lists-and-structural-recursion
date: 2018-08-18T00:00:00-00:00
preview_image:
featured:
authors:
- Daniil Baturin
---


    In OCaml, exceptions are not objects, and there are no exception hierarchies. It may look unusual now,
but in fact exceptions predate the rise of object oriented languages and it's more in line with original
implementations. The advantage is that they are very lightweight.
    
