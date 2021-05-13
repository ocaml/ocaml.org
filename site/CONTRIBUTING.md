# Contributing to next.ocaml.org

## Code of Conduct

Coming soon...

## Ways to get involved

* fix or suggest content - start by filing an issue in `ocaml/ood` repository
* implement pages - search through existing issues to find out what pages are planned for upcoming implementation
* contribute to site build process - search through existing issues or file an issue suggesting improvements

## Content workflow

See `ocaml/ood` README.

### Design and Information Architecture

[Sitemap and information architecture on flowmap](https://app.flowmapp.com/share/6e5eeb4573f9e110ac779691fee85422/sitemap/)

Design - Uses Figma, currently managed by designer. Discussion of both design and content is managed with Figma commenting system.

## Implementation Issue workflow

### Contributor

Feel free to use any approach that you prefer. The dev team
suggests the following:
* If you are unsure if your change will be accepted or if want to discuss the
approach before diving in, please create an issue and pose questions.
* Create a draft pull request with a small initial commit. One way to do this quickly is the following:
  * Click the "branch" drop down menu and type the name of your new branch, using the convention INITIALS/TOPIC, such as "kw1/update-homeage", and click "Create branch: ..."
  * In order to be able to create a pull request, make a small commit:
      * Traverse to a source file of interest
      * Click the "pencil" edit icon in the top right, which puts the file in edit mode
      * Make a small change in the edit window
      * Select "Commit directly ..." and click "Commit changes"
  * Create a pull request using one of the following links, using the template which matches the type of change you are making. In the URL, replace "BRANCH" with your branch name.
       * Create or update the implementation of a webpage: https://github.com/solvuu-inc/next.ocaml.org/compare/BRANCH?expand=1&template=webpage_implement.md 
       * Create a mockup page for a new design pull request template: https://github.com/solvuu-inc/next.ocaml.org/compare/BRANCH?expand=1&template=mockup_webpage.md
       * Perform an ecosystem upgrade pull request template: https://github.com/solvuu-inc/next.ocaml.org/compare/BRANCH?expand=1&template=ecosystem_upgrade.md
  * Change the action to "Create draft pull request" and press the button
* Clone the repo locally (or continue editing directly in github if the change is small). Checkout
out the branch that you created.
* Continue developing, feel free to ask questions in
the PR, if you run into obstacles or uncertainty as you make changes
* Review your implementation according to the checks noted in the PR template
* Once you feel your branch is ready, change PR status to "ready to review"

### Reviewer

* Consult the tasks noted in the PR template
* When merging, consider cleaning up the commit body
* Close any issues that were addressed by this PR

## Tips

### res_pages vs pages

ReScript can only handle one module of a given name, e.g. "Index". This clashes with nextjs
page-based routing, which expects the filepath starting from `/pages/` to match
the route exposed. So, in order to completely avoid any problems from this issue,
we always create pages in `res_pages/` and rewrap the module in the desired location
in `pages/`. If your module uses `getStaticPaths` or `getStaticProps`, those will also
need to be re-exposed. Also, note that we choose to repeat the folder name (e.g. "releases") 
in the module name (e.g. "ReleasesIndex.js").

### Do not use nextjs server side features, such as getServerSideProps

In order to ensure that this site remains a static site, do not make use of nextjs's
`getServerSideProps` functionality. More [functionality to avoid is enumerated in the nextjs docs](https://nextjs.org/docs/advanced-features/static-html-export#caveats).

### Prefer Simplicity over Accomodating Fast Refresh

We choose to not complicate this project to accomodate Fast Refresh.


## Useful commands

Build CSS seperately via `npx postcss` (useful for debugging)

```
npx postcss@8.3.1 styles/main.css -o /tmp/test.css
```

## Test production setup with Next

```
yarn install && yarn build && yarn start-test-server
```

Note: Some deployment systems use `next start` to start a hybrid static site instead of using `next export` with an external http server.

## Setup and Development

### Prerequisities

If you choose to use `nvm`, you must activate `nvm` before installing `yarn` and `esy`.

#### node

The site makes use of `node`. We recommmend using `nvm` to install node. If you don't already have `nvm` installed, you can [install it using the instructions provided by `nvm`](https://github.com/nvm-sh/nvm#installing-and-updating). Restart or reload your terminal to pickup the changes.

If you are using `nvm`, then you can install the necessary `node` version with the following command:

```
nvm install
```

Once you have the proper version of `node` installed, if you are using `nvm`, you can activate the proper version of `node` in **each terminal** with the following command:

```
nvm use
```

#### yarn 

The site makes use of `yarn`. We currently use version 1.22. Please consult the `yarn` documentation for installation instructions. We recommend installing `yarn` globally to provide a smoother command line experience.

#### esy

The site makes use of `esy`. We currently use version 0.6.8. Please consult the `esy` documentation for installation instructions. We recommend installing `esy` globally to provide a smooother command line experience.

### Dependencies

The site relies on an external repository named `ood` which houses content and a parsing library. Please clone that repository into the expected location `vendor/ood`.

```
cd $(git rev-parse --show-toplevel)
mkdir vendor
cd vendor
git clone git@github.com:ocaml/ood.git # TODO: specific branch and trim depth
```

Note: Remember that **each terminal** needs to have `nvm use` invoked to activate the proper node version, if you are using `nvm`.

Install ReScript libraries, javascript libraries, and build and install ocaml helper executables:

```
make isntall-vendored-deps
yarn install && esy
```

Run ReScript compiler in watch mode:

```
npx bsb -make-world -w
```

In another tab, run the Next dev server:

```
npx next dev
```

The output from the next dev server is rarely interesting, so you might save some
real estate by running the command in the background. This frees up the second terminal for performing `git` commands.

Go to `http://localhost:3000`

## Architecture

We have prepared some diagrams and explanations to orient new developers in the wiki area. The site expands upon the default build process in NextJS to accommodate more sophisticated markdown transformations.
