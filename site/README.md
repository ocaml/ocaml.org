# ocaml.org

## Issue workflow

Feel free to use any approach that you prefer. The dev team
suggests the following:
- create an issue noting your intent to start work and ask
any clarifying questions or discuss approach, if needed
- fork the repo
- either work in the master branch, or create your own branch with
a useful name
- add a small initial commit and create a draft PR from your repo branch to the original repo
- continue developing, feel free to ask questions in your issue or
the PR, if you run into obstacles or uncertainty as you make changes
- once you feel your branch is ready, check the PR preview to ensure the changes
match your local view and appear correct
- change PR status to "ready to review"

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

ReScript can only handle one module named "index". This clashes with nextjs
page-based routing, which expects the filepath starting from `/pages/` to match
the route exposed. So, in order to completely avoid any problems from this issue,
we always create pages in `res_pages/` and create a symlink `cd pages/releases &&
ln -s ../../res_pages/releases/releases_index.js index.js`. Also, note that
we choose to repeat the folder name "releases" in the module name "releases_index.js".

### Fast Refresh & ReScript

Make sure to create interface files (`.resi`) for each `page/*.res` file.

Fast Refresh requires you to **only export React components**, and it's easy to unintenionally export other values than that.

### Do not use getServerSideProps

In order to ensure that this site remains a fully static, do not make use of nextjs's
`getServerSideProps` functionality.

## Useful commands

Build CSS seperately via `npx postcss` (useful for debugging)

```
# Devmode
npx postcss styles/main.css -o test.css

# Production
NODE_ENV=production npx postcss styles/main.css -o test.css
```

## Test production setup with Next

TODO: change this to use `export` and nginx instead of `start`
```
npx yarn build
PORT=3001 npx yarn next:start
```

## Reference

This is a NextJS project using the following:

- [ReScript](https://rescript-lang.org) + React (reason-react)
- Full Tailwind config & basic css scaffold (+ production setup w/ purge-css & cssnano)
