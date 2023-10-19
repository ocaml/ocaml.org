---
id: "bootstrapping-a-dune-project"
title: "Bootstrapping a Project"
description: |
  How to set up a project with Dune
category: "Best Practices"
---

# Bootstrapping a Project with Dune

[Dune](https://dune.readthedocs.io/en/stable/overview.html) is recommended for bootstrapping projects using `dune init`. If `opam` or `dune` are not installed, please see [the OCaml install page](/install).

> dune init --help
>
> **dune init {library,executable,test,project} NAME [PATH]** initialize a
> new dune component of the specified kind, named NAME, with fields
> determined by the supplied options.

As shown above, `dune init` accepts a _kind_, `NAME`, and optional `PATH` to scaffold new code. Let's try it out:

```sh
dune init project hello ~/src/ocaml-projects

Success: initialized project component named hello
```

In the above example, we use:

- "project" as the _kind_
- "hello" as the _name_, and
- "~/src/ocaml-projects" as the _path_ to generate the content in

The `project` _kind_ creates a `library` in `./lib`, an `executable` in `./bin`, and links them together in `bin/dune`. Additionally, the command creates a test executable and an opam file.

```sh
tree ~/src/ocaml-projects/hello/

/home/user/src/ocaml-projects/hello/
├── bin
│   ├── dune
│   └── main.ml
├── hello.opam
├── lib
│   └── dune
└── test
    ├── dune
    └── hello.ml
```

At this point, you can build the project and run the binary:

```sh
cd /home/user/src/ocaml-projects/hello/
dune exec bin/main.exe

Hello, world!
```

Thus, `dune init` can rapidly scaffold new projects, with minimal content. It can also be used to add components (kinds) incrementally to existing projects.

Various community projects offer more comprehensive project scaffolding than `dune` as well.
The following projects are not formally supported by the OCaml Platform, but may be of interest to the reader:

- [spin](https://github.com/tmattio/spin)
- [drom](https://ocamlpro.github.io/drom/sphinx/about.html)
- [carcass](https://github.com/dbuenzli/carcass)
