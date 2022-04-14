# Hacking on OCaml.org

## Setup and Development

### Setting up the Project

The `Makefile` contains many commands that can get you up and running, a typical workflow will be to clone the repository after forking it.

```
git clone https://github.com/<username>/ocaml.org.git
cd ocaml.org
```

Ensure you have `opam` installed. Opam will manage the OCaml compiler along with all of the OCaml packages needed to build and run the project. By this point we should all be using some Unix-like system (Linux, macOS, WSL2) so you should [run the opam install script](https://opam.ocaml.org/doc/Install.html#Binary-distribution). There are also manual instructions for people that don't want to run a script from the internet. We assume you are using `opam.2.1.0` or later which provides a cleaner, friendlier experience when installing system dependencies.

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
docker build -t ocaml.org .
docker run -p 8080:8080  ocaml.org
```

This will build the docker image and run a docker container with the port `8080` mapped to the HTTP server.

With the docker container running, you can visit the site at <http://localhost:8080/>.

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
├── src
│   ├── dream_dashboard
|   |   A monitoring and analytics dashboard for dream.
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
├── ocamlorg.opam
├── ocamlorg.opam.template
│   opam package definitions.
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
