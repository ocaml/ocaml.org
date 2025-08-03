---
id: "formatting-your-code"
title: "Formatting Your Code With OCamlFormat"
short_title: "Formatting Your Code"
description: |
  How to set up OCamlFormat to automatically format your code
category: "Additional Tooling"
language: English
---

Automatic formatting with OCamlFormat requires an `.ocamlformat` configuration file at the root of the project.

An empty file is accepted, but since different versions of OCamlFormat will vary in formatting, it
is good practice to specify the version you're using. Running

```shell
$ echo "version = `ocamlformat --version`" > .ocamlformat
```

creates a configuration file for the currently installed version of OCamlFormat.

In addition to editor plugins that use OCamlFormat for automatic code formatting, Dune also offers a command to run OCamlFormat to automatically format all files from your codebase:

```shell
$ opam exec -- dune fmt
```
