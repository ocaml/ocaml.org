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

## Installing OCaml

The **platform installer** is currently in active development. It will
automatically install opam, OCaml, and the development tools. [See below](#up-and-running-with-the-platform-installer)
for the instruction.

Please note that the installer is a work in progress and might not work on your system.

OCaml is available as a package in most Linux distributions; however, it is
often outdated. On the contrary, OCaml's package manager opam allows you to
easily switch between OCaml versions and much more. This is
especially useful since different projects might require different versions of
OCaml.

So the best way to install OCaml is in fact by using opam, OCaml's official package manager.

### Installing opam

Alternatively, you can use the alpha-version platform installer to install opam and the development tools, [see below](#up-and-running-with-the-platform-installer).

[opam](https://opam.ocaml.org/) is the package manager of OCaml. It introduces the concept of "switches," consisting of a compiler together with a set of packages (libraries and other files). Switches are used to have independent sets of dependencies in different projects.

After having installed opam, you will need to initialise it, [see below](#initialize-opam).

To install opam, you can [use your system package manager](https://opam.ocaml.org/doc/Install.html#Using-your-distribution-39-s-package-system), or download the [binary distribution](https://opam.ocaml.org/doc/Install.html#Binary-distribution). The details are available in the above links, but for convenience, we copy a few of them here:

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

This step is done automatically by the alpha-version platform installer, [see below](#up-and-running-with-the-platform-installer).

If you have installed the binary distribution of `opam` through the install script, this step should already be done. If you have installed it through your system package manager, you must initialise `opam` by running the following command:

```
opam init          # Can take some time
eval $(opam env)
```

The first command (`opam init`) creates a first switch, usually called `default`, although this is just a convention. If you have installed OCaml through your system package manager, the first switch will be set up to use this compiler (it is called a "system switch"). Otherwise, it will build one from source, usually taking the most recent version of OCaml.

The second command (`eval $(opam env)`) modifies a few environments variables to make the shell aware of the switch you are using. For instance, it will add what is needed to the `PATH` variable so that typing `ocaml` in the shell runs the OCaml binary of the current switch.

In case you are not satisfied with the OCaml version of your system switch, you can write the following commands to create a new switch with a recent version of OCaml:

``` shell
opam switch create 4.14.0
eval $(opam env)
```

More information can be found on the [official website](https://opam.ocaml.org/).

### The OCaml Base Tools

OCaml is installed in an opam switch, which, among others, bring the following
programs:

- A "toplevel," which can be called with the `ocaml` command. It consists of a read-eval-print loop (a [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)), similar to the `python` or `node` command, and can be handy to quickly try the language. The user interface of OCaml is very basic but is improved a lot in one of the package that we will install later: UTop.

- A compiler to **native code**, called `ocamlopt`. It creates executables that can be executed directly on your system.

- A compiler to **bytecode**, called `ocamlc`. It creates executables that can be interpreted by a variety of runtime environments, making it more flexible.

Although this is theoretically all we need to write OCaml code, it is not at all a complete and comfortable development environment.

## Setting Up Development Tools

This step is done automatically by the alpha-version platform installer, [see below](#up-and-running-with-the-platform-installer).

We will now install everything we need to get a complete development environment, which includes:

- Dune, a fast and full-featured build system for OCaml
- Merlin (the backend) and `ocaml-lsp-server` to provide editors with many useful features such as "jump to definition"
- `odoc` to generate documentation from OCaml code
- OCamlformat to automatically format OCaml code
- UTop, an improved REPL,
- `dune-release` to release code to `opam-repository`, the package base for opam.

All these tools can be installed in your current switch (remember that opam groups installed packages in independent switches) using the following command:

``` shell
opam install dune merlin ocaml-lsp-server odoc ocamlformat utop dune-release
```

Now that the tools are installed, it remains to understand how to use them. Most of them will be driven either by the editor or by `dune`, but `utop` is handy to try OCaml or a specific library.

## Up and Running with the Platform Installer

The platform installer is work in progress. You can follow its development and
report issues on [the repository](https://github.com/tarides/ocaml-platform-installer/).

Please note that the installer might not work on your system. If that's the
case, follow the old instructions above, which are still relevant.

The installer is not in any package manager yet, but it can be installed using
this script, which will install both opam and OCaml Platform`:

```shell
sudo bash < <(curl -sL https://github.com/tarides/ocaml-platform-installer/releases/latest/download/installer.sh)
```

This downloads a script from the web and executes it as root. You are
encouraged to have a look at what it does first.

Once this step is done, setup the environment with:

```shell
ocaml-platform
```

This will initialise opam and install the development tools, which might take
some time.

The tools are not installed exactly the same way as with `opam install`. They
are built in a sandbox so that each tool's dependencies are not installed in
the same space as your project's dependencies, see [Under the Hood](https://github.com/tarides/ocaml-platform-installer#whats-under-the-hood=)
for more information.

`ocaml-platform` can be run again at any time to install the tools in another
opam switch for example.

## Using the OCaml Toplevel with UTop

UTop is a nice toplevel for OCaml. It features history, line edition, and the ability to load a package installed in your switch.

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

While a toplevel is great for interactively trying out the language, we will shortly need to write OCaml files in an editor. We already installed the tools needed to have editor support: Merlin, providing all features such as "jump to definition" or "show type", and `ocaml-lsp-server`, a server exposing those features to the editor through the [language server protocol](https://en.wikipedia.org/wiki/Language_Server_Protocol).

OCaml has plugins for many editors, but the most actively maintained are for Visual Studio Code, Emacs, and Vim.

For **Visual Studio Code**, we install the [OCaml Platform Visual Studio Code extension](https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform) from the Visual
Studio Marketplace.

Upon first loading an OCaml source file, you may be prompted to select the
toolchain in use: pick the version of OCaml you are using, e.g., 4.11.1
from the list. Now, help is available by hovering over symbols in your program:

![Visual Studio Code](/media/tutorials/vscode.png)

**For Vim and Emacs** we won't use the LSP server, but rather directly talk to Merlin, which we installed earlier.

When installing Merlin, instructions were printed on how to link Merlin with your editor. If you do not have them visible, the short way is just to run:

```shell
opam user-setup install
```

## Starting a New Project

We explain here all that's needed to start a project using the tools that we installed. The build system, Dune, allows us to initialise a project, containing a `helloworld` example:

```shell
dune init project helloworld
cd helloworld
```

All the metadata of your project is available in the file `dune-project`. Edit it to match your specific project.

We can build our program with `dune build`:

```shell
dune build
```

When we change our program, we can type `dune build` again to make a new
executable. To run the program, we can use:

```shell
dune exec ./bin/main.exe
```

Which will print:

```
Hello, World!
```

Or, alternatively,

```shell
dune exec helloworld
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
echo "version = 0.22.4" > .ocamlformat
```

will enforce that only OCamlformat version 0.22.4 can format the files of the project.
Note that a `.ocamlformat` file is _needed_, but an empty file is accepted.

In addition to the editor, Dune is also able to drive OCamlformat. Running
this command will automatically format all files from your codebase:

```shell
dune fmt
```

### `odoc` for Documentation Generation

`odoc` is a tool that is not meant to be used by hand, just as compilers are
not meant to be run by hand in complex projects. Dune can drive `odoc` to
generate, from the docstrings and interface of the modules of the project, a
hierarchised documentation.

The following command will generate the documentation as `html`:

```shell
dune build @doc
open _build/default/_doc/_html/index.html
```
