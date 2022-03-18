---
id: up-and-running
title: Get Up and Running with OCaml
description: |
  This page will help you install OCaml, the Dune build system, and support for
  your favourite text editor or IDE. These instructions work on Windows, Unix
  systems like Linux, and macOS.
category: "getting-started"
date: 2021-05-27T21:07:30-00:00
---

# Get Up and Running with OCaml

This page will walk you through the installation of OCaml and the Dune build system, as well as offer support for
your favourite text editor or IDE. These instructions work on Unix-based systems like Linux and macOS, and there are also instructions on how to install OCaml on Windows.

## Installing OCaml

It's a straightfoward process to install OCaml; however you will need [Homebrew](https://brew.sh/) or [MacPorts](https://www.macports.org/) if you're running Linux or macOS. [Opam](https://opam.ocaml.org/) is OCaml's package manager, so we'll install it first. You will also use Opam when installing third-party OCaml libraries.

Find the all installation instructions for both Unix-like systems and Windows below. If you're new to the CLI, the code blocks (in black) shows the required command (the text after # gives more information on the following commands). Type each command after the prompt $, although it's often represented by a %, >, or another symbol as well. Ensure you use the exact case and spacing shown, then hit return/enter at the end of every line.

### Installation for Linux and macOS

In the cases below, `# Homebrew` indicates the command if you're using [Homebrew](https://brew.sh/) as the installer, and `# MacPorts` is if you're using [MacPorts](https://www.macports.org/) to install.

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

**Install Compiler**
It's essential to install the OCaml compiler because OCaml is a compiling language, so please don't skip this step. The first part sets up Opam, and the second part installs the OCaml base compiler:

```
# environment setup
$ opam init
$ eval `opam env`

# install a specific version of the OCaml base compiler
$ opam switch create 4.11.1
$ eval `opam env`

# install dev tools, hit Enter to confirm at Y/n prompt
$ opam install dune utop ocaml-lsp-server
```

After the `opam init` command, your might get a result asking if you'd like to update your `zsh` configuration. If you get that message, type in `N`, the default, then type `y` to install the hook, which will run `eval $(opam env)`. As you get more well-versed in OCaml, you can change these settings by rerunning `opam init`.

**Please note**: The back ticks shown around `opam env` after `eval` are essential. They change the order of application, which is very important. The back ticks tells the system to first evaluate `opam env` (which returns a string of commands) and then `eval` executes those commands in the string. Executing them doesn't return anything, but it initializes the Opam environment behind the scenes.

Check the installation was successful by running `opam --version`. Please note, merely using `opam init` might install a previous version of Opam. The most current version can be found at [opam.ocaml.org](https://opam.ocaml.org/packages/ocaml-base-compiler/).

The OCaml base compiler installation uses the `opam switch create` command; `switch` is used to have several installations on disk, like packages, compiler version, etc. Specify which version at the end as shown above, i.e., 4.11.1.

Next, check that OCaml is installed properly with the following commands. The line beneath the $ command shows the desired output for both the OCaml version and the toplevel version (installed specifically with the above `switch` command):

```
$ which ocaml
/Users/frank/.opam/4.11.1/bin/ocaml

$ ocaml -version
The OCaml toplevel, version 4.11.1
```

As an alternative **for either Linux or macOS**, a binary distribution of Opam is
available:

```
sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
```

### For Windows

OCaml on Windows is still a work in progress. In the meantime, if you only
need to _run_ OCaml programs on a Windows machine, then the simplest solution is to use the Windows Subsystem for Linux 2 (WSL2). WSL2 is a feature that allows Linux programs to run directly on Windows. WSL2 is substantially easier and faster to use than WSL1. Microsoft has comprehensive installation steps for [setting up WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

On the other hand, if you need Windows binaries, you will have to use the [OCaml for Windows](https://fdopen.github.io/opam-repository-mingw/) installer which comes in 32bit and 64bit versions. This installer gives you Opam and OCaml installations all in one go. It's used from within a Cygwin environment, but the executables produced have no dependency on Cygwin at all. For a more comprehensive update on the state of OCaml on Windows, see the [OCaml on Windows](/platform/ocaml_on_windows.html) page on the old version of the site.

## The OCaml Toplevel

_Toplevel_ is a read-eval-print loop (REPL).It's one of the things that makes OCaml so efficient because it compiles while you code, allowing for iteration.

OCaml comes with two additional compilers: one compiles to **native code** (sometimes called machine code or executable binary), directly read by the CPU, and the other compiles to **bytecode**, creating an executable that can be interpreted by a variety of runtime environments, making more flexible.

For now, let's first use OCaml's toplevel. Please note, although the `ocaml` command (below) returns the installed OCaml version, this isn't used to check the version (which is `OCaml -version`, as previously shown). The `ocaml` command instead opens OCaml toplevel, signified by the `#` prompt. Now you can see your code's output as you go.

Exit the toplevel at anytime with `exit 0;;` at the `#` prompt, if you get confused or want to start again.

```
$ ocaml
        OCaml version 4.11.1

# 1 + 2 * 3;;
- : int = 7

```

We typed the phrase `1 + 2 * 3` and then signalled to OCaml that we had
finished by typing `;;` followed by the Enter key. All toplevel phrases end with `;;`.

OCaml calculated the result, `7` and its type `int` (integer) and showed them to us. Exit by running the
built-in `exit` function with exit code `0`, followed by `;;`, as always.

```
$ ocaml
        OCaml version 4.11.1

# 1 + 2 * 3;;
- : int = 7
# exit 0;;
$
```

There are two ways to improve your experience with the OCaml top level: you can
install the popular [`rlwrap`](https://github.com/hanslub42/rlwrap) on your
system and invoke `rlwrap ocaml` instead of `ocaml` to get line-editing
facilities inside the OCaml top level, or you can install the alternative top
level `utop` using opam:

```
$ opam install utop
```

We run it by typing `utop` instead of `ocaml`. You can read more about
[utop](https://github.com/ocaml-community/utop).

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


Type #utop_help for help about using `utop`.

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
REPL does not have history or tab-completion, so we recommend always using `utop`.

## Installing the Dune Build System

Dune is a build system for OCaml. It takes care of all the low level details of
OCaml compilation. We install it with opam:

```
$ opam install dune
The following actions will be performed:
  - install dune 2.7.1

<><> Gathering sources ><><><><><><><><><><><><><><><><><><><><><><><><>
[default] https://opam.ocaml.org/2.0.7/archives/dune.2.7.1+opam.tar.gz
downloaded

<><> Processing actions <><><><><><><><><><><><><><><><><><><><><><><><>
-> installed dune.2.7.1
Done.
```

## A First Project

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
executable. To run the program, we can use:

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

## Editor Support for OCaml

For **Visual Studio Code**, and other editors support the Language Server
Protocol, the OCaml language server can be installed with opam:

```
$ opam install ocaml-lsp-server
```

Now, we install the OCaml Platform Visual Studio Code extension from the Visual
Studio Marketplace.

Upon first loading an OCaml source file, you may be prompted to select the
toolchain in use: pick OCaml the version of OCaml you are using, e.g. 4.11.1
from the list. Now, help is available by hovering over symbols in your program:

![Visual Studio Code](/media/tutorials/vscode.png)

**On Windows using WSL2** you will remotely connect to your WSL2 instance from
Visual Studio Code. Microsoft have a [useful blog post](https://code.visualstudio.com/blogs/2019/09/03/wsl2)
covering getting WSL2 and Visual Studio Code connected.

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
