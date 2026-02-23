---
id: "bootstrapping-a-dune-project"
title: "Bootstrapping a Project with Dune"
short_title: "Bootstrapping a Project"
description: |
  How to set up a project with Dune
category: "Projects"
language: English
---

[Dune](https://dune.readthedocs.io/en/stable/overview.html) is recommended for bootstrapping projects. To install `dune`, please see [the OCaml install page](/install).

To start a new project, you can run:

```sh
$ opam exec -- dune init project hello_world
Success: initialized project component named hello_world
```

You can now build and run your new project:

```sh
$ cd hello_world
$ opam exec -- dune exec bin/main.exe
Hello, world!
```

To create a new library in the current project, use:

```sh
$ opam exec -- dune init lib my_lib ./path/to/my_lib
Success: initialized library component named my_lib
```

To create a new executable in the current project, use:

```sh
$ opam exec -- dune init exec my_bin ./path/to/my_bin
Success: initialized executable component named my_bin 
```

To create a new test in the current project, use:

```sh
$ opam exec -- dune init test my_test ./path/to/my_test
Success: initialized test component named my_test 
```

## More Comprehensive Scaffolding

If you're looking for project templates that include more than the basics, there are other community projects that offer more comprehensive project scaffolding:

- [spin](https://github.com/tmattio/spin)
- [drom](https://ocamlpro.github.io/drom/sphinx/about.html)
- [carcass](https://github.com/dbuenzli/carcass)
