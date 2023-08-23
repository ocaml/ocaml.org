---
id: up-and-running
title: Get Up and Running With OCaml
description: |
  This page will help you install OCaml, the Dune build system, and support for
  your favourite text editor or IDE. These instructions work on Windows, Unix
  systems like Linux, and macOS.
category: "Getting Started"
---

# Get Up and Running With OCaml

This page will walk you through the installation of everything you need for a comfortable development environment to write projects in OCaml code. Of course, this includes [installing the compiler](#installing-ocaml) itself, but it also installs a build system, a package manager, an LSP server to support your editor, and a few other tools that we describe [later](#setting-up-development-tools), setting up [editor support](#configuring-your-editor), and bootstrapping a [new project](#starting-a-new-project).

We provide installation instructions for Linux, macOS, and *BSD for all OCaml versions. For Windows, we provide instructions on this page for installing OCaml 4.14.0 via the [Diskuv OCaml](https://github.com/diskuv/dkml-installer-ocaml#readme) Installer. Note that, if you use Windows Subsystem for Linux (WSL), the Unix instructions can be used on Windows.

Alternatively, for Linux, macOS and *BSD, there is also the [OCaml Platform Installer](#one-step-installation-on-unix-the-platform-installer)
which installs both OCaml and the OCaml Platform tools.
However, please note that it is still experimental and in active development.

If you are setting up OCaml on Windows and are unsure which installation method to use, you might be
interested in reading [OCaml on Windows](/docs/ocaml-on-windows) first.

**Guidelines for Following Instructions on this Page**

A **shell** is a program that will let you enter commands in a text window using only your keyboard. It's also known as a command line interface (CLI). When this page asks you to enter commands in your shell, use the following instructions for your system:
* On macOS you will run the `Terminal` app to start a shell
* On Windows, you can start PowerShell by pressing the Windows key (`⊞`), typing "PowerShell," and then clicking Open `Windows PowerShell`. There is an older shell called "Command Prompt" you can use as well
* On Linux, you are already familiar with a shell (typically bash or zsh)

The code blocks (in black) on this page show the required commands (the text after `#` gives more information on the following commands). Type each command after the prompt `$`, although it's often represented by a `%`, `>`, or another symbol as well. Ensure you use the exact case and spacing shown, then hit return/enter at the end of every line. For more information on using the CLI, please visit the [Command Line Crash Course video](https://www.youtube.com/watch?v=yz7nYlnXLfE) to learn some basics.

## Installing OCaml

OCaml has an official package manager, `opam`, which allows you to
conveniently switch between OCaml versions and much more. For example,
`opam` makes it practical to deal with different projects which
require different versions of OCaml.

[`opam`](https://opam.ocaml.org/) introduces the concept of a "switch," which is an isolated environment that contains an OCaml compiler together with a set of OCaml packages. Switches allow us to install independent sets of dependencies for different projects.

Find all the installation instructions for both Unix-like systems and Windows in the sections below:

* Linux or macOS: [Installation on Unix, including Linux and macOS](#installation-on-unix)
* Windows: [Installation on Windows](#installation-on-windows)

### Installation on Unix

Note: OCaml is available as a package in most Linux distributions; however, it is
often outdated. The best way to install OCaml is with `opam`, OCaml's package manager.

The following steps require to have these packages or tools installed:
`gcc`, `build-essential`, `curl`, `bubblewrap`, and `unzip`.

#### 1. Install opam

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
# Ubuntu and Debian:
$ apt install opam

# Archlinux
$ pacman -S opam
```

**Binary Distribution**

Depending on your package manager, you won't get the latest release of opam. If you want the latest release, consider installing it through the binary distribution, as shown below:

```shell
$ bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
```

#### 2. Initialise opam

On Unix, it's essential to initialise opam:

```shell
$ opam init          # Can take some time
$ eval $(opam env)
```

The first command (`opam init`) initialises the opam state (stored in a hidden folder `.opam` in your home directory). It also creates a first switch, usually called `default`, although this is just a convention. A switch is an independent OCaml environment with its own OCaml compiler, as well as a set of libraries and binaries. If you have installed OCaml through your system package manager, the first switch will be set up to use this compiler (it is called a "system switch"). Otherwise, it will build one from source, usually taking the most recent version of OCaml.

The second command (`eval $(opam env)`) modifies a few environment variables to make the shell aware of the switch you are using. For instance, it will add what is needed to the `PATH` variable so that typing `ocaml` in the shell runs the OCaml binary of the current switch.

**Please note:** At the end of the `opam init`, you are asked if you want to add a hook to your shell to best integrate with your system. Indeed, in order for the shell to be aware of the tools available in the current opam switch, a few environment variables need to be modified. For instance, the `PATH` variable has to be expanded so that typing `ocaml` in the shell runs the OCaml binary _of the current switch_. Answering `y` will provide a better user experience.

Now check the installation by running `opam --version`. You can compare it with the current version on [opam.ocaml.org](https://opam.ocaml.org/).

**Please note:** In case you are running `opam init` inside a Docker container,
you will be asked whether you want to disable sandboxing.
This is necessary, unless you run a privileged Docker container.

#### 3. Create an `opam` Switch

This step is necessary only if you need to install a specific version of OCaml,
or if you want to create a new independent environment.
(`opam init` already sets up a default `opam` switch for you to work in.)

You can create a new opam switch with the `opam switch create` command.
Specify which version as shown below (i.e., `opam switch create 4.14.0`).
All available versions of the OCaml base compiler can be found with `opam switch list-available ocaml-base-compiler`.
The most current version can also be found at [opam.ocaml.org](https://opam.ocaml.org/packages/ocaml-base-compiler/).

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

### Installation on Windows

In this section, we'll describe using the [Diskuv OCaml](https://github.com/diskuv/dkml-installer-ocaml#readme) ("DKML") Windows installer. Expect to see another officially-supported Windows installation provided directly by opam in the coming months; it will be compatible with your DKML installation.

Note that only OCaml version 4.14.0 is available via Diskuv OCaml.

> Advanced Users: If you are familiar with Cygwin or WSL2, there are other installation methods described on the [OCaml on Windows](/docs/ocaml-on-windows) page.

#### 1. Use the DKML Installer

Before using the DKML installer, briefly review the following:

* Do not use the installer if you have a space in your username (ex. `C:\Users\Jane Smith`).

* You need to **stay at your computer** and press "Yes" for any Windows security popups.
After the DKML installer finishes installing two programs (`Visual Studio Installer`
  and `Git for Windows`), you can leave your computer for the remaining one and a half (1.5) hours.

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

* OCaml 4.14.0 with Git and Visual Studio compiler: [setup-diskuv-ocaml-windows_x86_64-1.2.0.exe](https://github.com/diskuv/dkml-installer-ocaml/releases/download/v1.2.0/setup-diskuv-ocaml-windows_x86_64-1.2.0.exe)

#### 2. Create an `opam` Switch

This step is necessary only if you want to create a new independent environment.
`dkml init` already set up a default `opam` switch for you to work in.

You can create a new switch with the `dkml init` command.
The only compiler version available is 4.14.0.
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

### The OCaml Base Tools are Now Installed

After following the instructions in the respective previous section for your operating system,
OCaml is now installed in an opam switch. Among others, this provides the
following programs:

- A "toplevel," which can be called with the `ocaml` command. It consists of a read-eval-print loop ([REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)), similar to the `python` or `node` command, and can be handy to quickly try the language. The user interface of the OCaml toplevel is quite basic, but when we install the UTop package in the following section, we'll have an improved and easier-to-use REPL.

- A compiler to **native code**, called `ocamlopt`. It creates executables that can be executed directly on your system.

- A compiler to **bytecode**, called `ocamlc`. It creates executables that can be interpreted by a variety of runtime environments, making these executables portable between different operating systems (at the cost of runtime performance).

What we installed so far (theoretically) suffices to write, compile, and execute OCaml code. However, this basic installation is neither complete nor comfortable as a development environment.

### Installing the OCaml Platform Tools

The OCaml Platform Tools include:

- Dune, a fast and full-featured build system for OCaml
- Merlin and `ocaml-lsp-server` (OCaml's Language Server Protocol), which together enhance editors
(like Visual Studio Code, Vim, or Emacs) by providing many useful features such as "jump to definition"
- `odoc` to generate documentation from OCaml code
- OCamlFormat to automatically format OCaml code
- UTop, an improved REPL
- `dune-release` to release code to `opam-repository`, the central package directory of opam.

#### OCaml Platform Tools on Unix

All these tools can be installed in your current switch (remember that opam groups installed packages in independent switches) using the following command:

```shell
$ opam install dune merlin ocaml-lsp-server odoc ocamlformat utop dune-release
```

Now that the tools are installed, it remains to understand how to use them. Most of them will be driven either by the editor or by Dune, but UTop is handy to try OCaml or a specific library.

#### OCaml Platform Tools on Windows

The DKML installer already installed all of the OCaml Platform tools, except for Merlin.

If you need to use Merlin, you can install it in an `opam` switch that you created using `dkml init`:

```shell
$ opam install merlin
```

## One-Step Installation on Unix: The Platform Installer

The [OCaml Platform Installer](https://github.com/tarides/ocaml-platform-installer)
is an alternative way to install both the OCaml base tools (`ocaml`, `ocamlopt`, and `ocamlc`) and the OCaml Platform Tools.
If you decide to use the OCaml Platform Installer, you should use **neither**
the installation instructions from ["Installing OCaml"](#installing-ocaml),
**nor** the instructions from ["Installing the OCaml Platform Tools"](#installing-the-ocaml-platform-tools).

As of 2023, the OCaml Platform Installer is still experimental and in active development.
If you run into any trouble using it, please don't hesitate to [file an
issue](https://github.com/tarides/ocaml-platform-installer/issues).
If it doesn't work at all on your system, follow the instructions
in the section ["Installing OCaml"](#installing-ocaml).

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

## First Steps With OCaml

Now that OCaml and the OCaml Platform Tools are installed on your system,
we'll look into what you can do with them.

### Using the UTop REPL to Run OCaml Code

UTop is an extended and improved toplevel (REPL) for OCaml. Unlike the standard toplevel with the `ocaml` command, UTop features history, tab completion, interactive line editing, and the ability to load any package installed in your switch.

If you have never used a toplevel (REPL) before, think of it as an interactive terminal/shell that evaluates expressions. Type an OCaml expression, then press the Enter or Return key. The toplevel responds with the value of the evaluated expression.

OCaml comes with two additional compilers: one compiles to **native code** (sometimes called machine code or executable binary), directly read by the CPU, and the other compiles to **bytecode**, creating an executable that can be interpreted by a variety of runtime environments, making it more flexible.

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

### Configuring Your Editor

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

### Starting a New Project

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

#### Configure OCamlFormat to Format Your Code

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

#### Generate Documentation with `odoc`

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
