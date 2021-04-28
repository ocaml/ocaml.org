Typed and Versioned Data for OCaml.org
--------------------------------------

*Status: WIP & Experimental* 

This repository contains data for the OCaml.org website along with a suite of tools for managing that data. In particular: 

 - `data`: stores all of the data
 - `lib`: consumed by `src/lib`, this library (called `ood`) simply exposes the types for the various bits of data. The reason for the separation is to have the types exposed with zero dependencies. This should make it possible for lots of different platforms to consume that library (ReScript for example).
 - `src`: contains the code for `ood-cli`, a CLI tool for linting the data, producing the Netlify CMS configuration etc. 
 - `lib_netlify`: contains a library that encodes the [Netlify CMS](https://www.netlifycms.org/) configuration in OCaml.
 - `config.yml`: this is the current version of the configuration file for the `data` repository that is kept up to date via `dune runtest`.