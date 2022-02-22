---
title: Up and Running with OCaml
description: >
  Help you install OCaml, the Dune build system, and support for your favourite text editor or IDE.
users:
  - beginner
tags: [ "getting-started" ]
date: 2021-05-27T21:07:30-00:00
---

This page will help you install OCaml, the Dune build system, and support for
your favourite text editor or IDE. These instructions work on Windows, Unix
systems like Linux, and macOS.

## Installing OCaml

There are two procedures: one for Unix-like systems, and one for Windows.

### For Linux and macOS

We will install OCaml using opam, the OCaml package manager.  We will also use
opam when we wish to install third-party OCaml libraries.

**For macOS**

```
# Homebrew
brew install opam

# MacPort
port install opam
```

**For Linux** the preferred way is to use your system's package manager on
Linux (e.g `apt-get install opam` or similar). [Details of all installation
methods.](https://opam.ocaml.org/doc/Install.html)

Then, we install an OCaml compiler and some basic dev tools:

```
# environment setup
opam init
eval `opam env`

# install given version of the compiler
opam switch create 4.11.1
eval `opam env`

# install dev tools, hit Enter to confirm at Y/n prompt
opam install dune utop ocaml-lsp-server
```

Now, OCaml is up and running:

```
$ which ocaml
/Users/frank/.opam/4.11.1/bin/ocaml

$ ocaml -version
The OCaml toplevel, version 4.11.1
```

**For either Linux or macOS** as an alternative, a binary distribution of opam is
available:

```
sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
```

### For Windows

OCaml on Windows is still a work in progress. In the meantime, if you only
need to *run* OCaml programs on a Windows machine, then the simplest solution is to use the Windows Subsystem for Linux 2 (WSL2). WSL2 is a feature that allows Linux programs to run directly on Windows. WSL2 is substantially easier and faster to use than WSL1. Microsoft has comprehensive installation steps for [setting up WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

On the other hand, if you need Windows binaries, you will have to use the [OCaml for Windows](https://fdopen.github.io/opam-repository-mingw/) installer which comes in 32bit and 64bit versions. This installer gives you Opam and OCaml installations all in one go. It's used from within a Cygwin environment, but the executables produced have no dependency on Cygwin at all. For a more comprehensive update on the state of OCaml on Windows, see the [OCaml on Windows](/platform/ocaml_on_windows.html) page on the old version of the site.

## The OCaml top level (REPL)

OCaml comes with two compilers: for native code, and for byte code. We shall
use one of those in a moment. But first, let's use OCaml's top level (known as a
REPL in other languages), which we installed above:

```
$ utop
────────────────────────────────┬─────────────────────────────────────────────────────────────────────┬─────────────────────────────────
                                │ Welcome to utop version 2.8.0 (using OCaml version 4.11.1!          │                                 
                                └─────────────────────────────────────────────────────────────────────┘                                 
Findlib has been successfully loaded. Additional directives:
  #require "package";;      to load a package
  #list;;                   to list the available packages
  #camlp4o;;                to load camlp4 (standard syntax)
  #camlp4r;;                to load camlp4 (revised syntax)
  #predicates "p,q,...";;   to set these predicates
  Topfind.reset();;         to force that packages will be reloaded
  #thread;;                 to enable threads


Type #utop_help for help about using utop.

─( 12:12:45 )─< command 0 >──────────────────────────────────────────────────────────────────────────────────────────────{ counter: 0 }─
utop # 1 + 2 * 3;;
- : int = 7
```

We typed the phrase `1 + 2 * 3` and then signalled to OCaml that we had
finished by typing `;;` followed by the Enter key. OCaml calculated the
result, `7` and its type `int` and showed them to us. We exit by running the
built-in `exit` function with exit code 0:

```
─( 12:12:45 )─< command 1 >──────────────────────────────────────────────────────────────────────────────────────────────{ counter: 0 }─
utop # exit 0;;
$
```

Note that OCaml also has an older REPL, using the `ocaml` command. However, this
REPL does not have history or tab-completion, so we recommend always using utop.

## Using the Dune build system

Dune is a build system for OCaml. It takes care of all the low-level details of
OCaml compilation. We installed it with opam, above.

## A first project

Let's begin the simplest project with Dune and OCaml. We ask `dune` to
initialize a new project, and then change into the created directory:

```
$ dune init proj helloworld
Success: initialized project component named helloworld
$ cd helloworld
```

We can build our program with `dune build`:

```
$ dune build
```

When we change our program, we can type `dune build` again to make a new
executable. To run the program, we can use

```
$ dune exec ./bin/main.exe
Hello, World!
```

Or, alternatively,

```
$ dune exec hellworld
Hello, World!
```

Let's look at the contents of our new directory:

```
$ ls
bin  _build  dune-project  helloworld.opam  lib  test
```

All the build outputs generated by dune go in the `_build` directory. The
`main.exe` executable is generated inside the `_build/default/bin/`
subdirectory, so it's easier to run with `dune exec`. To ship the executable, we
can just copy `_build/default/bin/main.exe` to somewhere else.

The source code for the program is found in `./bin/main.ml` and any supporting
library code should go in `lib`.

To learn more about Dune, see the [official
documentation](https://dune.readthedocs.io/en/stable/).

## Editor support for OCaml

We installed the OCaml Language Server above with opam. With this tool, we get
editor support in **Visual Studio Code** and other editors which support the
Language Server Protocol.

Now, we will install the OCaml Platform Visual Studio Code extension from the
Visual Studio Marketplace.

Upon first loading an OCaml source file, you may be prompted to select the
toolchain in use: pick OCaml the version of OCaml you are using, e.g. 4.11.1
from the list. Now, help is available by hovering over symbols in your program:

![Visual Studio Code](/media/tutorials/vscode.png "")

**On Windows using WSL2**, you will remotely connect to your WSL2 instance from Visual Studio Code. Microsoft has a [useful blog post](https://code.visualstudio.com/blogs/2019/09/03/wsl2) covering getting WSL2 and Visual Studio Code connected.

**On Windows**, we must launch Visual Studio Code from within the Cygwin window,
rather than by clicking on its icon (otherwise, the language server will not be
found):

```
$ /cygdrive/c/Users/Frank\ Smith/AppData/Local/Programs/Microsoft\ VS\ Code/Code.exe
```

**For Vim and Emacs**, install the [Merlin](https://github.com/ocaml/merlin)
system using opam:

```
$ opam install merlin
```

The installation procedure will print instructions on how to link Merlin with
your editor.

**On Windows**, when using Vim, the default cygwin Vim will not work with
Merlin. You will need install Vim separately. In addition to the usual
instructions printed when installing Merlin, you may need to set the PATH in
Vim:

```
let $PATH .= ";".substitute(system('opam config var bin'),'\n$','','''')
```
