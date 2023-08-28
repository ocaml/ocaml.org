---
id: installing-ocaml
title: Installing OCaml
description: |
  This page will help you install OCaml and the OCaml Platform Tools. |
  These instructions work on Windows, and Unix systems like Linux, and macOS.
category: "Getting Started"
---

# Installing OCaml

This page will walk you through the installation of OCaml. Of course, this includes [installing the compiler](#installing-ocaml) itself, but it also installs a build system, a package manager, an LSP server to support your editor, and a few other tools that we'll describe [later](#setting-up-development-tools).

On this page, you'll find installation instructions for Linux, macOS, and *BSD for all OCaml versions. For Windows, we also provide instructions for installing OCaml 4.14.0 via the [Diskuv OCaml](https://github.com/diskuv/dkml-installer-ocaml#readme) Installer. Note that, if you use Windows Subsystem for Linux (WSL), the Unix instructions can be used on Windows.

Alternatively, for Linux, macOS, and *BSD, there is also the [OCaml Platform Installer](TODO:link-to-ocaml-platform-installer), which installs both OCaml and the OCaml Platform tools. However, please note that it is still experimental and in active development.

If you are setting up OCaml on Windows and are unsure which installation method to use, you might be interested in reading [OCaml on Windows](/docs/ocaml-on-windows) first.

**Guidelines for Following Instructions on this Page**

A **shell** is a program that will let you enter commands in a text window using only your keyboard. It's also known as a command line interface (CLI). When this page asks you to enter commands in your shell, use the following instructions for your system:
* On macOS, you will run the `Terminal` app to start a shell.
* On Windows, you can start PowerShell by pressing the Windows key (`⊞`), typing "PowerShell," and then clicking Open `Windows PowerShell`. There is an older shell called "Command Prompt" you can use as well.
* On Linux, you are already familiar with a shell (typically bash or zsh).

The code blocks (in black) on this page show the required commands (the text after `#` gives more information on the following commands). Type each command after the prompt `$` in your CLI (it could also be represented by a `%`, `>`, or another symbol on your machine). Ensure you use the exact case and spacing shown, then hit return/enter at the end of every line. For more information on using the CLI, please visit the [Command Line Crash Course video](https://www.youtube.com/watch?v=yz7nYlnXLfE) to learn some basics.

## Install OCaml

OCaml has an official package manager, opam, which allows you to conveniently switch between OCaml versions and much more. For example, opam makes it practical to deal with different projects which require different versions of OCaml.

[Opam](https://opam.ocaml.org/) introduces the concept of a "switch," which is an isolated environment that contains an OCaml compiler together with a set of OCaml packages. Switches allow us to install independent sets of dependencies for different projects. When installing OCaml, opam automatically creates a global switch (see ["How to Work with opam Switches"](link-to-opam-switch-doc) if you want to learn more).

Find all the installation instructions for both Unix-like systems and Windows in the sections below:

* Linux or macOS: [Installation on Unix, including Linux and macOS](#installation-on-unix)
* Windows: [Installation on Windows](#installation-on-windows)

### Installation on Unix

Note: OCaml is available as a package in most Linux distributions; however, it is often outdated. The best way to install OCaml is with opam, OCaml's package manager.

The following steps require these packages or tools installed:
`gcc`, `build-essential`, `curl`, `bubblewrap`, and `unzip`.

#### 1. Install opam

To install opam, you can [use your system package manager](https://opam.ocaml.org/doc/Install.html#Using-your-distribution-39-s-package-system) or download the [binary distribution](https://opam.ocaml.org/doc/Install.html#Binary-distribution). The details are available in the above links, but for convenience, we've copy a few of them here:

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

> While it's rather simple to install opam using macOS, it's possible you'll run into problems later with Homebrew because it has changed the way it installs. The executable files cannot be found in ARM64, the M1 processor used in newer Macs. Addressing this can be a rather complicated procedure, so we've made [a short ARM64 Fix doc](link-to-doc) explaining this so as not to derail this installation tutorial.

**For Linux**

It's easy to install opam with your system's package manager on Linux (e.g., `apt-get install opam` or similar). On the opam site, find [details of all installation methods](https://opam.ocaml.org/doc/Install.html). All supported Linux distributions package at least version 2.0.0 (you can check by running `opam --version`). If you are using an unsupported Linux distribution, please either download a precompiled binary or build opam from sources.

```shell
# Ubuntu and Debian:
$ apt install opam

# Archlinux
$ pacman -S opam
```

**Binary Distribution**

Depending on your package manager, you might not get the latest release of opam. If you want the latest release, consider installing it through the binary distribution, as shown below:

```shell
$ bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
```

#### 2. Initialise opam

On Unix-based systems, inlucing macOS, Linus, and BSD, it's essential to initialise opam:

```shell
$ opam init          # Can take some time
```
You will be asked if you want to add a hook to your shell to best integrate with your system, choose `y` both times. In order for the shell to be aware of the tools available in the current opam switch, a few environment variables need to be modified. For instance, the `PATH` variable has to be expanded so that typing `ocaml` in the shell runs the OCaml binary _of the current Opam switch_. Answering `y` will provide a better user experience.

`opam init` initialises the opam state (stored in a hidden folder `.opam` in your home directory). It also creates a first global Opam switch, usually called `default`, although this is just a convention.

An Opam switch is an independent OCaml environment with its own OCaml compiler, as well as a set of libraries and binaries. If you have installed OCaml through your system package manager, the first switch will be set up to use this compiler (it is called a "system switch"). Otherwise, it will build one from source, usually taking the most recent version of OCaml. [Read this document](/docs/managing-dependencies) to delve deeper into how to use opam switches for dependency management in your projects, if interested.

Next run:
```
$ eval $(opam env)
```

This command modifies a few environment variables to make the shell aware of the switch you are using. For instance, it will add what is needed to the `PATH` variable so that typing `ocaml` in the shell runs the OCaml binary of the current switch. If you chose `y` above after `opam init`, you shouldn't need to run `$ eval $(opam env)` in the future.

Now check the installation by running `opam --version`. You can compare it with the current version on [opam.ocaml.org](https://opam.ocaml.org/).

>**Please note:** In case you are running `opam init` inside a Docker container, you will be asked whether you want to disable sandboxing. This is necessary, unless you run a privileged Docker container.

### Installation on Windows

In this section, we'll describe using the [Diskuv OCaml](https://github.com/diskuv/dkml-installer-ocaml#readme) ("DKML") Windows installer. Expect to see another officially-supported Windows installation provided directly by opam in the coming months; it will be compatible with your DKML installation.

Note that only OCaml version 4.14.0 is available via Diskuv OCaml.

> Advanced Users: If you are familiar with Cygwin or WSL2, there are other installation methods described on the [OCaml on Windows](/docs/ocaml-on-windows) page.

#### 1. Use the DKML Installer

Before using the DKML installer, briefly review the following:

* Do not use the installer if you have a space in your username (ex. `C:\Users\Jane Smith`).

* You need to **stay at your computer** and press "Yes" for any Windows security popups.

After the DKML installer finishes installing two programs (`Visual Studio Installer` and `Git for Windows`), you can leave your computer for the remaining one and a half (1.5) hours.

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

To learn more about Diskuv OCaml, see the [official Diskuv OCaml documentation](https://diskuv-ocaml.gitlab.io/distributions/dkml/#introduction).

### The OCaml Base Tools are Now Installed

After following the instructions in the respective previous section for your operating system, OCaml is now installed in an opam switch.

Among others, this provides the following programs:

- A **"toplevel,"** which can be called with the `ocaml` command. It consists of a read-eval-print loop ([REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)), similar to the `python` or `node` command, and can be handy to quickly try the language. The user interface of the OCaml toplevel is quite basic, but when we install the UTop package in the following section, you can choose to use it instead. Many find it an improved and easier-to-use REPL.
- A compiler to **native code**, called `ocamlopt`. It creates executables that can be executed directly on your system.
- A compiler to **bytecode**, called `ocamlc`. It creates executables that can be interpreted by a variety of runtime environments, making these executables portable between different operating systems (at the cost of runtime performance).

Check that the installation was successful by running `which ocaml` and `ocaml -version`. The line beneath the $ command shows the desired output for both the OCaml version and the toplevel version (installed specifically with the above `switch` command):

```shell
$ which ocaml
/Users/frank/.opam/4.14.0/bin/ocaml

$ ocaml -version
The OCaml toplevel, version 4.14.0
```

What we installed so far (theoretically) suffices to write, compile, and execute OCaml code. However, this basic installation is neither complete nor comfortable as a development environment.

## The OCaml Platform Tools

The OCaml Platform Tools include:

- Dune, a fast and full-featured build system for OCaml
- Merlin and `ocaml-lsp-server` (OCaml's Language Server Protocol), which together enhance editors
(like Visual Studio Code, Vim, or Emacs) by providing many useful features such as "jump to definition"
- `odoc` to generate documentation from OCaml code
- OCamlFormat to automatically format OCaml code
- UTop, an improved REPL
- `dune-release` to release code to `opam-repository`, the central package directory of opam.

### Installing the OCaml Platform Tools on Unix

All these tools can be installed in your current switch (remember that opam groups installed packages in independent switches) using the following command:

```shell
$ opam install dune merlin ocaml-lsp-server odoc ocamlformat utop dune-release
```

Now that the tools are installed, it remains to understand how to use them. Most of them will be driven either by the editor or by Dune, but UTop is handy to try OCaml or a specific library.


## Up Next: A Tour of OCaml

Now that you're up and running with OCaml, it's time to take a [Tour of OCaml](/docs/a-tour-of-ocaml). You'll learn about OCaml's basic building blocks, like expressions, functions, operators, dealing with errors, modules, and more. 

Welcome to the OCaml Community!
