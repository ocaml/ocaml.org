---
id: "generating-documentation"
title: "Generating Documentation"
description: |
  How to use odoc to generate documentation.
category: "Best Practices"
---

# Generating Documentation With Odoc

The documentation rendering tool `odoc` generates documentation
in the form of HTML, LaTeX, or man pages,
from the docstrings and interfaces of the project's modules

Dune can run `odoc` on your project to generate HTML documentation with this command:

```shell
$ dune build @doc

# Unix or macOS
$ open _build/default/_doc/_html/index.html

# Windows
$ explorer _build/default/_doc/_html/index.html
```
