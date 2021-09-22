---
title: "Bootstrap a project"
---

> **TL;DR**
> 
> if you need a minimal project to start hacking quickly, use `dune init`. If you need a complete development environment that follows best practices, use `spin`.
As the recommended build system for OCaml, Dune offers a command `dune init` to bootstrap new projects.

Once you have successfully installed opam, you can install Dune with `opam install dune`.

This will install Dune's binary in your current Opam switch, so `dune` should now be in your `PATH`. If it not, you probably need to run `eval $(opam env)` to configure your current terminal with Opam environment.

To bootstrap a new project with `dune init`, run:

```
dune init proj hello my_project/
```

Where proj is the kind of project to initialize. Here we want to generate an entire project, so we use `proj`. `hello` is the name of the project and `my_project/` is the path where the project will be generated.

`dune init proj` does not generate a `dune-project` for you, so you need to go in the generated project and create one:

```
echo "(lang dune 2.0)" > dune-project
```

At this point, you can build the project and run the binary:

```
dune build
dune exec bin/main.exe
```

`dune init` is the quickest way to get a working OCaml project and start hacking, but you may need a bit more, for instance:

- How to setup the IDE
- How to setup the CI/CD

Or you may be looking for the best way to get started with a specific kind of project:

- A library
- A command line interface
- A web application

If that's the case, we recommend using `spin`, the OCaml project generator. Spin comes with official templates for common project types. The official templates will get you and and running with everything you need to get a productive development environment, including the IDE setup, the CI/CD, the code formatter, the unit tests, etc.

You can install `spin` with Opam: `opam install spin`.

Once its installed, you can list the available templates with `spin ls`. For the purpose of this workflow, we'll use `bin` that bootstraps a project with an executable:

```
spin new bin my_project/
```

This will take some time, because Spin will install all of the dependencies in a new opam local switch (a.k.a local sandbox), which needs to compile an OCaml compiler.

Once the project is generated, you can run the executable with `make start`.

You can also open the project in VSCode, which should detect your installation of the LSP server, code formatter and other Platform tools to offer the full range of its capabilities.

Happy hacking :)
