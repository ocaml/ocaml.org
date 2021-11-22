# How to contribute

Welcome to v3.ocaml.org's contributing guide.

Ocaml's a community-driven project and your help to v3.ocaml.org is extremely welcome.

## Code of Conduct 

## How to get started

We are particularly motivated to support new contributors. Here are a few ways to get started. You could contribute to a bunch of issues suggested below:


- **Good First Issues** 
You can look at the good first issues in four repositories:
    - [ocaml/ood](https://github.com/ocaml/ood/labels/good%20first%20issue). 
    - [ocaml/v3.ocaml.org](https://github.com/ocaml/v3.ocaml.org/labels/good%20first%20issue).
    - [ocaml-docs-ci](https://github.com/ocurrent/ocaml-docs-ci/labels/good%20first%20issue).
    - [ocaml/v3.ocaml.org-server](https://github.com/ocaml/v3.ocaml.org-server/labels/good%20first%20issue).

- **Fix or suggest content to ocaml/ood**
 Add some scrapped blog posts. You can help with importing the blog posts from [here.](https://github.com/ocaml/platform-blog.)
- **Implement pages**
 You can search through existing issues [over here](https://github.com/ocaml/v3.ocaml.org/projects/11) to find out what pages are planned for upcoming implementation.
- **File an issue**
 File an issue suggesting improvements [over here.](https://github.com/ocaml/v3.ocaml.org/issues/new)

- **Translating content or pages**
The translation of the the static pages is done with the PO files found in `gettext/<locale>/LC_MESSAGES/*.po`.

    If you would like add translations for a new language, for instance `ru`, you can copy the template files to get started:

- **Adding or updating data**

    As explained on the README, `src/ocaml` contains the information in the `data` directory, packed inside OCaml modules. This makes the data very easy to consume from multiple different projects like from ReScript in the [front-end of the website](https://github.com/ocaml/v3.ocaml.org). It means most consumers of the ocaml.org data do not have to worry about re-implementing parsers for the data.

    If you are simply adding information to the `data` directory that's fine, before merging one of the maintainers can do the build locally and push the changes. If you can do a `make build` to also generate the OCaml as part of your PR that would be fantastic.


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



**Note: If you get stuck, chat with us on [Discord.](https://discord.com/channels/436568060288172042/585511202759770135)**
 

## Reporting bugs

We use GitHub issues to track all bugs and feature requests; feel free to open an issue over [here](https://github.com/ocaml/v3.ocaml.org/issues/new) if you have found a bug or wish to see a feature implemented.


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

Commits added on `main` are automatically deployed on https://v3.ocaml.org/.

The deployment pipeline is managed in https://github.com/ocurrent/ocurrent-deployer which listens to the `main` branch and build the site using the `Dockerfile` at the root of the project.

To test the deployment locally, you can run the following commands:

```
docker build -t v3.ocaml.org .
docker run -p 8080:8080  v3.ocaml.org
```

This will build the docker image and run a docker container with the port `8080` mapped to the HTTP server.
With the docker container running, you can visit the site at http://localhost:8080/.

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



## Design and Information Architecture

The Design uses Figma and is currently managed by designer. Discussion of both design and content is managed with Figma commenting system.

You can have a look at the sitemap and information architecture on flowmap over [here.](https://app.flowmapp.com/share/6e5eeb4573f9e110ac779691fee85422/sitemap/)

## Architecture




## Coding style


## Acknowledging contributions
We follow the [all-contributors](https://allcontributors.org/) specification and recognize various types of contributions. Take a look at our past and current contributors!

<!--<# Contributing to OCaml.org

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

To merge the template file into the existing `PO` file. -->
