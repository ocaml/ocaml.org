---
id: modules-libraries-dune
title: Modules and Libraries in Dune
description: >
  Learn about the features of Dune that interact with the OCaml module system
category: "Module System"
---

# Modules and Libraries in Dune

## Introduction

The goal of this tutorial is to teach the mechanisms built in Dune that allow the processing of OCaml modules.

This tutorial uses the [Dune](https://dune.build) build tool. Make sure you have version 3.7 or later installed.

**Requirements**: [Modules](/docs/modules) and [Functors](/docs/modules).

## Minimum Project Setup

This section details the structure of an almost-minimum Dune project setup. Check [Your First OCaml Program](/docs/your-first-program) for automatic setup using the `dune init proj` command.
```shell
$ mkdir mixtli; cd mixtli

$ touch mixtli.opam
```

In this directory, create four more files: `dune-project`, `dune`, `cloud.ml`, and `wmo.ml`:

**`dune-project`**
```lisp
(lang dune 3.7)
```

This file contains the global project configuration. It's kept to the bare minimum, including the `lang dune` stanza that specifies the required Dune version.

**`dune`**
```lisp
(executable
  (name cloud)
  (public_name nube))
```

Each folder that requires some sort of build must contain a `dune` file. The `executable` stanza means an executable program is built.
- The `name cloud` stanza means the file `cloud.ml` contains the executable.
- The `public_name nube` stanza means the executable is made available using the name `nube`.

**`wmo.ml`**
```ocaml
module Stratus = struct
  let cumulus = "stratocumulus (Sc)"
end

module Cumulus = struct
  let stratus = "stratocumulus (Sc)"
end
```

**`cloud.ml`**
```ocaml
let () =
  Wmo.Stratus.cumulus |> String.capitalize_ascii |> print_endline;
  Wmo.Cumulus.stratus |> String.capitalize_ascii |> print_endline
```

Here is the resulting output:
```shell
$ dune exec nube
Stratocumulus (Sc)
Stratocumulus (Sc)
```


Here is the folder contents:
```shell
$ tree
.
├── mixtli.opam
├── dune
├── dune-project
├── cloud.ml
└── wmo.ml
```

This is sufficient to build and execute the project:
```shell
$ dune exec nube
Cumulostratus (Cb)
Cumulostratus (Cb)
```

Dune stores the files it creates in a folder named `_build`. In a project managed using Git, the `_build` folder should be ignored
```shell
$ echo _build >> .gitignore
```

In OCaml, each source file is compiled into a module. In the `mixtli` project, the file `cloud.ml` creates a module named `Cloud`.

Observe the roles of the different names:
* `mixtli` is the project's name (it means *cloud* in Nahuatl).
* `cloud.ml` is the OCaml source file's name, referred as `cloud` in the `dune` file.
* `nube` is the executable command's name.
* `Cloud` is the name of the module associated with the file `cloud.ml`.

The `dune describe` command allows having a look at the project's module structure. Here is its output:
```lisp
((root /home/cuihtlauac/mixtli)
 (build_context _build/default)
 (executables
  ((names (cloud))
   (requires ())
   (modules
    (((name Cloud)
      (impl (_build/default/cloud.ml))
      (intf ())
      (cmt (_build/default/.cloud.eobjs/byte/cloud.cmt))
      (cmti ()))))
   (include_dirs (_build/default/.cloud.eobjs/byte)))))
```

## Libraries

When using Dune (with its default settings), an OCaml _library_ is a module aggregating other modules, bottom-up. This contrasts with the `struct ... end` syntax where modules are aggregated top-down by nesting submodules into container modules. Dune creates libraries from folders, like the following:
```shell
$ mkdir lib
$ rm wmo.ml
```

**`lib/dune`**
```lisp
(library (name wmo))
```

All the modules found in the `lib` folder are bundled into the `Wmo` module.

**`lib/cumulus.mli`**
```ocaml
val v : string
val stratus : string
```

**`lib/cumulus.ml`**
```ocaml
let latin_root = "cumul"
let v = latin_root ^ "us (Cu)"
let stratus = "strato" ^ latin_root ^ "us (Sc)"
```

**`lib/stratus.mli`**
```ocaml
val v : string
val cumulus : string
```
**`lib/stratus.ml`**
```ocaml
let latin_root = "strat"
let v = latin_root ^ "us (St)"
let cumulus = latin_root ^ "ocumulus (Sc)"
```

The executable and the corresponding `dune` file need to be updated to use the defined library as a dependency.

**`dune`**
```lisp
(executable
  (name cloud)
  (public_name nube)
  (libraries wmo))
```



**Observations**:
* Dune creates a module `Wmo` from the contents of folder `lib`.
* The folder's name (here `lib`) is irrelevant.
* The library name appears uncapitalised (`wmo`) in `dune` files:
  - In its definition, in `lib/dune`
  - When used as a dependency in `dune`

## Library Wrapper Modules

By default, when Dune bundles modules into a library, they are wrapped into a module. It is possible to bypass Dune's behaviour by manually writing the wrapper file.

This `lib/wmo.ml` is the wrapper file that corresponds to the module that Dune automatically generated in the previous section.

**`lib/wmo.ml`**
```ocaml
module Cumulus = Cumulus
module Stratus = Stratus
```

Here is how to make sense of these module definitions:
- On the left-hand side, `module Cumulus` means module `Wmo` contains a submodule named `Cumulus`.
- On the right-hand side, `Cumulus` refers to the module defined in the files `lib/cumulus.ml` and `lib/cumulus.mli`.

Check with `dune exec nube` to ensure the program's behaviour is the same as in the previous section.

When a library folder contains a wrapper module (here `wmo.ml`), it is the only one exposed. A file-based module that does not appear in the wrapper module is private.

Using a wrapper file makes several things possible:
- Have different public and internal names, `module CumulusCloud = Cumulus`
- Define values in the wrapper module, `let ... = `
- Expose module resulting from functor application, `module StringSet = Set.Make(String)`
- Apply the same interface type to several modules without duplicating files

## Include Subdirectories

By default, Dune builds libraries from modules found in folders, but it doesn't look into subfolders. It is possible to change this behaviour.

In this example, we create subdirectories and move files there.
```shell
$ mkdir lib/cumulus lib/stratus
$ mv lib/cumulus.ml lib/cumulus/m.ml
$ mv lib/cumulus.mli lib/cumulus/m.mli
$ mv lib/stratus.ml lib/stratus/m.ml
$ mv lib/stratus.mli lib/stratus/m.mli
```

Change from the default behaviour with the `include_subdirs` stanza.

**`lib/dune`**
```lisp
(include_subdirs qualified)
(library (name wmo))
```

Update the library wrapper to expose the modules created from the subdirectories.

**`wmo.ml`**
```ocaml
module Cumulus = Cumulus.M
module Stratus = Stratus.M
```

Check with `dune exec nube` that the behaviour of the program is the same as in the previous sections.

## Conclusion

The OCaml module system allows organizing a project in many ways. Dune provides several means to generate modules embodying some possible ways.

