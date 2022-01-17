# How to contribute

Welcome to v3.ocaml.org's contributing guide.

Thank you for taking the time to read the contributing guide. Your help with v3.ocaml.org is extremely welcome. If you get stuck, please don’t hesitate to [ask questions on discuss](https://discuss.ocaml.org/) or [raise an issue](https://github.com/ocaml/v3.ocaml.org-server/issues/new).

## How to get started

We are particularly motivated to support new contributors and people who are looking to learn and develop their skills.

- **Good First Issues**: issues marked as a `good first issue` are ideal for people who are either new to the repository or still getting started with OCaml in general.
- **Fixing or Suggesting Content**: most of the content for the site is stored in the `data` directory as markdown or yaml. To fix this content you can edit those files directly and rebuild the website. This will promote the content into their `.ml` counterparts. If you would like to suggest entirely new content please open an issue to discuss it first.
- **Implementing pages**: most pages are implemented in `src/ocamlorg_frontend/pages` using the [.eml templating preprocessor](https://aantron.github.io/dream/#templates). This is mixture or OCaml and HTML.
- **Translating content or pages**: for now we are focusing on getting v3.ocaml.org ready for launch and will add more information about translation later.

## Reporting bugs

We use GitHub issues to track all bugs and feature requests; feel free to open an issue over [here](https://github.com/ocaml/v3.ocaml.org/issues/new) if you have found a bug or wish to see a feature implemented.

Please include images and browser-specific information if the bug is related to some visual aspect of the site. This tends to make it easier to reproduce and fix.

## Setup and Development

### Setting up the Project

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

### Deploying

Commits added on `main` are automatically deployed on <https://v3.ocaml.org/>.

The deployment pipeline is managed in <https://github.com/ocurrent/ocurrent-deployer> which listens to the `main` branch and builds the site using the `Dockerfile` at the root of the project.

To test the deployment locally, you can run the following commands:

```
docker build -t v3.ocaml.org .
docker run -p 8080:8080  v3.ocaml.org
```

This will build the docker image and run a docker container with the port `8080` mapped to the HTTP server.

With the docker container running, you can visit the site at <http://localhost:8080/>.

## Git and GitHub workflow

The preferred workflow for contributing to a repository is to fork the main repository on GitHub, clone, and develop on a new branch.

If you aren't familiar with how to work with Github or would like to learn it, here is [a great tutorial](https://app.egghead.io/playlists/how-to-contribute-to-an-open-source-project-on-github).

Feel free to use any approach while creating a pull request. Here are a few suggestions from the dev team:

- If you are not sure whether your changes will be accepted or want to discuss the method before delving into it, please create an issue and ask it.
- Clone the repo locally (or continue editing directly in github if the change is small). Checkout
  out the branch that you created.
- Create a draft pull request with a small initial commit. Here's how you can [create a draft pull request.](https://github.blog/2019-02-14-introducing-draft-pull-requests/)
- Continue developing, feel free to ask questions in the PR, if you run into obstacles or uncertainty as you make changes
- Review your implementation according to the checks noted in the PR template
- Once you feel your branch is ready, change the PR status to "ready to review"
- Consult the tasks noted in the PR template
- When merging, consider cleaning up the commit body
- Close any issues that were addressed by this PR.

## Repository structure

The following snippet describes the repository structure.

```text
.
├── asset/
|   The static assets served by the site.
│
├── data/
|   Data used by ocaml.org in Yaml and Markdown format.
│
├── gettext/
|   `.PO` files for static content translation. Not currently being used.
│
├── src
│   ├── gettext
|   |   The source code for translations.
|   |
│   ├── hilite
|   |   A small library we use to do OCaml code highlighting at build time.
|   |
│   ├── ocamlorg_data
|   |   The result of compiling all of the information in `/data` into OCaml modules.
|   |
│   ├── ocamlorg_frontend
|   |   All of the front-end code primarily using .eml files (OCaml + HTML).
|   |
│   ├── ocamlorg_package
|   |   The library for constructing opam-repository statistics and information (e.g. rev deps).
|   |
│   ├── ocamlorg_toplevel
|   |   All of the js_of_ocaml toplevel code including UI and background workers.
|   |
│   └── ocamlorg_web
|       The main entry-point of the server.
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
