---
title: "Installing dependencies"
---

> **TL;DR**
> 
> ```
> opam switch create . --deps-only --with-test --with-doc
> ```
It is recommended to install the dependencies of a project in a local opam switch to sandbox your development environment.

If you're using Opam `2.0.X`, you can do this with:

```
# if you need external dependencies
opam pin add -n .
opam depext -i <packages>
opam install . --deps-only --with-test --with-doc
```

If you use Opam `2.1.X`, it will install the system dependencies automatically, so you can run:

```
opam install . --deps-only --with-test --with-doc
```

Now, if for some reason you prefer to install your dependencies in a global switch, you can run:

```
opam switch set <switch_name>
opam install . --deps-only --with-test --with-doc
```

Once the dependencies have been installed successfully, and assuming the project uses `dune` as the build system, you can compile it with:

```
opam exec -- dune build
```

Or if you set your environment with `eval $(opam env)`:

```
dune build
```
