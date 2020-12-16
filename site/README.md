# ocaml.org

## Issue workflow

### Contributor

Feel free to use any approach that you prefer. The dev team
suggests the following:
- Create an issue noting your intent to start work and ask
any clarifying questions or discuss approach, if needed
- Fork the repo
- Add a small initial commit (e.g. change any file using Github directly) and 
create a draft PR from your repo to the original repo. If you created an issue, 
note the issue in your PR description
- Clone your fork locally
- Continue developing, feel free to ask questions in your issue or
the PR, if you run into obstacles or uncertainty as you make changes
- Once you feel your branch is ready, check the PR preview to ensure the changes
match your local view and appear correct
- Change PR status to "ready to review"
- Update the PR description to indicate relative paths that have changed

### Reviewer
- Observe the relative paths changed in latest PR Preview
...
- Use "squash and merge", summarizing commit messages

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
