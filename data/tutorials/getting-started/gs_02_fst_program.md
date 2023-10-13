---
id: how-to-write-an-ocaml-program
title: How to Write an OCaml Program
description: >
  Get something real out of the damm French thing!
category: "Getting Started"
---

# How to Write an OCaml Program

> [...] diviser chacune des difficultés que j'examinerais, en autant de
> parcelles qu'il se pourrait, et qu'il serait requis pour les mieux résoudre.

&mdash; René Descartes, _Discours de la méthode_

In this tutorial, we start working with files containing OCaml source code and compiling them to produce excutable binaries. However, this is not a detailed tutorial on OCaml compilation, project modularisation, or dependencies management; it only gives a glimpse at those topics. The goal is to sketch the bigger picture before extensively presenting topics in order to avoid getting lost in the details.

In other words, we do breadth-first learning instead of depth-first learning. In the previous tutorial most commands were entered in Utop, in this tutorial, the majority of commands should be entered into a terminal. Code examples starting with a dollar sign `$` are intended to be entered in the terminal, while lines starting with a hash sign `#` are intended to be entered in Utop.

## Prerequisites and Goals

This tutorial is the last part of a two-part series. Please ensure you have completed [A Tour of OCaml](/docs/a-tour-of-ocaml) before proceeding onto your first OCaml project. You will need to have [installed OCaml](/install).

Once you've completed this tutorial, you should be able to:
- Create an OCaml project from scratch, using Dune or manually
- Trigger prject compilation and execution using Dune
- Delete files in an automatically created project without breaking everything
- Split code in several files, use imported definitions
- Make a definition private
- Download, install and use a package from the open source repository

