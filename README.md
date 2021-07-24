# OCaml.org

[![Actions Status](https://github.com/tmattio/ocamlorg/workflows/CI/badge.svg)](https://github.com/tmattio/ocamlorg/actions)

OCaml.org website

## Set up your development environment

You need opam. You can install it by following [opam's documentation](https://opam.ocaml.org/doc/Install.html).

With opam installed, you can install the dependencies in a new local switch with:

```bash
make switch
```

Or globally, with:

```bash
make deps
```

Then, build the project with:

```bash
make build
```

### Running the server

After building the project, you can run the server with:

```bash
make start
```

To start the server in watch mode, you can run:

```bash
make watch
```

This will restart the server on filesystem changes and reload the pages automatically.

### Running tests

You can run the unit test suite with:

```bash
make test
```

### Building documentation

Documentation for the libraries in the project can be generated with:

```bash
make doc
```

To serve the documentation:

```bash
make servedoc
```

### Repository structure

The following snippet describes OCaml.org's repository structure.

```text
.
├── bin/
|   Source for {{ project_slug }}'s binary. This links to the library defined in `lib/`.
│
├── lib/
|   Source for OCaml.org's library. Contains OCaml.org's core functionalities.
│
├── test/
|   Unit tests and integration tests for OCaml.org.
│
├── dune-project
|   Dune file used to mark the root of the project and define project-wide parameters.
|   For the documentation of the syntax, see https://dune.readthedocs.io/en/stable/dune-files.html#dune-project.
│
├── LICENSE
│
├── Makefile
|   `Makefile` containing common development commands.
│
├── README.md
│
└── ocamlorg.opam
    opam package definition.
    To know more about creating and publishing opam packages, see https://opam.ocaml.org/doc/Packaging.html.
```

## Deploying

To deploy on Heroku, run the following commands:

```
heroku container:push -a ocamlorg web
heroku container:release -a ocamlorg web
```

And to open the logs:

```
heroku logs -a ocamlorg --tail
```
