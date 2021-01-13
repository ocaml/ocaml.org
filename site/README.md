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
* Clone your fork locally (or continue editing directly in github if the change is small). Checkout
out the branch that you created.
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

## Setup and Development

If you don't already have `nvm` installed, install it using the instructions
provided by `nvm` https://github.com/nvm-sh/nvm#installing-and-updating . Restart
or reload your terminal to pickup the changes.

```
# 1. Ensure you have the correct node version by installing it, if it's not present already
# 2. Using installed node version, install yarn and install dependencies
# 3. Run ReScript in dev mode
nvm install && npx yarn@1.22 install && npx yarn rescript:start
```

In another tab, run the Next dev server in the background:

```
nvm install && npx yarn next:dev &
```

The output from the next dev server is rarely interesting, so we run it in the background. 
This frees up the second terminal for performing `git` commands.

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

### Do not use getServerSideProps

In order to ensure that this site remains a static site, do not make use of nextjs's
`getServerSideProps` functionality.

### Prefer Simplicity over Accomodating Fast Refresh

We choose to not complicate this project to accomodate Fast Refresh.


## Useful commands

Build CSS seperately via `npx postcss` (useful for debugging)

```
nvm install && npx postcss styles/main.css -o /tmp/test.css
```

## Test production setup with Next

TODO: change this to use `export` and `start` with output dir, instead of `start` directly
```
nvm install
npx yarn build
PORT=3001 npx yarn next:start
```

## Reference

This is a NextJS project using the following:

- [ReScript](https://rescript-lang.org) + React (reason-react)
- Full Tailwind config & basic css scaffold
- Mdxjs (via next-mdx-remote)

The initial structure was defined by imitating a combination of choices in the following projects, with
rescriptlang.org taking precedence when there was conflicting advice:

- https://github.com/ryyppy/rescript-nextjs-template
- https://github.com/reason-association/rescript-lang.org
- https://github.com/vercel/next.js/tree/canary/examples/with-tailwindcss
- https://github.com/vercel/next.js/tree/canary/examples/with-mdx-remote
- (add more links: ...)
