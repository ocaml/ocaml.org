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

This page will walk you through the installation of everything you need for a comfortable development environment to write projects in OCaml code. Of course, this includes [installing the compiler](#installing-ocaml) itself, but it also installs a build system, a package manager, an LSP server to support your editor, and a few other tools that we describe [later](#setting-up-development-tools), setting up [editor support](#configuring-your-editor), and bootstrapping a [new project](#starting-a-new-project).

The following instructions work on Linux, BSD, and macOS. Plus, they also work
on Cygwin and WSL. If you want to set up OCaml on Windows, you might be
interested in reading [OCaml on Windows](/docs/ocaml-on-windows) first.

**Guidelines for Following Instructions on this Page**

A **shell** is a program that will let you enter commands in a text window using only your keyboard. It's also known as a command line interface (CLI). When this page asks you to enter commands in your shell, use the following instructions for your system:
* On macOS you will run the `Terminal` app to start a shell
* On Windows, you can start PowerShell by pressing the Windows key (`⊞`), typing "PowerShell," and then clicking Open `Windows PowerShell`. There is an older shell called "Command Prompt" you can use as well
* On Linux, you are already familiar with a shell (typically bash or zsh)

The code blocks (in black) on this page show the required commands (the text after `#` gives more information on the following commands). Type each command after the prompt `$`, although it's often represented by a `%`, `>`, or another symbol as well. Ensure you use the exact case and spacing shown, then hit return/enter at the end of every line. For more information on using the CLI, please visit the [Command Line Crash Course video](https://www.youtube.com/watch?v=yz7nYlnXLfE) to learn some basics.

## Installing OCaml

OCaml is available as a package in most Linux distributions; however, it is
often outdated. On the contrary, OCaml's official package manager, opam, allows you to
easily switch between OCaml versions and much more. This is
especially useful since different projects might require different versions of
OCaml.

On Unix, the best way to install OCaml is with opam, OCaml's package manager. On Windows, the best way is to use a traditional `setup.exe` that will initialise opam
on your behalf; however, only OCaml version 4.14.0 can be installed with `setup.exe` now.

[opam](https://opam.ocaml.org/), OCaml's package manager, introduces the concept of "switches," which is a compiler with a set of packages (libraries and other files). Switches are used to have independent sets of dependencies in different projects.

Find all the installation instructions for both Unix-like systems and Windows in the sections below:

* Linux or macOS: [Installation for Unix, including Linux and macOS](#installation-for-unix)
* Windows: [Installation for Windows](#installation-for-windows)

**Note**

As an alternative to the methods mentionned aboved, the [OCaml Platform
Installer](https://github.com/tarides/ocaml-platform-installer) is a new way to
install OCaml and the development tools. [See
below](#up-and-running-with-the-platform-installer) for the instructions.
However, please note that it is still experimental and in active development
(any feedback is highly appreciated).

### Installation for Unix

After having installed opam, you will need to initialise it, [see below](#initialising-opam-on-unix).

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
Linux (e.g., `apt-get install opam` or similar). On the opam site, find [details of all installation
methods](https://opam.ocaml.org/doc/Install.html). All supported Linux distributions package at least version 2.0.0 (you can check by running `opam --version`). If you are using an unsupported Linux distribution, please either download a precompiled binary or build opam from sources.

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

Depending on your package manager, you won't get the latest release of opam. If you want the latest release, consider installing it through the binary distribution, as shown below:

```shell
$ bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
```

#### Initialising opam on Unix

On Unix, it's essential to initialise opam, which will (if needed) install the OCaml compiler. If you already have OCaml installed, opam will use that compiler.  

This step is done automatically by the Platform Installer, [see below](#up-and-running-with-the-platform-installer).

If you have installed the binary distribution of opam through the install script, this step should already be done. If you have installed it through your system package manager, you must initialise opam by running the following command. This method will fetch and initialise the latest version of opam, directly from the official servers:

```shell
$ opam init          # Can take some time
$ eval $(opam env)
```

The first command (`opam init`) initialises the opam state (stored in a hidden folder `.opam` in your home directory). It also creates a first switch, usually called `default`, although this is just a convention. A switch is an independent OCaml environment with its own OCaml compiler, as well as a set of libraries and binaries. If you have installed OCaml through your system package manager, the first switch will be set up to use this compiler (it is called a "system switch"). Otherwise, it will build one from source, usually taking the most recent version of OCaml.

The second command (`eval $(opam env)`) modifies a few environment variables to make the shell aware of the switch you are using. For instance, it will add what is needed to the `PATH` variable so that typing `ocaml` in the shell runs the OCaml binary of the current switch.

**Please note:** At the end of the `opam init`, you are asked if you want to add a hook to your shell to best integrate with your system. Indeed, in order for the shell to be aware of the tools available in the current opam switch, a few environment variables need to be modified. For instance, the `PATH` variable has to be expanded so that typing `ocaml` in the shell runs the OCaml binary _of the current switch_. Answering `y` will provide a better user experience.

Now check the installation by running `opam --version`. You can compare it with the current version on [opam.ocaml.org](https://opam.ocaml.org/). 

#### Creating a New Switch on Unix

If you want a specific version of OCaml, or a new independent environment, you can create a new switch with the `opam switch create` command. Specify which version as shown below (i.e., `opam switch create 4.14.0`). All possible compiler versions can be found with `opam switch list-available`. The most current version can be found at [opam.ocaml.org](https://opam.ocaml.org/packages/ocaml-base-compiler/).

```shell
$ opam switch create 4.14.0
$ eval $(opam env)
```

Check that the installation was successful by running `which ocaml` and `ocaml -version`. The line beneath the $ command shows the desired output for both the OCaml version and the toplevel version (installed specifically with the above `switch` command):

```shell
$ which ocaml
/Users/frank/.opam/4.14.0/bin/ocaml

$ ocaml -version
The OCaml toplevel, version 4.14.0
```

We will learn about the OCaml toplevel and other installed tools in the next section.

In case you are not satisfied with the OCaml version of your system switch, you can change the version with `opam switch create <version_here>`. More information can be found on the [official website](https://opam.ocaml.org/).

### Installation for Windows

In this section, we'll describe using the new [Diskuv OCaml](https://github.com/diskuv/dkml-installer-ocaml#readme) ("DKML") Windows installer. Expect to see another officially-supported Windows installation provided directly by opam in the coming months; it will be compatible with your DKML installation.

> Advanced Users: If you are familiar with Cygwin or WSL2, there are other installation methods described on the [OCaml on Windows](/docs/ocaml-on-windows) page.

Before using the DKML installer, briefly review the following:

* You need to **stay at your computer** and press "Yes" for any Windows security popups. 
After the DKML installer finishes installing two programs (`Visual Studio Installer`
  and `Git for Windows`), you can leave your computer for the remaining two (2) hours.

* First time installations may get a notification printed in red. If you see it, reboot your computer and then restart your installation so that Visual Studio Installer can complete. The notification looks like:

  ```diff
  - FATAL [118acf2a]. The machine needs rebooting.
  - ...
  - >>  The machine needs rebooting. <<<
  -         ...
  -         FATAL [5f927a8b].
  -         A transient failure occurred.
  -         ...
  -         >>  A transient failure occurred. <<<
  ```

* You may be asked to accept a certificate from
  `Open Source Developer, Gerardo Grignoli` for the `gsudo` executable
  that was issued by
  `Certum Code Signing CA SHA2`.

Now, download and run:

* OCaml 4.14.0 with Git and Visual Studio compiler: [setup-diskuv-ocaml-windows_x86_64-1.1.0.exe](https://github.com/diskuv/dkml-installer-ocaml/releases/download/v1.1.0_r2/setup-diskuv-ocaml-windows_x86_64-1.1.0.exe)

#### Creating a New Switch on Windows

If you want a new independent environment, you can create a new switch with the `dkml init` command. The only compiler version available is 4.14.0.
Use PowerShell or a Command Prompt to create a directory anywhere and then create a switch:

```powershell
C:\Users\frank> mkdir someproject
C:\Users\frank> cd someproject
C:\Users\frank\someproject> dkml init

# PowerShell only
C:\Users\frank\someproject> (& opam env) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ }

# Command Prompt only
C:\Users\frank\someproject> for /f "tokens=*" %i in ('opam env') do @%i
```

Check that OCaml is installed properly with the following commands in your shell (PowerShell or Command Prompt).
The line beneath the $ command shows the desired output for both the OCaml version and the toplevel version:

```shell
$ where.exe ocaml
C:\Users\frank\AppData\Local\Programs\DiskuvOCaml\usr\bin\ocaml.exe

$ ocaml -version
The OCaml toplevel, version 4.14.0
```

To learn more about Diskuv OCaml, see the [official
Diskuv OCaml documentation](https://diskuv-ocaml.gitlab.io/distributions/dkml/#introduction).

### The OCaml Base Tools

OCaml is installed in an opam switch, which, among others, provides the
following programs:

- A "toplevel," which can be called with the `ocaml` command. It consists of a read-eval-print loop ([REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)), similar to the `python` or `node` command, and can be handy to quickly try the language. The user interface of the OCaml toplevel is quite basic, but when we install the UTop package in the following section, we'll have an improved and easier-to-use REPL.

- A compiler to **native code**, called `ocamlopt`. It creates executables that can be executed directly on your system.

- A compiler to **bytecode**, called `ocamlc`. It creates executables that can be interpreted by a variety of runtime environments, making these executables portable between different operating systems (at the cost of runtime performance).

What we installed so far (theoretically) suffices to write, compile, and execute OCaml code. However, this basic installation is neither complete nor comfortable as a development environment.

## Setting Up Development Tools

This step is done automatically by the Platform Installer, [see below](#up-and-running-with-the-platform-installer).

We will now install everything we need to get a complete development environment, which includes:

- Dune, a fast and full-featured build system for OCaml
- Merlin and `ocaml-lsp-server` (OCaml's Language Server Protocol), which together enhance editors
(like Visual Studio Code, Vim, or Emacs) by providing many useful features such as "jump to definition"
- `odoc` to generate documentation from OCaml code
- OCamlFormat to automatically format OCaml code
- UTop, an improved REPL
- `dune-release` to release code to `opam-repository`, the central package directory of opam.

All these tools can be installed in your current switch (remember that opam groups installed packages in independent switches) using the following command:

```shell
# Unix
$ opam install dune merlin ocaml-lsp-server odoc ocamlformat utop dune-release

# Windows (Diskuv OCaml has known bugs that make this harder than it needs to be)
$ opam pin remove fiber omd stdune dyn ordering dot-merlin-reader yojson --no-action
$ opam install dune merlin ocaml-lsp-server odoc ocamlformat utop
```

Now that the tools are installed, it remains to understand how to use them. Most of them will be driven either by the editor or by Dune, but UTop is handy to try OCaml or a specific library.

## Up and Running With the Platform Installer

As of 2023, the [OCaml Platform
Installer](https://github.com/tarides/ocaml-platform-installer), presented
here, is still experimental and in active development. It is an alternative way
to install all the tools of the OCaml platform.

If your run into any trouble using it, please don't hesitate to [file an
issue](https://github.com/tarides/ocaml-platform-installer/issues).
If it doesn't work at all on your system, follow the instructions above.

The `ocaml-platform` binary automates the set up of a complete OCaml development
environment. However, you need first to install the few system dependencies of
the OCaml environment, such as a C compiler (e.g. `gcc`) and other system tools:
`bzip2`, `make`, `bubblewrap`, `patch`, `curl` and `unzip`. In most
architecture, you can install them using your package manager, for example on
Ubuntu or Debian:
<!-- $MDX skip -->
```bash
$ sudo apt install build-essential bubblewrap unzip
```

In macOS, having installed [Xcode](https://developer.apple.com/xcode) is the only requirement.

You can now download and run the installer script (which will call `sudo` at
some point) and then call `ocaml-platform`:
```shell
$ bash < <(curl -sL https://ocaml.org/install-platform.sh)
$ ocaml-platform
```

This will initialise `opam` and install the development tools, which might take
some time. Hopefully, in the future, the `ocaml-platform` will be distributed as
a system package and it will no longer be required to download `installer.sh`
manually.

The tools are not installed exactly the same way as with `opam install`. They
are built in a sandbox so that each tool's dependencies are not installed in the
same space as your project's dependencies, see [Under the
Hood](https://github.com/tarides/ocaml-platform-installer#whats-under-the-hood=)
for more information.

`ocaml-platform` can be run again at any time to install the tools in another
opam switch for example.

## Using the OCaml Toplevel With UTop

UTop is an extended and improved toplevel (REPL) for OCaml. Unlike the standard toplevel with the `ocaml` command, UTop features history, tab completion, interactive line editing, and the ability to load any package installed in your switch.

If you have never used a toplevel (REPL) before, think of it as an interactive terminal/shell that evaluates expressions. Type an OCaml expression, then press the Enter or Return key. The toplevel responds with the value of the evaluated expression. 

OCaml comes with two additional compilers: one compiles to **native code** (sometimes called machine code or executable binary), directly read by the CPU, and the other compiles to **bytecode**, creating an executable that can be interpreted by a variety of runtime environments, making more it flexible.

For now, let's first use the recommended toplevel, UTop, which we installed above:

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

In this example, we typed the expression `1 + 2 * 3` followed by `;;` (which is
mandatory and tells OCaml that the expression ends here) and then pressed the
Enter key. OCaml replied with the resulting value `7` and its type `int`.

You can exit UTop by running the built-in `exit` function with exit code 0:

```
─( 12:12:45 )─< command 1 >──────────────────────────────────────────────────────────────────────────────────────────────{ counter: 0 }─
utop # exit 0;;
$
```

## Configuring Your Editor

While the toplevel is great for interactively trying out the language, we will shortly need to write OCaml files in an editor. We already installed the tools required to enhance our editor of choice with OCaml support: Merlin, providing all features such as "jump to definition" or "show type", and `ocaml-lsp-server`, a server exposing those features to the editor through the [LSP server](https://en.wikipedia.org/wiki/Language_Server_Protocol).

OCaml has plugins for many editors, but the most actively maintained are for Visual Studio Code, Emacs, and Vim.

For **Visual Studio Code**, install the [OCaml Platform Visual Studio Code extension](https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform) from the Visual
Studio Marketplace.

Upon first loading an OCaml source file, you may be prompted to select the
toolchain in use. Pick the version of OCaml you are using, e.g., 4.14.0
from the list. Additional information is available by hovering over symbols in your program:

![Visual Studio Code](/media/tutorials/vscode.png)

**For Windows**
1. If you used the Diskuv OCaml (DKML) installer you will need to:
   1. Go to `File` > `Preferences` > `Settings` view (or press `Ctrl ,`)
   2. Select `User` > `Extensions` > `OCaml Platform`
   3. **Uncheck** `OCaml: Use OCaml Env`. That's it!

**For Vim and Emacs**, we won't use the LSP server but rather directly talk to Merlin.

When we installed Merlin above, instructions were printed on how to link Merlin with your editor. If you do not have them visible, just run this command:

```shell
$ opam user-setup install
```

## Starting a New Project

We will set up a "Hello World" project using the build system Dune. Navigate
into a practice directory, as we'll be creating new projects below. 

First, we initialise a new project using `dune` and then change into the
created directory. As usual, the line beneath the shell command is the expected
output:

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

```
$ dune exec ./bin/main.exe
Hello, World!
```

Or, alternatively,

```
$ dune exec helloworld
Hello, World!
```

Let's look at the contents of our new directory.

* On macOS and Linux, use the directory listing command (`ls`):

  ```shell
  $ ls
  bin  _build  dune-project  helloworld.opam  lib  test
  ```
* On Windows, use the directory listing command (`dir`):

  ```shell
  $ dir
      Directory: C:\source\helloworld


  Mode                 LastWriteTime         Length Name
  ----                 -------------         ------ ----
  d-----          8/8/2022  12:18 PM                bin
  d-----          8/8/2022  12:18 PM                lib
  d-----          8/8/2022  12:18 PM                test
  d-----          8/8/2022  12:18 PM                _build
  -a----          8/8/2022  12:18 PM             36 dune-project
  -a----          8/8/2022  12:18 PM              0 helloworld.opam
  ```

All the build outputs generated by Dune go in the `_build` directory. The
`main.exe` executable is generated inside the `_build/default/bin/`
subdirectory.

The source code for the program is found in `./bin/main.ml`. Any supporting
library code should go in `lib`.

To learn more about Dune, see the [official
documentation](https://dune.readthedocs.io/en/stable/).

### OCamlFormat for Automatic Formatting

Automatic formatting with OCamlFormat is usually already supported by the
editor plugin, but it requires a configuration file at the root of the project.
Moreover, since different versions of OCamlFormat will vary in formatting, it
is good practice to enforce the one you are using. Doing:

```shell
$ echo "version = `ocamlformat --version`" > .ocamlformat
```

This will enforce that only the OCamlFormat version you have installed can format the files of the project.
Note that a `.ocamlformat` file is _needed_, but an empty file is accepted.

In addition to the editor, Dune is also able to drive OCamlFormat. Running
this command will automatically format all files from your codebase:

```shell
$ dune fmt
```

### `odoc` for Documentation Generation

`odoc` is a tool that is not meant to be used by hand, just as compilers are
not meant to be run manually in complex projects. Dune can drive `odoc` to
generate documentation in the form of HTML, LaTeX, or man pages, from the docstrings and interface of the project's modules.

The following command will generate the documentation as HTML:

```shell
$ dune build @doc

# Unix or macOS
$ open _build/default/_doc/_html/index.html

# Windows
$ explorer _build/default/_doc/_html/index.html
```
