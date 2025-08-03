---
id: using-the-ocaml-compiler-toolchain
title: Using the OCaml Compiler Toolchain
description: >
  An introduction to the OCaml compiler tools for building OCaml projects as well as the most common build tools such as Dune
category: "Guides"
language: English
---

This tutorial explains how to compile your OCaml programs into executable form.
It addresses, in turn:

1. The compilation commands `ocamlc` and `ocamlopt` provided with OCaml. It is
   useful to learn these commands to understand OCaml's compilation model.

1. The `ocamlfind` front-end to the compiler, which saves you from worrying
   about where libraries have been installed on your particular system.

1. Automatic build systems for OCaml, such as `dune`, which release us from
   details of compiler command invocation, so we never touch `ocamlc`,
   `ocamlopt`, or even `ocamlfind`.

In ["Your First OCaml Program"](/docs/your-first-program) we jumped straight to using
the automated build system `dune`. Now we shall look under the hood.

## Compilation Basics

In this section, we will first see how to compile a simple program using
only `ocamlc` or `ocamlopt`. Then we will see how to use libraries and how
to take advantage of the
[findlib](https://github.com/ocaml/ocamlfind)
system, which provides the `ocamlfind` command.

### The `ocamlc` and `ocamlopt` Compilers

OCaml comes with two compilers: `ocamlc` is the bytecode compiler, and
`ocamlopt` is the native code compiler. If you don't know which one to use, use
`ocamlopt` since it provides executables that are faster than bytecode.

But if you want to try `ocamlc`, you can go ahead and try the following.

Create a new directory named `hello` and navigate to the directory:

```shell
mkdir hello
cd hello
```

Next, create a file named `hello.ml` and add the following code with your favorite text editor:

```shell
let () = print_endline "Hello OCaml!"
```

Now, we are ready to run the code. Save the file and return to the command line. Let's compile the code:

```dune
ocamlc -o hello hello.ml
```

The `-o hello` option tells the compiler to name the output executable as `hello`. The executable `hello` contains compiled OCaml bytecode. In addition, two other files are produced, `hello.cmi` and `hello.cmo`.

`hello.cmi` contains compiled interface information for OCaml modules. An interface file includes type information and module signatures but doesn't contain the actual code.

`hello.cmo` contains the compiled bytecode for OCaml modules. Bytecode is an intermediate representation of the code that is executed by the OCaml interpreter or runtime system.

`Note:` _cmi_ stands for Compiled Module Interface and _cmo_ stands for Compiled Module Object.

Now let's run the executable and see what happens:

```shell
$ ./hello
Hello OCaml!
```

Voilà! It says, `Hello OCaml!`.

We can change the string or add more content, save the file, recompile, and rerun.

Moving on, we'll see how to use `ocamlopt`. Let's assume that our program `program` has two source files,
`module1.ml` and `module2.ml`. We will compile them to native code,
using `ocamlopt`. For now, we also assume that they do not use any other
library than the standard library, which is automatically loaded. You
can compile the program in one single step:

```shell
ocamlopt -o program module1.ml module2.ml
```

The compiler produces an executable named `program` or `program.exe`. The order
of the source files matters, and so `module1.ml` cannot depend upon things that
are defined in `module2.ml`. Please also note that you should avoid creating a file that
conflicts with a module exposed by a library you are using. For instance, if you create
a file `graphics.ml` and use the `graphics` library, the `Graphics` module exposed
from the `graphics` library will be hidden by your newly defined module, hence all
of the functions defined in it will be made inaccessible.

The OCaml distribution is shipped with the standard library, plus several other
libraries. There are also a large number of third-party libraries, for a wide
range of applications, from networking to graphics. You should understand the
following:

1. The OCaml compilers know where the standard library is and use it
   systematically (try: `ocamlc -where`). You don't have to worry much about
   it.

1. The other libraries that ship with the OCaml distribution (str, unix, etc.)
   are installed in the same directory as the standard library.

1. Third-party libraries may be installed in various places, and even a given
   library can be installed in different places from one system to another.

If your program uses the unix library in addition to the standard library, for
example, the command line would be:

```shell
ocamlopt -o program unix.cmxa module1.ml module2.ml
```

Note that `.cmxa` is the extension of native code libraries, while `.cma` is
the extension of bytecode libraries. The file `unix.cmxa` is found because it
is always installed at the same place as the standard library, and this
directory is in the library search path.

If your program depends upon third-party libraries, you must pass them on the
command line. You must also indicate the libraries on which these libraries
depend. You must also pass the -I option to `ocamlopt` for each directory where
they may be found. This becomes complicated, and this information is
installation dependent. So we will use `ocamlfind` instead, which does these
jobs for us.

### Using the `ocamlfind` Front-End

The `ocamlfind` front-end is often used for compiling programs that use
third-party OCaml libraries. Library authors themselves make their library
installable with `ocamlfind` as well. You can install `ocamlfind` using the
opam package manager, by typing `opam install ocamlfind`.

Let's assume that all the libraries you want to use have been installed
properly with ocamlfind. You can see which libraries are available in your
system by typing:

```shell
ocamlfind list
```

This shows the list of package names, with their versions. Note that most
opam packages install software using ocamlfind, so your list of ocamlfind
libraries will be somewhat similar to your list of installed opam packages
obtained by `opam list`.

The command for compiling our program using package `pkg` will be:

```shell
ocamlfind ocamlopt -o program -linkpkg -package pkg module1.ml module2.ml
```

Multiple packages may be specified using commas e.g `pkg1,pkg2`. Ocamlfind
knows how to find any files `ocamlopt` may need from the package, for example
`.cmxa` implementation files or `.cmi` interface files, because they have been
packaged together and installed at a known location by ocamlfind. We need only
the name `pkg` to refer to them all - ocamlfind does the rest.

Note that you can compile the files separately. This is useful if
you want to recompile only some parts of the programs. Here are the
equivalent commands that perform a separate compilation of the source
files and link them together in a final step:

```shell
ocamlfind ocamlopt -c -package pkg module1.ml
ocamlfind ocamlopt -c -package pkg module2.ml
ocamlfind ocamlopt -o program -linkpkg -package pkg module1.cmx module2.cmx
```

Separate compilation (one command for `module1.ml`, another for `module2.ml`
and another to link the final output) is usually not performed manually but
only when using an automated build system that will take care of recompiling
only what is necessary.

## Interlude: Making a Custom Toplevel

OCaml provides another tool `ocamlmktop` to make an interactive toplevel with
libraries accessible. For example:

```shell
ocamlmktop -o toplevel unix.cma module1.ml module2.ml
```

We run `toplevel` and get an OCaml toplevel with modules `Unix`, `Module1`, and
`Module2` all available, allowing us to experiment interactively with our
program.

OCamlfind also supports `ocamlmktop`:

```shell
ocamlfind ocamlmktop -o toplevel unix.cma -package pkg module1.ml module2.ml
```

## Dune: An Automated Build System

The most popular modern system for building OCaml projects is
[dune](https://dune.readthedocs.io/en/stable/) which may be installed with
`opam install dune`. It allows one to build OCaml projects from a simple
description of their elements. For example, the dune file for our project might
look like this:

```dune
;; our example project
(executable
  (name program)
  (libraries unix pkg))
```

The dune [quick-start
guide](https://dune.readthedocs.io/en/latest/quick-start.html) shows you how to
write such description files for more complicated situations, and how to
structure, build, and run dune projects.

### Bytecode Using Dune

Dune is a build system for OCaml projects, and it allows you to configure different modes for building your executables. We will use `(modes byte exe)` stanza in the `dune` file, which will produce both bytecode (interpreted) and native executable versions of the OCaml program.

Let's create an example project named `myproject`.

```dune
mkdir myproject
cd myproject
```

Create a `dune-project` file, add the following content.

```lisp
(lang dune 3.0)
(name myproject)
```

Here, 3.0 is the installed version of `Dune`. You can check it by typing `dune --version` on your terminal. And the `name` is the name of the project, i.e., `myproject`.

Create a `dune` file, add the following content.

```lisp
(executable
 (name main)
 (libraries base)
 (modes byte exe))
```

As aforementioned, `(modes byte exe)` stanza produces both bytecode (interpreted) and native executable versions of our OCaml program.

Next, create a `main.ml` file, add the following content.

```ocaml
let () = print_endline "Hello Dune!"
```

Finally, we compile and execute it.

```shell
dune build main.bc
```

The `.bc` stands for generic bytecode file, and it can be an executable or library.

```shell
$ dune exec ./main.bc
Hello Dune!
```

We can also do that with `.exe`.

```shell
dune build main.exe
```

```shell
$ dune exec ./main.exe
Hello Dune!
```

## Other Build Systems

- [OMake](https://github.com/ocaml-omake/omake) Another OCaml build system.
- [GNU make](https://www.gnu.org/software/make/) GNU make can build anything, including OCaml. May be used in conjunction with [OCamlmakefile](https://github.com/mmottl/ocaml-makefile)
- [Oasis](https://github.com/ocaml/oasis) Generates a configure, build, and install system from a specification.
