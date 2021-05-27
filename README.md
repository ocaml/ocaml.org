Typed and Versioned Data for OCaml.org v3
-----------------------------------------

Status: Not yet open for contributions. Contact @avsm.

This repository contains data for the OCaml.org website along with a suite of
tools for managing that data. In particular:

 - `data`: stores all of the data
 - `lib`: consumed by `src/lib`, this library (called `ood`) simply exposes the types for the various bits of data. The reason for the separation is to have the types exposed with zero dependencies. This should make it possible for lots of different platforms to consume that library (ReScript for example).
 - `src`: contains the code for `ood-cli`, a CLI tool for linting the data, producing the Netlify CMS configuration etc. 
 - `lib_netlify`: contains a library that encodes the [Netlify CMS](https://www.netlifycms.org/) configuration in OCaml.
 - `config.yml`: this is the current version of the configuration file for the `data` repository that is kept up to date via `dune runtest`.

For more information about the ocaml.org site, please see the main repository
at <https://github.com/ocaml/v3.ocaml.org>.

**Current OCaml Version: 4.10.2** -- in order for the mdx tests to be consistent (for example some list the functions available from the `List` module) you should only run them with the current version of OCaml this repository is using. 

## Editing Content

The Netlify CMS library along with the `ood-cli` tool package up a little [cohttp](https://github.com/mirage/ocaml-cohttp) server for testing the CMS set-up. At some point in the future this could probably be made to handle OAuth but for now it is just meant for local development and it is the recommended way for changing any of the data in the `data` directory. Why? Because it whenever it writes to that directory it uses a specific yaml layout and style which will overwrite hand-made changes if you don't adhere to that style. 

To get it up and running, after running `dune build && dune install` from one terminal you can run the server from the root of the repository: 

```sh
ood-cli serve
```

And from another terminal you need to run the Netlify CMS proxy server. This is the one that instead of doing any requests to a backend like Github, it instead will do everything to the local filesystem. 

```
npx netlify-cms-proxy-server
```

You should now be able to navigate to `localhost:8080/admin` and edit away!
