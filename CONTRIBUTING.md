# Contributing to Ood

The **O**Caml.**o**rg **D**ata repository contains the data for ocaml.org in a structured format. Contributions are very welcome whether that be:

 - Importing missing data from the ["v2" site](https://github.com/ocaml/ocaml.org)
 - Adding new data to existing collections (e.g. a new university course to our Academic Institutions section)
 - A completely new collection of data, this can be done but it is a little trickier to integrate
 - Fixes for typos
 - Translations

## Setting up the Project

The `Makefile` contains many commands that can get you up and running, a typical workflow will be to clone the repository after forking it.

```
git clone https://github.com/<username>/ood.git
cd ood
```

From the root of your project, the simplest way to get set up is to create a [local opam switch](https://opam.ocaml.org/doc/Manual.html#Switches) and install the dependencies. There 
is a single `make` target to do just that.

```
make switch
```

If you don't want a local opam switch and are happy to install everything globally (in the opam sense) then you can just install the dependencies directly. Note, we use the `4.10.2` compiler because our tutorials require a specific compiler version.

```
make deps
```

Note we use [tailwind-css](https://tailwindcss.com/) in `ood-preview` so we also install that using npm.

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
 - Make sure it builds: running `make build`
 - Run the tests: this will check ood-preview and that all the data is correctly formatted and can be invoked with `make test`

## Ood Preview

`ood-preview` is a simple dream server rendering the data as HTML. This is useful for testing designs, ensuring links to videos are correct etc. There is no obligation to touch any of this code, but you might find it fun to play around with designs and learn a little bit about dream.

To run the server just execute `make preview` from the terminal. This sets up a live-reload script so when you change a template file the project should recompile and the browser window will refresh.

## Testing my changes against v3.ocaml.org

[v3.ocaml.org](https://github.com/ocaml/v3.ocaml.org) vendors ood in order to reuse the data. Our CI checks that a PR doesn't break any assumptions that v3 makes about types or functions that are exposed from the `src/ood` package.

If you want to test it before hand, have a look at the change we make to the `update-ood.sh` script in the `v3-ocaml-org` Github Action job in `.github/workflows/ci.yml`. Instead of checking out `main` we check out the PR reference.
