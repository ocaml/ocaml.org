---
id: up-and-running
title: Get Up and Running With OCaml
description: |
  This page will help you install OCaml, the Dune build system, and support for
  your favourite text editor or IDE. These instructions work on Windows, Unix
  systems like Linux, and macOS.
category: "getting-started"
date: 2021-05-27T21:07:30-00:00
---

# Get Up and Running With OCaml

This page will walk you through the installation of everything you need to have a comfortable development environment to write OCaml code on a new project. This includes of course [installing the compiler](#installing-ocaml) itself, but also a build system, a package manager, an LSP server to support your editor, and a few other tools that we describe [later](#setting-up-development-tools), setting up [editor support](#configuring-your-editor) and bootstrapping a [new project](#starting-a-new-project).

These instructions work on Unix-based systems like Linux and macOS. If you are willing to set up OCaml on Windows, you might be interested in reading [OCaml on Windows](/docs/ocaml-on-windows) first. You can continue reading this after, once you have Cygwin or WSL installed.

<!-- If you're new to the command line interface, the code blocks (in black) show the required commands to type in a terminal (the text after # gives more information on the following commands). Each command is displayed after the prompt $, which is also often represented by a %, >, or another symbol as well. Ensure you use the exact case and spacing shown, then hit return/enter at the end of every line. -->

## Installing OCaml

OCaml is available as a package in most linux distributions, and can be installed as such. For instance, on Ubuntu:

``` shell
apt install ocaml
```

will work. However, the ocaml versions of most distribution packages are a little bit outdated. On the contrary, OCaml's package manager `opam` allows you to download any version of `ocaml`, and to easily switch from one to the other. This is especially useful since different projects might require different versions of OCaml.

So the best way to install `ocaml` is in fact by using `opam`, OCaml's package manager.

### Installing `opam`

[Opam](https://opam.ocaml.org/) is the package manager of OCaml. It introduces the concept of "switches", consisting of a compiler together with a set of packages (libraries and other files). Those switches are mainly used to have an independent set of dependencies in different projects.

When you install `opam`, you will need to [initialise](#initialize-opam) it. The biggest part of this initialisation consists of creating a first switch, with an empty set of installed packages. As the compiler of this first switch, `opam` will choose the compiler installed in your distribution if you have one. Otherwise, it will build one up from source.

To install `opam`, you can [use your system package manager](https://opam.ocaml.org/doc/Install.html#Using-your-distribution-39-s-package-system), or download the [binary distribution](https://opam.ocaml.org/doc/Install.html#Binary-distribution). The details are available in the above links, but for convenience, we copy a few of them here:

**For macOS**

``` shell
# With Homebrew:
brew install opam

# With MacPort:
port install opam
```

**For Linux**

``` shell
# Ubuntu
add-apt-repository ppa:avsm/ppa
apt update
apt install opam

# Archlinux
pacman -S opam

# Debian (stable, testing and unstable)
apt-get install opam
```

**Binary distribution**

``` shell
bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
```

### Initialising `opam`

If you have installed the binary distribution of `opam` through the install script, this step should already be done. If you have installed it through your system package manager, you must initialise `opam` by running the following command:

```
$ opam init          # Can take up to several minutes
$ eval $(opam env)
```

The first command (`opam init`) creates a first switch, usually called `default`, although this is just a convention. If you have installed `ocaml` through your system package manager, the first switch will be set up to use this compiler (it is called a "system switch"). Otherwise, it will build one from source, usually taking the most recent version of `ocaml`.

The second command (`eval $(opam env)`) modifies a few environments variables to make the shell script aware of the switch you are using. For instance, it will add what is needed to the `PATH` variable so that typing `ocaml` in the shell runs the ocaml binary of the current switch.

In case you are not satisfied with the `ocaml` version of your system switch, you can write the following commands to create a new switch with a recent version of ocaml:

``` shell
$ opam switch create 4.14.0
$ eval $(opam env)
```

More information can be found in the [official website](https://opam.ocaml.org/).

### The OCaml base tools

We have installed `ocaml`, in an opam switch, which means we have access to the following programs:

- A "toplevel", which can be called with the `ocaml` command. It consists of a read-eval-print loop (a [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)), similar to the `python` or `node` command, and can be handy to quickly try the language. The user interface of `ocaml` is very basic but is improved a lot in one of the package that we will install later: `utop`.

- A compiler, called `ocamlopt`, to **native code** (sometimes called machine code or executable binary), directly read by the CPU.

- Another compiler, called `ocamlc`, this time to **bytecode**. It creates an executable that can be interpreted by a variety of runtime environments, making it more flexible.

Although it is theoretically all we need to write OCaml code, it is not at all a complete and comfortable development environment.

## Setting up development tools

We will now install everything we need to get a complete development environment, which includes:

- `dune`, a build system, to automatically link external and internal libraries,
- `merlin` (the backend) and `ocaml-lsp-server` to provide your editor with many useful features, such as "jump to definition",
- `odoc` to generate documentation from your OCaml values and docstrings comments
- `ocamlformat` to automatically format your code,
- `utop`, an improved REPL,
- `dune-release` to release your code to `opam-repository`, the default repository for the package manager `opam`.

All these tools can be installed in your current switch (remember that `opam` groups installed packages in independant switches) using the following command:

``` shell
opam install dune merlin ocaml-lsp-server odoc ocamlformat utop dune-release
```

Now that the tools are installed, it remains to understand how to use them. Most of them will be driven either by the editor or by `dune`, but `utop` is handy to try OCaml or a specific library.

### Using the OCaml toplevel with `utop`

`utop` is a nice toplevel for OCaml. It features history, line edition, and the ability to load a package that you have installed in your switch.

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

### Configuring your editor

While a toplevel is great for interactively trying out the language, we will shortly need to write ocaml files in an editor. We already installed the tools needed to have an editor suppor: `merlin`, providing all features such as "jump to definition" or "show type", and `ocaml-lsp-server`, a server exposing those features to the editor through the [language server protocol](https://en.wikipedia.org/wiki/Language_Server_Protocol).

OCaml has plugins for many editors, but the most actively maintained are for Visual Studio Code, Emacs and Vim.

For **Visual Studio Code**, we install the [OCaml Platform Visual Studio Code extension](https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform) from the Visual
Studio Marketplace.

Upon first loading an OCaml source file, you may be prompted to select the
toolchain in use: pick the version of OCaml you are using, e.g. 4.11.1
from the list. Now, help is available by hovering over symbols in your program:

![Visual Studio Code](/media/tutorials/vscode.png)

**For Vim and Emacs** we won't use the LSP server, but rather directly talk to `merlin` that we installed earlier.

When installing `merlin`, instructions were printed on how to link Merlin with your editor. If you do not have them visible, the short way is just to run:

``` shell
opam user-setup install
```

## Starting a new project

We explain here all what is needed to start a project using the tools that we installed. The build system `dune` allows us to initialize a project, with standard structure, containg a `helloworld` example:

```
$ dune init project helloworld
Success: initialized project component named helloworld
$ cd helloworld
```

All the metadata of your project are available in the file `dune-project`. Edit it to match your specific project.

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
$ dune exec helloworld
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

### `ocamlformat` for automatic formatting

Automatic formatting with `ocamlformat` is usually already supported by the editor plugin, but it usually need a configuration file at the root of the project. Moreover, since different versions of `ocamlformat` will vary in formatting, it is good practice to enforce the one you are using. Doing:

``` shell
echo "version = 0.22.4" > .ocamlformat
```

will enforce that only `ocamlformat` version `0.22.4` can format the files of the project.

Note that a `.ocamlformat` file is _needed_, but an empty file is accepted.

In addition to the editor, `dune` is also able to drive `ocamlformat`. Running:

``` shell
dune fmt
```

will automatically format all files from your codebase.

### `odoc` for documentation generation

`odoc` is a tool that is not meant to be used by hand, just as compilers are not meant to be run by hand in complex projects. `dune` can drive `odoc` to generate, from the docstrings and interface of the files of the project, a hierarchised documentation. To build this documentation, run:

``` shell
dune build @doc
```

This will generate a set of `html` files. You can access the root of the documentation by opening the file at `./_build/default/_doc/_html/index.html`:

``` shell
open _build/default/_doc/_html/index.html
```