How to work on several OCaml projects simultaneously is out of the scope of this tutorial. Currently (summer 2023), this requires using Opam local [_switches_](https://opam.ocaml.org/doc/man/opam-switch.html). This allows handling different sets of dependencies per project. Check the Best Practices document on [Dependencies](https://ocaml.org/docs/managing-dependencies) addressing that matter for detailed instructions. This document was writen and tested using a global switch, which is created by default when installing Opam and can be ignored in the beginning.

## Compiling OCaml Programs

By default, OCaml comes with two compilers, one translating sources into native binaries and another turning sources into a bytecode format. OCaml also comes with an interpreter for that bytecode format. Other compilers exist, for instance, [js_of_ocaml](https://ocsigen.org/js_of_ocaml) generates JavaScript. The toplevel uses the bytecode compiler; expressions are read, type-checked, compiled into bytecode and executed. The previous tutorial was interactive because we used the toplevel. This tutorial gives a glimpse at batch processing only using the native compiler.

We start by setting up a traditional “Hello World!” project using Dune, OCaml’s build system. Make sure to have installed version 3.7 or later. The following creates a project named `hello`:

```shell
$ dune init proj hello
Entering directory '/home/cuihtlauac/caml/ocaml.org/hello'
Success: initialized project component named hello
```

Note: Throughout this tutorial, outputs generated Dune might vary slightly because of the Dune version installed. This tutorial shows the output for Dune 3.7. If you'd like to get the most recent version of Dune, run `opam update; opam upgrade dune` in a terminal.

The project is stored in a directory named `hello`. The `tree` command lists the files and directories created. It might be necessary to install `tree` if you don't see the following. Through Homebrew, for example, run `brew install tree`.

Note: If you get an error in Homebrew from this in an Apple silicon macOS, it's likely an issue with the architecture switch from Intel to ARM. Please refer to the [ARM64 Fix](FIXME) to remedy the ARM64 error.
```shell
$ cd hello
$ tree
.
├── bin
│   ├── dune
│   └── main.ml
├── _build
│   └── log
├── dune-project
├── hello.opam
├── lib
│   └── dune
└── test
    ├── dune
    └── hello.ml

4 directories, 8 files
```

OCaml source files have `.ml` extension, which stands for “Meta Language.” Meta Language (ML) is the ancestor of OCaml, this is also what the “ml” stands for in “OCaml.” Here is the content of the `bin/main.ml` file:
```ocaml
let () = print_endline "Hello, World!"
```

The project-wide metadata is available in the `dune-project` file. Each folder containing source files that need to be built must contain a `dune` file explaining how.

This builds the project:
```shell
$ dune build
Entering directory '/home/cuihtlauac/caml/ocaml.org'
```

This launches the executable it creates:
```shell
$ dune exec hello
Entering directory '/home/cuihtlauac/caml/ocaml.org'
Hello, World!
```

Let's see what happens when we edit the `bin/main.ml` file directly. Navigate into it and replace the world `World` with your first name. Recompile the project with `dune build` as before, and then launch it again with `dune exec hello`.

Voilà! You've just written your first OCaml program.

In the rest of this tutorial, we will make more changes to this project in order to illustrate OCaml's tooling.

## Why Isn't There a Main Function?

Although `bin/main.ml`'s name suggests it contains the application entry point into the project, it does not contain a dedicated `main` function, and there is no requirement that a project contain a file with that name in order to produce an executable. OCaml behaves equivalently as an apparently interpreted and a compiled language: an executable produced by the compiler from a file behaves as though that file were entered line by line into the toplevel. In other words, an executable OCaml file's entry point is its first line.

That's why double semicolons aren't needed in source files like they are in the toplevel. Statements are just processed in order from top to bottom, each triggering the side effects it may have. Definitions are added to the environment. Values resulting from nameless expressions are ignored. Side effects from all those will take place in the same order. That's OCaml main.

However, it is common practice to single out a value that triggers all the side effects and mark it as the intended main entry point. In OCaml, that's the role of `let () =`, which stands for “definition which doesn't create a name” and actually indicates we're only interested in the side effects of the value on the right.

## Modules and the Standard Library, Cont'd

Let's summarise what was said about modules in the previous tutorial:
- Modules are bundles of named values
- Identical names from distinct modules don't clash
- The standard library is a bunch of modules

In addition to that, modules aid in organising projects. Concerns can be separated into isolated modules. This is outlined in the next section. Before creating a module ourselves, we'll demonstrate using a definition from a module in the standard library. Edit the file `bin/main.ml` into this:
```ocaml
let () = Printf.printf "%s!\\n" "Hello, World!"
```

This replaces the function `print_endline` with the function `printf` from the `Printf` module in the standard library. Building and executing this modified version should produce almost the same output as before. Use `dune exec hello` to try it for yourself.

## Every File Defines a Module

Most importantly, each OCaml file defines a module, once compiled. This is how separate compilation works in OCaml. Each sufficiently standalone concern should be isolated into a file-based module. References to external modules create dependencies. Circular dependencies between modules are not allowed.

To create a module, let's create a file named `lib/hello.ml` containing this:
```ocaml
let world = "Hello from a module"
```

Here is a new version of the `bin/main.ml` file:
```ocaml
 let () = Printf.printf "%s\n" Hello.world'
 ```

And execution of the resulting project:
 ```shell
 $ dune exec hello
Entering directory '/home/cuihtlauac/caml/ocaml.org'
Hello from a module
```

The file `lib/hello.ml` contains the module named `Hello`, which in turn defines a string named `world`. This definition is referred to as `Hello.world` from the `bin/main.ml` file.

Dune can launch UTop to access to the modules exposed by a project interactively. Here's how:
```shell
$ dune utop
```

Then, inside the `utop` toplevel, it is possible to inspect our `Hello` module, just like we did when we examined the `Option` module in the previous tutorial.
```ocaml
# #show Hello;;
module Hello : sig val world : string end
```

Now exit `utop` with `Ctrl-D` or enter `#quit;;` before going to the next section.

## Defining Module Interfaces

UTop's `#show` command displays an [API](https://en.wikipedia.org/wiki/API#Libraries_and_frameworks) (in the software library sense): the list of definitions provided by a module. In OCaml, this is called a _module interface_. An `.ml` file defines a module. In a similar way, an `.mli` file defines a module interface. A module interface file must be attached to a module file. To do that, an `.mli` file must have the same base name part as its attached `.ml` file. Create a `lib/hello.mli` file with this content:
```ocaml
val world : string
```

Observe that only what is between `sig` and `end` has been written in the interface file `lib/hello.mli`. This is explained in the tutorial dedicated to [modules](/docs/modules).

Module interfaces are also used to create _private_ definitions. A module definition is private if it is not listed in its corresponding interface. If no interface file exists, everyting is public.

In your preferred editor, amend the `lib/hello.ml` file to add the `mundo` definition. Replace what's there with the following:

```ocaml
let mundo = "Hola Mundo!"
let world = mundo
```

Also edit the `bin/main.ml` file like this:
```ocaml
let () = Printf.printf "%s\n" Hello.mundo
```

Trying to compile this fails.
```shell
$ dune build
Entering directory '/home/cuihtlauac/caml/ocaml.org'
File "hello/bin/main.ml", line 1, characters 30-41:
1 | let () = Printf.printf "%s\n" Hello.mundo
                                  ^^^^^^^^^^^
Error: Unbound value Hello.mundo
```

This is because we haven't changed `lib/hello.mli`. Since it does not list `mundo`, it is therefore private.

## Installing and Using Modules from a Package

OCaml has an active community of open-source contributors. Most projects are avaiable using the opam package manager, which you installed in the [Install OCaml](/docs/up-and-ready) tutorial. The following section shows how to install and use a package from opam's open-source repository.

To illustrate this, let's turn our modest `hello` project into a web server using [Anton Bachin](https://github.com/aantron)'s [Dream](https://aantron.github.io/dream/) web framework. First install the `dream` package with this command:
```shell
$ opam install dream
```

Next, call the framework in the `bin/main.ml` file by changing the code to read:
```ocaml
let () = Dream.(run (router [ get "/" (fun (_ : request) -> html Hello.world) ]))
```

Before detailing how things works, let's explain how Dream types works.

The function type `request -> response promise` is the type of request handlers. Functions of this type take an HTTP request and returns an HTTP response. The response is wrapped in a promise. This prevents the server from waiting for the response to be ready before sending it and also allows processing multiple requests concurently. The type route `route` represents the binding between a URL path and a handler.

Let's detail the roles of each piece:
- `run` triggers the execution of the server process. Its parameter is a handler function.
- `router` turns a list of `route` values into a single handler binding them together.
- `get "/"` declares a route, HTTP GET requests to the `/` path are handled by the provided function.
- `(fun (_ : request) -> ...)` this a handler function. The typed pattern `(_ : request)` means the data from the request is ignored.
- `html Hello.world` has type `response promise`. When data inside the promise becomes available, the server will send with it. In our case, it is imediately avaiable as it is a static constant stored in memory.

In summary, this is telling: “run a web server responding with the content of `Hello.world` to requests to the '/' path”

The `Dream.(` syntax stands for locally opening a module inside an expression.

Finally, tell Dune it is going to need Dream to compile the project. Do this by just adding the last line below. This puts `dream` in the `library` stanza of the `bin/dune` file.
```lisp
(executable
 (public_name hello)
 (name main)
 (libraries hello dream))
```

Launch the server from a new terminal.
```shell
$ dune exec hello
20.07.23 13:14:07.801                       0
20.07.23 13:14:07.801                       Type Ctrl+C to stop
```

Note: If on macOS a key icon is displayed, like when asking for a password, you can ignore it and type Ctrl+C to get back to the command prompt.

Then test from another:
```shell
$ curl http://localhost:8080/
¡Hola Mundo!
```

## Using the Preprocessor to Generate Code

Let's assume we'd like `hello` to display its output as if it was a list of strings in UTop: `["hello"; "using"; "an"; "opam"; "library"]`. To do that, we need a function turning a `string list` into a `string`, adding brackets, spaces, and commas. Instead of defining it ourselves, let's generate it automatically with a package. We'll use [`ppx_show`](https://github.com/thierry-martinez/ppx_show), which was written by [Thierry Martinez.](https://github.com/thierry-martinez) Here is how to install it:
```shell
$ opam install ppx_show
```

Dune needs an explanation as to why we're using it, so edit the `lib/dune` file to look like this:
```lisp
(library
 (name hello)
 (preprocess (pps ppx_show))
 (libraries ppx_show.runtime))
```

Here is the meaning of the two new lines:
- `(libraries ppx_show.runtime)` means our project is using definitions found in the `ppx_show.runtime` library, provided by the package `ppx_show`;
- `(preprocess (pps preprocess))` means that before compilation the source needs to be transformed using the preprocessor provided by the package `ppx_show`.

The files `lib/hello.ml` and `lib/hello.mli` need to be edited, too:

##### `lib/hello.mli`
```ocaml
val string_of_string_list : string list -> string
val world : string list

```
##### `lib/hello.ml`
```ocaml
let string_list_pp = [%show: string list]

let string_of_string_list = Format.asprintf "@[%a@]" string_list_pp

let world = String.split_on_char ' ' "Hello using an opam library"
```

Let's read this from the bottom up:
- `world` has the type `string list`. We're using `String.split_on_char` to turn a `string` into a `string list` by splitting the string on space characters.
- `string_of_string_list` has type `string list -> string`. This converts a list of strings into a string, applying the expected formatting.
- `string_list_pp` has type `Format.formatter -> string list -> unit`, which means it is a custom formatter that turns a `string list` into a `string` (this type does not appear in the signature).

Finally, you'll also need to edit `bin/main.ml`
```ocaml
let () = print_endline Hello.(string_of_string_list world)
```

Here is the result:
```shell
dune exec hello
Entering directory '/home/cuihtlauac/caml/ocaml.org'
Done: 90% (19/21, 2 left) (jobs: 1)["Hello"; "using"; "an"; "opam"; "library"]
```

## A Sneak-Peek at Dune as a One-Stop Shop

This section explains the purpose of the files and folders created by `dune proj init` which haven't been mentioned earlier.

Along the history of OCaml, several build systems have been used. As of writing this tutorial (Summer 2023), Dune is the mainstream one, which is why it is used in the tutorial. Dune automatically extracts the dependencies between the modules from the files and compiles them in a compatible order. It only needs one `dune` file per folder where there is something to build. The three folders created by `dune proj init` have the following purposes:
- `bin`: executable programs
- `lib`: libraries
- `test`: tests

There will be a tutorial dedicated to Dune. This tutorial will present the many features of Dune. Let's just list a few ones here:
- Running tests
- Generating documentation
- Producing packaging metadata (here in `hello.opam`)
- Creating arbitrary files using all-purpose rules

The `_build` folder is where Dune stores all the files it generates. It can be deleted at any time, but subsequent builds will recreate it.

## Minimum Setup

In this last section, let's create a bare minimum project, highlighting what's really needed for Dune to work. We begin by creating a fresh project folder:
```shell
$ cd ..
$ mkdir minimo
$ cd minimo
```

At the very least, Dune only needs two files: `dune-project` and one `dune` file. Here is how to write them with as little text as possible:

`dune-project`
```lisp
(lang dune 3.6)
```

`dune`
```lisp
(executable (name minimo))
```

`minimo.ml`
```ocaml
let () = print_endline "My name is Minimo"
```

That's all! This is sufficient for Dune to build and execute the `minimo.ml` file.
```shell
$ dune exec ./minimo.exe
Entering directory '/home/cuihtlauac/caml/ocaml.org'
My name is Minimo
```

Note that `minimo.exe` is not a file name. This is how Dune is told to compile the `minimo.ml` file using OCaml's native compiler instead of the bytecode compiler. As a fun fact, note that an empty file is valid OCaml syntax. You can use that to reduce `minimo` even more; of course, it will not display anything, but it will be a valid project!

## Conclusion

This tutorial was the third and last of the introduction series. Starting from here, you have enough to pick and choose among the other tutorials to follow your own learning path.

If you're not yet familiar with functional programming, we recommend you start with the [Lists](/docs/lists) tutorial. Lists are such an important data structure in functional programming that they deserve to be among the first topics you master.

If you're already familiar with lists, maps, and folds, and need to be productive as fast as possible, dive into the “Project Quickstart” guide.




