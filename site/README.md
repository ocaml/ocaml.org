# ocaml.org

## Issue workflow

### Contributor

Feel free to use any approach that you prefer. The dev team
suggests the following:
* If you are unsure if your change will be accepted or if want to discuss the
approach before diving in, please create an issue and pose questions.
* Create a draft PR with a small initial commit in fork of the repo. One way
to do this quickly is the following:
  * traverse to a source file of interest in github
  * click the "pencil" edit icon in the top right, which forks the project and puts the file in edit mode
  * make a small change to get started in the edit window
  * push "propose changes", which will create a commit and prompt for PR creation
  * click "Create Pull Request"
  * on the next screen, change the action to "Create draft pull request" and press the button
* Clone your fork locally (or continue editing directly in github if the change is small)
* Continue developing, feel free to ask questions in
the PR, if you run into obstacles or uncertainty as you make changes
* Once you feel your branch is ready, check the PR preview to ensure the changes
match your local view and appear correct
* Change PR status to "ready to review"
* Update the PR description to indicate relative paths that have changed

### Reviewer
* Observe the relative paths changed in latest PR Preview
* ... manual smoke test: ... ...
* ... MORE CONTENT HERE ...
* Use "squash and merge", summarizing commit messages
* Close any issues that were addressed by this PR

## Setup

```
# Ensure you have the correct node version.
# (Assumes that you have nvm installed already)
nvm install

# Set the appropriate node version
nvm use

# For first time clone / build (install dependencies)
npx yarn@1.22 install
```

## Development

Run ReScript in dev mode:

```
nvm use
npx yarn rescript:start
```

In another tab, run the Next dev server:

```
nvm use
npx yarn next:dev
```

Go to localhost:3000

## Tips

### res_pages vs pages

ReScript can only handle one module of a given name, e.g. "Index". This clashes with nextjs
page-based routing, which expects the filepath starting from `/pages/` to match
the route exposed. So, in order to completely avoid any problems from this issue,
we always create pages in `res_pages/` and rewrap the module in the desired location
in `pages/`. If your module uses `getStaticPaths` or `getStaticProps`, those will also
need to be re-exposed. Also, note that we choose to repeat the folder name "releases" in the module name "ReleasesIndex.js".

### Fast Refresh & ReScript

Make sure to create interface files (`.resi`) for each `page/*.res` file.

Fast Refresh requires you to **only export React components**, and it's easy to unintenionally export other values than that.

### Do not use getServerSideProps

In order to ensure that this site remains a static site, do not make use of nextjs's
`getServerSideProps` functionality.

## Useful commands

Build CSS seperately via `npx postcss` (useful for debugging)

```
# Devmode
nvm use
npx postcss styles/main.css -o test.css

# Production
nvm use
NODE_ENV=production npx postcss styles/main.css -o test.css
```

## Test production setup with Next

TODO: change this to use `export` and `start` with output dir, instead of `start` directly
```
nvm use
npx yarn build
PORT=3001 npx yarn next:start
```

## Reference

This is a NextJS project using the following:

- [ReScript](https://rescript-lang.org) + React (reason-react)
- Full Tailwind config & basic css scaffold (+ production setup w/ purge-css & cssnano)

The initially structure was defined by imitating a combination of choices in the following projects, with rescriptlang.org 
usually taking precedence when there was conflicting advice:
- https://github.com/ryyppy/rescript-nextjs-template
- https://github.com/sehyunchung/rescript-nextjs
- https://github.com/reason-association/rescript-lang.org
