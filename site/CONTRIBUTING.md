# Contributing to next.ocaml.org

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
    - Create a mockup page for a new design pull: https://github.com/ocaml/v3.ocaml.org/compare/BRANCH?expand=1&template=mockup_webpage.md
    - Perform an ecosystem upgrade: https://github.com/ocaml/v3.ocaml.org/compare/BRANCH?expand=1&template=ecosystem_upgrade.md
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

The site build process makes use of `nvm`. Please consult the appropriate documentation for [installing `nvm`](https://github.com/nvm-sh/nvm#installing-and-updating) for your operating system. Restart or reload your terminal to pickup the changes.

#### esy

The site makes use of `esy`. We currently use version 0.6.8. Please consult the `esy` documentation for installation instructions. We recommend installing `esy` globally to provide a smoother command line experience.

### Dependencies

Run the following command to install various dependencies:

```
make install-deps
```

The command installs the appropriate versions of node and yarn. It also installs

### Development

Use the following command to run the ReScript compiler in watch mode as well as the NextJS dev server:

```
make watch
```

Go to `http://localhost:3000`

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

## Useful commands

Build CSS separately via `npx postcss` (useful for debugging)

```
npx postcss@8.3.1 styles/main.css -o /tmp/test.css
```

## Test production setup

```
make build && make serve
```

Note: Some deployment systems use `next start` to start a hybrid static site instead of using `next export` with an external http server.

## Architecture

We have prepared some diagrams and explanations to orient new developers in the wiki area. The site expands upon the default build process in NextJS to accommodate more sophisticated markdown transformations.
