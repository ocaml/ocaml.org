---
title: "Bootstrap a project"
---

[Dune](https://dune.readthedocs.io/en/stable/overview.html) is recommended for bootstrapping projects using `dune init`.

> dune init --help
>
> **dune init {library,executable,test,project} NAME [PATH]** initialize a
> new dune component of the specified kind, named NAME, with fields
> determined by the supplied options.

Once you have [installed opam](https://opam.ocaml.org/doc/Install.html), you can install Dune with `opam install dune`. This installs the Dune binary into your `opam` switch, so `dune` should now be in your `PATH`. If it is not, you probably need to run `eval $(opam env)` to configure your current terminal with your opam environment.

To bootstrap a new project with `dune init`, run:

```sh
dune init project hello my_project/
```

In the above example, we use:

- "project" as the _kind_
- "hello" as the name, and
- "my_project/" as the path to generate the content in

`dune@2.x` does not generate a `dune-project` file for you, so it is recommended to create one:

```sh
cd my_project
echo "(lang dune 2.0)" > dune-project
```

At this point, you can build the project and run the binary:

```sh
dune exec bin/main.exe
```

`dune init` is the quickest way to get a working OCaml project and start hacking, but you may need a bit more, for instance:

- How to setup the IDE
- How to setup the CI/CD

Or you may be looking for the best way to get started with a specific kind of project:

- A command line interface
- A web application

If that's the case, we recommend using `spin`, the OCaml project generator. Spin comes with official templates for common project types. The official templates will get you up and running with everything you need to get a productive development environment, including the IDE setup, the CI/CD, the code formatter, the unit tests, etc.

You can install `spin` with opam: `opam install spin`.

Once it's installed, you can list the available templates with `spin ls`. For the purpose of this workflow, we'll use `bin` that bootstraps a project with an executable:

```
spin new bin my_project/
```

This will take some time, because Spin will install all of the dependencies in a new opam local switch (a.k.a local sandbox), which needs to compile an OCaml compiler.

Once the project is generated, you can run the executable with `make start`.

You can also open the project in VSCode, which should detect your installation of the LSP server, code formatter and other Platform tools to offer the full range of its capabilities.

Happy hacking :)
