# OCaml.org

[![Actions Status](https://github.com/ocaml/v3.ocaml.org-server/workflows/CI/badge.svg)](https://github.com/ocaml/v3.ocaml.org-server/actions)

ocamlorg is a Dream-based server for the next version of the ocaml.org website.

It serves the OCaml packages pages and their documentation by using the data available at https://docs-data.ocaml.org/ and serves the static files generated from the NextJS application at https://github.com/ocaml/v3.ocaml.org.

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

The server will download its runtime dependencies itself (e.g. the opam-repository),
but you will need to download the `v3.ocaml.org` static files, which are crunched in the executable at compile time:

```
make update-site
```

This will pull the v3.ocaml.org docker image and copy the static files from it into the `asset/site/` directory.

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

This will restart the server on filesystem changes and reload the pages automatically. The watch script depends on `fswatch`, so make sure to install it before running the script.

### Running tests

You can run the unit test suite with:

```bash
make test
```

## Repository structure

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

Once the website is deployed, you can display the logs with:

```
heroku logs -a ocamlorg --tail
```
