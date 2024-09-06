---
id: installing-ocaml
title: Installing OCaml
description: |
  This page will help you install OCaml and the OCaml Platform Tools. |
  These instructions work on Windows, and Unix systems like Linux, and macOS.
category: "First Steps"
---

This guide will walk you through a minimum installation of OCaml. That includes installing a package manager and [the compiler](#installation-on-unix-and-macos) itself. We'll also install some platform tools like a build system, support for your editor, and a few other important ones.

On this page, you'll find installation instructions for Linux, macOS, Windows, and &ast;BSD for recent OCaml versions. For Docker, Linux instructions apply, except when setting up opam.

**Note**: You'll be installing OCaml and its tools through a [command line interface (CLI), or shell](https://www.youtube.com/watch?v=0PxTAn4g20U)

## Install opam

OCaml has an official package manager, [opam](https://opam.ocaml.org/), which allows users to download and install OCaml tools and libraries. Opam also makes it practical to deal with different projects which require different versions of OCaml.

Opam also installs the OCaml compiler. Alternatives exist, but opam is the best way to install OCaml. Although OCaml is available as a package in most Linux distributions, it is often outdated. 

To install opam, you can [use your system package manager](https://opam.ocaml.org/doc/Install.html#Using-your-distribution-39-s-package-system) or download the [binary distribution](https://opam.ocaml.org/doc/Install.html#Binary-distribution). The details are available in these links, but for convenience, we use package distributions:

**For macOS**

If you're installing with [Homebrew](https://brew.sh/):

```shell
$ brew install opam
```

Or if you're using [MacPorts](https://www.macports.org/):

```shell
$ port install opam
```

**Note**: While it's rather straightforward to install opam using macOS, it's possible you'll run into problems later with Homebrew because it has changed the way it installs. The executable files cannot be found in ARM64, the M1 processor used in newer Macs. Addressing this can be a rather complicated procedure, so we've made [a short ARM64 Fix doc](/docs/arm64-fix) explaining this so as not to derail this installation guide.

**For Linux**

It's preferable to install opam with your system's package manager on Linux, as superuser. On the opam site, find [details of all installation methods](https://opam.ocaml.org/doc/Install.html). A version of opam above 2.0 is packaged in all supported Linux distributions. If you are using an unsupported Linux distribution, please either download a precompiled binary or build opam from sources.

If you are installing in Debian or Ubuntu:
```shell
$ sudo apt-get install opam
```

If you are installing in Arch Linux:
```shell
$ sudo pacman -S opam
```

**Note**: The Debian package for opam, which is also used in Ubuntu, has the OCaml compiler as a recommended dependency. By default, such dependencies are installed. If you want to only install opam without OCaml, you need to run something like this:
```shell
sudo apt-get install --no-install-recommends opam
```

**For Windows**

It's easiest to install opam with [WinGet](https://github.com/microsoft/winget-cli):

```shell
PS C:\> winget install Git.Git OCaml.opam
```

**Binary Distribution**

If you want the latest release of opam, install it through the binary distribution. On Unix and macOS, you'll need to install the following system packages first: `gcc`, `build-essential`, `curl`, `bubblewrap`, and `unzip`. Note that they might have different names depending on your operating system or distribution. Also, note this script internally calls `sudo`.

The following command will install the latest version of opam that applies to your system:
```shell
$ bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
```

On Windows, the winget package is maintained by opam's developers and uses the binaries released [on GitHub](https://github.com/ocaml/opam/releases), however you can also install using an equivalent PowerShell script:

```powershell
Invoke-Expression "& { $(Invoke-RestMethod https://raw.githubusercontent.com/ocaml/opam/master/shell/install.ps1) }"
```

> **Advanced Windows Users**: If you are familiar with Cygwin or WSL2, there are other installation methods described on the [OCaml on Windows](/docs/ocaml-on-windows) page.

## Initialise opam

After you install opam, you'll need to initialise it. To do so, run the following command, as a normal user. This might take a few minutes to complete.

```shell
$ opam init -y
```

**Note**: In case you are running `opam init` inside a Docker container, you will need to disable sandboxing, which is done by running `opam init --disable-sandboxing -y`. This is necessary, unless you run a privileged Docker container.

Make sure you follow the instructions provided at the end of the output of `opam init` to complete the initialisation. Typically, this is:
```
$ eval $(opam env)
```

on Unix, and from the Windows Command Prompt:

```
for /f\"tokens=*\" %i in ('opam env') do @%i
```

or from PowerShell:

```powershell
(& opam env) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ }
```

Opam is now installed and configured!

**Note**: opam can manage something called _switches_. This is key when switching between several OCaml projects. However, in this “getting started” series of tutorials, switches are not needed. If interested, you can read an introduction to [opam switches here](/docs/opam-switch-introduction).

> Any problems installing? Be sure to read the [latest release notes](https://opam.ocaml.org/blog/opam-2-2-0/).
> You can file an issue at https://github.com/ocaml/opam/issues or https://github.com/ocaml-windows/papercuts/issues.

## Install Platform Tools

Now that we've successfully installed the OCaml compiler and the opam package manager, let's install some of the [OCaml Platform tools](https://ocaml.org/docs/platform), which you'll need to get the full developer experience in OCaml:

- [UTop](https://github.com/ocaml-community/utop), a modern interactive toplevel (REPL: Read-Eval-Print Loop)
- [Dune](https://dune.build), a fast and full-featured build system
- [`ocaml-lsp-server`](https://github.com/ocaml/ocaml-lsp) implements the Language Server Protocol to enable editor support for OCaml, e.g., in VS Code, Vim, or Emacs.
- [`odoc`](https://github.com/ocaml/odoc) to generate documentation from OCaml code
- [OCamlFormat](https://opam.ocaml.org/packages/ocamlformat/) to automatically format OCaml code

All these tools can be installed using a single command:
```shell
$ opam install ocaml-lsp-server odoc ocamlformat utop
```

You're now all set and ready to start hacking.

## Check Installation

To check that everything is working properly, you can start the UTop toplevel:
```shell
$ utop
────────┬─────────────────────────────────────────────────────────────┬─────────
        │ Welcome to utop version 2.13.1 (using OCaml version 5.1.0)! │
        └─────────────────────────────────────────────────────────────┘

Type #utop_help for help about using utop.

─( 00:00:00 )─< command 0 >──────────────────────────────────────{ counter: 0 }─
utop #
```

You're now in an OCaml toplevel, and you can start typing OCaml expressions. For instance, try typing `21 * 2;;` at the `#` prompt, then hit `Enter`. You'll see the following:
```ocaml
# 21 * 2;;
- : int = 42
```

**Congratulations**! You've installed OCaml! 🎉

## Join the Community

Make sure you [join the OCaml community](/community). You'll find many community members on [Discuss](https://discuss.ocaml.org/) or [Discord](https://discord.com/invite/cCYQbqN). These are great places to ask for help if you have any issues.
