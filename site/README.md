# ReScript NextJS Starter

This is a NextJS based template with following setup:

- Full Tailwind config & basic css scaffold (+ production setup w/ purge-css & cssnano)
- [ReScript](https://rescript-lang.org) + React
- Basic ReScript Bindings for Next
- Preconfigured Dependencies: `reason-react`

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
npx yarn@1.22 res:start
```

In another tab, run the Next dev server:

```
npx yarn@1.22 dev
```


## Tips

### Filenames with special characters

ReScript > 8.3 now supports filenames with special characters: e.g. `pages/blog/[slug].res`.

### Fast Refresh & ReScript

Make sure to create interface files (`.resi`) for each `page/*.res` file.

Fast Refresh requires you to **only export React components**, and it's easy to unintenionally export other values than that.

## Useful commands

Build CSS seperately via `npx postcss` (useful for debugging)

```
# Devmode
npx postcss styles/main.css -o test.css

# Production
NODE_ENV=production postcss styles/main.css -o test.css
```

## Test production setup with Next

```
# Make sure to uncomment the `target` attribute in `now.json` first, before you run this:
npx yarn@1.22 build
PORT=3001 npx yarn@1.22 start
```

