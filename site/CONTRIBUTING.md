# Contributing to v3.ocaml.org

## Code of Conduct

Coming soon...

## Ways to get involved

- fix or suggest content - start by filing an issue in `ocaml/ood` repository
- implement pages - search through existing issues to find out what pages are planned for upcoming implementation
- contribute to site build process - search through existing issues or file an issue suggesting improvements

## Content workflow

See `ocaml/ood` README.

### Design and Information Architecture

[Sitemap and information architecture on flowmap](https://app.flowmapp.com/share/6e5eeb4573f9e110ac779691fee85422/sitemap/)

Design - Uses Figma, currently managed by designer. Discussion of both design and content is managed with Figma commenting system.

## Implementation Issue workflow

### Contributor

Feel free to use any approach that you prefer. The dev team
suggests the following:

- If you are unsure if your change will be accepted or if want to discuss the
  approach before diving in, please create an issue and pose questions.
- Create a draft pull request with a small initial commit. One way to do this quickly is the following:
  - Click the "branch" drop down menu and type the name of your new branch, using the convention INITIALS/TOPIC, such as "kw1/update-homepage", and click "Create branch: ..."
  - In order to be able to create a pull request, make a small commit:
    - Traverse to a source file of interest
    - Click the "pencil" edit icon in the top right, which puts the file in edit mode
    - Make a small change in the edit window
    - Select "Commit directly ..." and click "Commit changes"
  - Create a pull request using one of the following links, using the template which matches the type of change you are making. In the URL, replace "BRANCH" with your branch name.
    - Create or update the implementation of a webpage: https://github.com/ocaml/v3.ocaml.org/compare/BRANCH?expand=1&template=webpage_implement.md
    - Create a mockup page for a new design pull: https://github.com/ocaml/v3.ocaml.org/compare/BRANCH?expand=1&template=mocku
  - Change the action to "Create draft pull request" and press the button
- Clone the repo locally (or continue editing directly in github if the change is small). Checkout
  out the branch that you created.
- Continue developing, feel free to ask questions in
  the PR, if you run into obstacles or uncertainty as you make changes
- Review your implementation according to the checks noted in the PR template
- Once you feel your branch is ready, change the PR status to "ready to review"

### Reviewer

- Consult the tasks noted in the PR template
- When merging, consider cleaning up the commit body
- Close any issues that were addressed by this PR

## Setup and Development

### Prerequisities

The site build process assume you have `npx` available. Run `npx --version` to test your installation. If you don't have `npx`, you will need to install `node`, the package that `npx` is part of. Currently we require node LTS Version 14.x. Please consult the [Node.js website](https://nodejs.org) for instructions on installing it.

Our recommendation is to use a node version manager such as [fnm](https://github.com/Schniz/fnm) or [nvm](https://github.com/nvm-sh/nvm). Thus, install one of these tools instead. Then you can run the following in the root of the repo:

```bash
echo 14 > .nvmrc
fnm install # run this
nvm install # or this
```

Now check that `npx --version` works, and that `node --version` returns v14.x. Note that we have added `.nvmrc` to `.gitignore`, so you can leave that file in your directory.


### Quickstart

Once you have the node toolchain installed, the easiest way to get the project installed, built, and get the development servers started is to run:

```bash
make
```

Yes, it's that simple. However, if you'd like a little more fine-grained control over installing, building, and running the development servers, please see the sections below.

### Dependencies

Run the following command to install various dependencies:

```
make install-deps
```

The command installs all dependencies, including compilers such as ReScript and OCaml, and package managers like esy. It also vendors in the `ood` library, to support its co-development. All depdencies are installed in a project local way, so there will be no affect on your system or other projects.

### Development

Use the following command to run the ReScript compiler in watch mode as well as the NextJS dev server:

```
make watch
```

Go to `http://localhost:3000`

## Tips

### Do not use nextjs server side features, such as getServerSideProps

In order to ensure that this site remains a static site, do not make use of nextjs's
`getServerSideProps` functionality. More [functionality to avoid is enumerated in the nextjs docs](https://nextjs.org/docs/advanced-features/static-html-export#caveats).

## Useful commands

Build CSS separately via `npx postcss` (useful for debugging)

```
npx postcss@8.3.1 styles/main.css -o /tmp/test.css
```

## Test production setup

```
make build && make serve
```

## Architecture

...

