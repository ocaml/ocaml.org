---
title: "Updating development dependencies"
---

> **TL;DR**
> 
> Follow the workflow "Update dependencies" and add a flag `:with-test` or `with-doc` to your dependency.
Opam does not have a notion of development dependencies. Instead, each dependency can be either:

- A normal dependency (used at runtime)
- A build dependency (used to build the project)
- A test dependency (used to test the project)
- A documentation dependency (used to generate the documentation)

When adding a new dependency, as seen in the "Update dependencies" workflow, you can add a flag to your dependency.

For `dune-project`, it looks like this:

```dune
(alcotest :with-test)
```

And for the `*.opam` file, it looks like:

```opam
"alcotest" {with-test}
```

The available flags for each dependencies are:

- Normal: no flag
- Build: `build`
- Test: `with-test`
- Documentation: `with-doc`

See [opam documentation](https://opam.ocaml.org/doc/Manual.html#Package-variables) for more details on the opam syntax.
