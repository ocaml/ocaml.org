# Contributing to OCaml.org

This repository contains the data and source code for the ocaml.org site in a structured format.

Contributions are very welcome whether that be:

 - Adding some content
 - Translating content or pages
 - Fixing bugs or typos
 - Improving the UI

## Setting up the Project

The `Makefile` contains many commands that can get you up and running, a typical workflow will be to clone the repository after forking it.

```
git clone https://github.com/<username>/v3.ocaml.org-server.git
cd v3.ocaml.org-server
```

From the root of your project, the simplest way to get set up is to create a [local opam switch](https://opam.ocaml.org/doc/Manual.html#Switches) and install the dependencies. There 
is a single `make` target to do just that.

```
make switch
```

If you don't want a local opam switch and are happy to install everything globally (in the opam sense) then you can just install the dependencies directly.

```
make deps
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

This will restart the server on filesystem changes.

### Running tests

You can run the unit test suite with:

```bash
make test
```

## Submitting a PR

To submit a PR make sure you create a new branch, add the code and commit it. 

```
git checkout -b my-bug-fix
git add fixed-file.ml
git commit -m "fix a bug"
git push -u origin my-bug-fix
```

From here you can then open a PR from Github. Before committing your code it is very useful to:

 - Format the code: this should be as simple as `make fmt`
 - Make sure it builds: running `make build`, this is also very important if you add data to the repository as it will "crunch" the data into the static OCaml modules (more information below)
 - Run the tests: this will check that all the data is correctly formatted and can be invoked with `make test`

## Adding or updating datas

As explained on the README, `src/ocaml` contains the information in the `data` directory, packed inside OCaml modules. This makes the data very easy to consume from multiple different projects like from ReScript in the [front-end of the website](https://github.com/ocaml/v3.ocaml.org). It means most consumers of the ocaml.org data do not have to worry about re-implementing parsers for the data.

If you are simply adding information to the `data` directory that's fine, before merging one of the maintainers can do the build locally and push the changes. If you can do a `make build` to also generate the OCaml as part of your PR that would be fantastic.

## Repository structure

The following snippet describes OCaml.org's repository structure.

```text
.
├── asset/
|   The static assets served by the site.
│
├── data/
|   Data used by ocaml.org in Yaml and Markdown format.
│
├── gettext/
|   `.PO` files for static content translation.
│
├── src/
|   The source code of ocaml.org.
│
├── tool/
|   Sources for development tools such as the `ocamlorg_data` code generator.
│
├── dune
├── dune-project
|   Dune file used to mark the root of the project and define project-wide parameters.
|   For the documentation of the syntax, see https://dune.readthedocs.io/en/stable/dune-files.html#dune-project.
│
├── ocamlorg-data.opam
├── ocamlorg.opam
├── ocamlorg.opam.template
│   opam package definitions.
│   To know more about creating and publishing opam packages, see https://opam.ocaml.org/doc/Packaging.html.
│
├── package-lock.json
├── package.json
|   Package file for NPM packages. This is used to defined the JavaScript dependencies of the project.
│
├── CHANGES.md
│
├── CONTRIBUTING.md
│
├── Dockerfile
|   Dockerfile used to build and deploy the site in production.
│
├── LICENSE
├── LICENSE-3RD-PARTY
|   Licenses of the source code, data and vendored third-party projects.
│
├── Makefile
|   `Makefile` containing common development commands.
│
├── README.md
│
└── tailwind.config.js
    Configuration used by TailwindCSS to generate the CSS file for the site.
```

## Deploying

Commits added on `main` are automatically deployed on https://v3.ocaml.org/.

The deployment pipeline is managed in https://github.com/ocurrent/ocurrent-deployer which listens to the `main` branch and build the site using the `Dockerfile` at the root of the project.

To test the deployment locally, you can run the following commands:

```
docker build -t v3.ocaml.org .
docker run -p 8080:8080  v3.ocaml.org
```

This will build the docker image and run a docker container with the port `8080` mapped to the HTTP server.
With the docker container running, you can visit the site at http://localhost:8080/.

## Translating

The translation of the the static pages is done with the PO files found in `gettext/<locale>/LC_MESSAGES/*.po`.

If you would like add translations for a new language, for instance `ru`, you can copy the template files to get started:

```
mkdir -p gettext/ru/LC_MESSAGES/
cp gettext/messages.pot gettext/ru/LC_MESSAGES/messages.po
```

When adding new translatable string, you will need to add them to the `POT` and `PO` files. You can do so with the following commands:

```
dune exec ocaml-gettext -- extract _build/default/src/ocamlorg_web/lib/templates/**/*.ml > gettext/messages.pot
```

To extract the strings into the template.

```
dune exec ocaml-gettext -- merge gettext/messages.pot gettext/en/LC_MESSAGES/messages.po > gettext/en/LC_MESSAGES/messages.po
```

To merge the template file into the existing `PO` file.
