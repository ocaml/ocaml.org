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

This page will walk you through the installation of everything you need for a comfortable development environment to write projects in OCaml code. Of course this includes [installing the compiler](#installing-ocaml) itself, but it also installs a build system, a package manager, an LSP server to support your editor, and a few other tools that we describe [later](#setting-up-development-tools), setting up [editor support](#configuring-your-editor), and bootstrapping a [new project](#starting-a-new-project).

If you are willing to set up OCaml on Windows, you might be interested in
reading [OCaml on Windows](/docs/ocaml-on-windows) first.
The following instructions work on Linux, BSD, and macOS. Plus, they also work on Cygwin and
WSL.

**Guidelines for following instructions on this page**

A **shell** is a program you can run that will let you enter commands in a text windows using only your keyboard. When this page asks you to enter commands in your shell:
* On macOS you will run the `Terminal` app to start a shell
* On Windows, you can start PowerShell by pressing the Windows key (`⊞`), typing "PowerShell" and then clicking Open `Windows PowerShell`. There is an older shell called "Command Prompt" you can use as well
* On Linux you are already familiar with a shell (typically bash or zsh)

The code blocks (in black) on this page show the required commands (the text after `#` gives more information on the following commands). Type each command after the prompt `$`, although it's often represented by a `%`, `>`, or another symbol as well. Ensure you use the exact case and spacing shown, then hit return/enter at the end of every line. For more information on using the CLI, please visit the [Command Line Crash Course video](https://www.youtube.com/watch?v=yz7nYlnXLfE) to learn some basics.

## Installing OCaml

OCaml is available as a package in most Linux distributions; however, it is
often outdated. On the contrary, OCaml's official package manager, opam, allows you to
easily switch between OCaml versions and much more. This is
especially useful since different projects might require different versions of
OCaml.

The best way to install OCaml is with opam, OCaml's package manager.

### Installing opam

[opam](https://opam.ocaml.org/), the package manager of OCaml, introduces the concept of "switches," consisting of a compiler together with a set of packages (libraries and other files). Switches are used to have independent sets of dependencies in different projects.

After having installed opam, you will need to initialise it, [see below](#initialising-opam).

To install opam, you can [use your system package manager](https://opam.ocaml.org/doc/Install.html#Using-your-distribution-39-s-package-system) or download the [binary distribution](https://opam.ocaml.org/doc/Install.html#Binary-distribution). The details are available in the above links, but for convenience, we copy a few of them here: 

**For macOS**

If you're installing with [Homebrew](https://brew.sh/): 

```shell
# With Homebrew:
$ brew install opam
```

Or if you're using [MacPorts](https://www.macports.org/):

```shell
# With MacPort:
$ port install opam
```

**For Linux**

It's easy to install opam with your system's package manager on
Linux (e.g., `apt-get install opam` or similar). [Details of all installation
methods.](https://opam.ocaml.org/doc/Install.html)


```shell
# Ubuntu
$ add-apt-repository ppa:avsm/ppa
$ apt update
$ apt install opam

# Archlinux
$ pacman -S opam

# Debian (stable, testing and unstable)
$ apt-get install opam
```

**Binary Distribution**

Depending on your package manager, you won't get the latest release of opam. If you want the latest release, consider installing it though the binary distribution, as shown below:

```shell
$ bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
```

### Initialising opam

It's essential to initialise opam, which will (if needed) install the OCaml compiler. If you already have OCaml installed, opam will use that compiler.  

If you have installed the binary distribution of opam through the install script, this step should already be done. If you have installed it through your system package manager, you must initialise opam by running the following command. This method will fetch and initialise the latest version of opam, directly from the official servers:

```shell
$ opam init          # Can take some time
$ eval $(opam env)
```

The first command (`opam init`) initialises the opam state (stored in a hidden folder `.opam` in your home directory). It also creates a first switch, usually called `default`, although this is just a convention. A switch is an independent OCaml environment with its own OCaml compiler, as well as a set of libraries and binares. If you have installed OCaml through your system package manager, the first switch will be set up to use this compiler (it is called a "system switch"). Otherwise, it will build one from source, usually taking the most recent version of OCaml.

The second command (`eval $(opam env)`) modifies a few environments variables to make the shell aware of the switch you are using. For instance, it will add what is needed to the `PATH` variable so that typing `ocaml` in the shell runs the OCaml binary of the current switch.

**Please note:** At the end of the `opam init`, you are asked if you want to add a hook to your shell to best integrate with your system. Indeed, in order for the shell to be aware of the tools available in the current opam switch, a few environments variables need to be modified. For instance, the `PATH` variable has to be expanded so that typing `ocaml` in the shell runs the OCaml binary _of the current switch_. Answering `y` will provide a better user experience.

Now check the installation by running `opam --version`. You can compare it with the current version on [opam.ocaml.org](https://opam.ocaml.org/). 


### Creating a New Switch 

If you want a specific version of OCaml, or a new independent environment, you can create a new switch with the `opam switch create` command. Specify which version as shown below (i.e., `opam switch create 4.14.0`). All possible compiler versions can be found with `opam switch list-available`. The most current version can be found at [opam.ocaml.org](https://opam.ocaml.org/packages/ocaml-base-compiler/).

```shell
$ opam switch create 4.14.0
$ eval $(opam env)
```

Check that the installation was succuessful by running `which ocaml` and `ocaml -version`. The line beneath the $ command shows the desired output for both the OCaml version and the toplevel version (installed specifically with the above `switch` command):

```shell
$ which ocaml
/Users/frank/.opam/4.14.0/bin/ocaml

$ ocaml -version
The OCaml toplevel, version 4.14.0
```

We will learn about the OCaml toplevel and other installed tools in the next section.

In case you are not satisfied with the OCaml version of your system switch, you can change the version with `opam switch create <version_here>`. More information can be found on the [official website](https://opam.ocaml.org/).


### The OCaml Base Tools

OCaml is installed in an opam switch, which, among others, bring the following
programs:

- A "toplevel," which can be called with the `ocaml` command. It consists of a read-eval-print loop ([REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)), similar to the `python` or `node` command, and can be handy to quickly try the language. The user interface of OCaml is very basic, but when we install the UTop package in the following section, we'll have an improved and easier-to-use REPL.

- A compiler to **native code**, called `ocamlopt`. It creates executables that can be executed directly on your system.

- A compiler to **bytecode**, called `ocamlc`. It creates executables that can be interpreted by a variety of runtime environments, making it more flexible.

Although this is theoretically all we need to write OCaml code, it is not a complete and comfortable development environment.

## Setting Up Development Tools

We will now install everything we need to get a complete development environment, which includes:

- Dune, a fast and full-featured build system for OCaml
- Merlin (the backend) and `ocaml-lsp-server` (OCaml's Language Server Protocol) to provide editors with many useful features such as "jump to definition"
- `odoc` to generate documentation from OCaml code
- OCamlformat to automatically format OCaml code
- UTop, an improved REPL
- `dune-release` to release code to `opam-repository`, the package base for opam.

All these tools can be installed in your current switch (remember that opam groups installed packages in independent switches) using the following command:

```shell
$ opam install dune merlin ocaml-lsp-server odoc ocamlformat utop dune-release
```

Now that the tools are installed, it remains to understand how to use them. Most of them will be driven either by the editor or by Dune, but UTop is handy to try OCaml or a specific library.

## Using the OCaml Toplevel with UTop

UTop is a nice toplevel for OCaml. Unlike the standard toplevel with the `ocaml` command, UTop features history, tab completion, line edition, and the ability to load a package installed in your switch.

By running the `utop` command, it will print out something similar to what you see below. After the horizontal line, you will see a new prompt `utop #`. Here is where you type your expressions. In this case `1 + 2 * 3;;`. After you press Enter, the following line shown is the desired output. 

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

## Configuring Your Editor

While a toplevel is great for interactively trying out the language, we will shortly need to write OCaml files in an editor. We already installed the tools needed to have editor support: Merlin, providing all features such as "jump to definition" or "show type", and `ocaml-lsp-server`, a server exposing those features to the editor through the [LSP server](https://en.wikipedia.org/wiki/Language_Server_Protocol).

OCaml has plugins for many editors, but the most actively maintained are for Visual Studio Code, Emacs, and Vim.

For **Visual Studio Code**, install the [OCaml Platform Visual Studio Code extension](https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform) from the Visual
Studio Marketplace.

Upon first loading an OCaml source file, you may be prompted to select the
toolchain in use: pick the version of OCaml you are using, e.g., 4.14.0
from the list. Now, help is available by hovering over symbols in your program:

![Visual Studio Code](/media/tutorials/vscode.png)

**For Vim and Emacs** we won't use the LSP server but rather directly talk to Merlin.

When we installed Merlin above, instructions were printed on how to link Merlin with your editor. If you do not have them visible, the short way is just to run:

```shell
$ opam user-setup install
```

## Starting a New Project

Let's begin the simplest project with Dune and OCaml, "Hello World," just to see how it works. 
Navigate into a practice directory, as we'll be creating new projects below. 

First, we ask `dune` to
initialise a new project, and then change into the created directory. As usual, 
the line beneath the command is the desired output:

```shell
$ dune init project helloworld
Success: initialized project component named helloworld
$ cd helloworld
```

All the metadata of your project is available in the file `dune-project`. Edit it to match your specific project.

We can build our program with `dune build`, which creates an executable file:

```shell
$ dune build
```

When we change our program, we can type `dune build` again to make a new
executable. To run the program, we can use:

```shell
$ dune exec bin/main.exe
Hello, World!
```

Or, alternatively,

```shell
$ dune exec helloworld
Hello, World!
```

Let's look at the contents of our new directory:

```shell
$ ls
bin  _build  dune-project  helloworld.opam  lib  test
```

All the build outputs generated by Dune go in the `_build` directory. The
`main.exe` executable is generated inside the `_build/default/bin/`
subdirectory.

The source code for the program is found in `./bin/main.ml`, and any supporting
library code should go in `lib`.

To learn more about Dune, see the [official
documentation](https://dune.readthedocs.io/en/stable/).

### OCamlformat for Automatic Formatting

Automatic formatting with OCamlformat is usually already supported by the
editor plugin, but it requires a configuration file at the root of the project.
Moreover, since different versions of OCamlformat will vary in formatting, it
is good practice to enforce the one you are using. Doing:

```shell
$ echo "version = 0.22.4" > .ocamlformat
```

This will enforce that only OCamlformat version 0.22.4 can format the files of the project.
Note that a `.ocamlformat` file is _needed_, but an empty file is accepted.

In addition to the editor, Dune is also able to drive OCamlformat. Running
this command will automatically format all files from your codebase:

```shell
$ dune fmt
```

### `odoc` for Documentation Generation

`odoc` is a tool that is not meant to be used by hand, just as compilers are
not meant to be run manually in complex projects. Dune can drive `odoc` to
generate, from the docstrings and interface of the modules of the project, a
hierarchised documentation.

The following command will generate the documentation as HTML:

```shell
$ dune build @doc
$ open _build/default/_doc/_html/index.html
```
