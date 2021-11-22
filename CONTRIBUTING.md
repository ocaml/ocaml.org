<# Contributing to OCaml.org

This repository contains the data and source code for the ocaml.org site in a structured format.

Contributions are very welcome whether that be:

 - Adding some content
 - Translating content or pages
 - Fixing bugs or typos
 - Improving the UI

## For Windows Users

If you are not on Windows feel free to move on to the next section. 

OCaml does not fully support Windows yet and since we are not concerned about producing Windows binaries we just need a working development environment. The easiest way to do this on Windows is to use the *Windows Subsystem for Linux 2* (WSL2). The second version is much better than the first so be sure to use that. Here are some useful instructions:

- Installation: https://docs.microsoft.com/en-us/windows/wsl/install
- Editor support: https://code.visualstudio.com/blogs/2019/09/03/wsl2
- Our old site has some useful docs about using WSL2 too: https://github.com/ocaml/ocaml.org/blob/master/CONTRIBUTING.md#windows-some-common-errors-while-building-the-site-using-wsl

Once this is set up, you will be coding as if you are on a Linux machine so all of the other commands will be identical.

## Setting up the Project

The `Makefile` contains many commands that can get you up and running, a typical workflow will be to clone the repository after forking it.

```
git clone https://github.com/<username>/v3.ocaml.org-server.git
cd v3.ocaml.org-server
```

For the smoothest setup experience make sure you have some version of `npm` and `node` installed. The best way to do this is probably to [use nvm](https://github.com/nvm-sh/nvm/blob/master/README.md#install--update-script). You might have to source your `~/.bashrc` after installation of `nvm` then you can run something like `nvm install 16`. We use `node` and `npm` to have tailwind css.

After this ensure you have `opam` installed. Opam will manage the OCaml compiler along with all of the OCaml packages needed to build and run the project. By this point we should all be using some Unix-like system (Linux, macOS, WSL2) so you should [run the opam install script](https://opam.ocaml.org/doc/Install.html#Binary-distribution). There are also manual instructions for people that don't want to run a script from the internet. We assume you are using `opam.2.1.0` or later which provides a cleaner, friendlier experience when installing system dependencies.

With opam installed you can now initialise opam with `opam init`. Note in containers or WSL2 you will have to run `opam init --disable-sandboxing`. Opam might complain about some missing system dependencies like `unzip`, `cc` (a C compiler like `gcc`) etc. Make sure to install these before `opam init`.

Finally from the root of your project you can setup a [local opam switch](https://opam.ocaml.org/doc/Manual.html#Switches) and install the dependencies. There is a single `make` target to do just that.

```
make switch
```

If you don't want a local opam switch and are happy to install everything globally (in the opam sense) then you can just install the dependencies directly.

```
make deps
```

Opam will likely ask questions about installing system dependencies, for the project to work you will have to answer yes to installing these.

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
