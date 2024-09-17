---
id: ocaml-on-windows
title: OCaml on Windows
description: >
  Read about the state of OCaml on Windows and our roadmap to improve Windows support.
category: "Resources"
---

## opam

Opam now features a fully native Windows compatible installation process that we
recommend new users to follow below.

In order to have access to OCaml on a Windows PC, users have to use opam so that's our
first step.

Windows Developers out there will already be familiar with `winget` which is
the default package installer for Windows. Opam is now distributed with it. 

```shell-session
$ winget show OCaml.opam
Found opam [OCaml.opam]
Version : 2.2.1
Publisher : OCaml, Inc.
[...]
```

Installing opam is done by running the following command in your terminal:

```shell-session
> winget install OCaml.opam
Found opam [OCaml.opam] Version 2.2.1
This application is licensed to you by its owner.
Microsoft is not responsible for, nor does it grant any licenses to, third-party packages.
Downloading https://github.com/ocaml/opam/releases/download/2.2.1/opam-2.2.1-x86_64-windows.exe
  ██████████████████████████████  9.89 MB / 9.89 MB
Successfully verified installer hash
Starting package install...
Path environment variable modified; restart your shell to use the new value.
Command line alias added: "opam"
Successfully installed
Notes: See https://opam.ocaml.org/blog for the latest news on how to use opam.
```

Once the package is installed, you can launch a new shell to have access to
your fresh opam binary.

```shell-session
$ opam --version
2.2.1
```

As for any other platform out there, you have to initialise your opam
installation with the `opam init` command. 

The first thing to know is that opam requires a UNIX-like environment to
function. By default, opam relies on `cygwin` and is also compatible with
`msys2`.

At *init-time*, opam scans your machine for available UNIX environments and
prompts you to choose your favourite option. That being said, it is recommended
to let it create its own internal Cygwin installation that will remain managed
by opam. This allows to cut down the possible interferences that other tools
that interact with such environments might introduce. Think of it as a
sandboxed environment.

You will notice that the repository information fetching stage takes a while to
complete. This is normal and related to how files are handled on Windows, we
advice our users to go get themselves their favourite hot beverage while it
runs.

```shell-session
> opam init
No configuration file found, using built-in defaults.

<><> Windows Developer Mode <><><><><><><><><><><><><><><><><><><><><><><><>  🐫
opam does not require Developer Mode to be enabled on Windows, but it is
recommended, in particular because it enables support for symlinks without
requiring opam to be run elevated (which we do not recommend doing).

More information on enabling Developer Mode may be obtained from
https://learn.microsoft.com/en-gb/windows/apps/get-started/enable-your-device-for-development

<><> Unix support infrastructure ><><><><><><><><><><><><><><><><><><><><><>  🐫

opam and the OCaml ecosystem in general require various Unix tools in order to operate correctly. At present, this requires the installation of Cygwin to provide these tools.

How should opam obtain Unix tools?
> 1. Automatically create an internal Cygwin installation that will be managed by opam (recommended)
  2. Use Cygwin installation found in C:\cygwin64
  3. Use MSYS2 installation found in C:\msys64
  4. Use another existing Cygwin/MSYS2 installation
  5. Abort initialisation

[1/2/3/4/5]
Checking for available remotes: rsync and local, git.
  - you won't be able to use mercurial repositories unless you install the hg command on your system.
  - you won't be able to use darcs repositories unless you install the darcs command on your system.

<><> Fetching repository information ><><><><><><><><><><><><><><><><><><><>  🐫
[default] Initialised

<><> Required setup - please read <><><><><><><><><><><><><><><><><><><><><>  🐫

  In normal operation, opam only alters files within ~\AppData\Local\opam.

  However, to best integrate with your system, some environment variables
  should be set. When you want to access your opam installation, you will
  need to run:

    for /f "tokens=*" %i in ('opam env') do @%i

  You can always re-run this setup with 'opam init' later.

opam doesn't have any configuration options for cmd; you will have to run for /f "tokens=*" %i in ('opam env') do @%i
whenever you change you current 'opam switch' or start a new terminal session. Alternatively, would you like to select a
different shell? [y/n] n
```

One detail to address about having a fully functional opam installation is
related to Git.

On Windows, there are many ways to have a functioning Git installation. Opam will
look for a compatible Git and, if none is found, it will prompt you with a set of
options to install one. 

```shell-session
<><> Git ><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>  🐫
Cygwin Git is functional but can have credentials issues for private repositories, we recommend using:
  - Install via 'winget install Git.Git'
  - Git for Windows can be downloaded and installed from https://gitforwindows.org

Which Git should opam use?
> 1. Install Git with along with Cygwin internally
  2. Enter the location of your Git installation
  3. Abort initialisation to restart your shell.

[1/2/3]
```

Opam's default behaviour when initialising is to install a fresh `switch` as
well as an ocaml compiler of version `> 4.05`.

```shell-session
<><> Creating initial switch 'default' (invariant ["ocaml" {>= "4.05.0"}] - initially with ocaml-base-compiler)

<><> Installing new switch packages <><><><><><><><><><><><><><><><><><><><>  🐫
Switch invariant: ["ocaml" {>= "4.05.0"}]

The following system packages will first need to be installed:
    mingw64-x86_64-gcc-core

<><> Handling external dependencies <><><><><><><><><><><><><><><><><><><><>  🐫

[Installing external dependencies]

<><> Processing actions <><><><><><><><><><><><><><><><><><><><><><><><><><>  🐫
∗ installed arch-x86_64.1
∗ installed base-bigarray.base
∗ installed base-threads.base
∗ installed base-unix.base
∗ installed host-arch-x86_64.1
∗ installed host-system-mingw.1
⬇ retrieved mingw-w64-shims.0.2.0  (https://opam.ocaml.org/cache)
⬇ retrieved flexdll.0.43  (https://opam.ocaml.org/cache)
∗ installed flexdll.0.43
∗ installed ocaml-options-vanilla.1
∗ installed conf-mingw-w64-gcc-x86_64.1
∗ installed ocaml-env-mingw64.1
∗ installed system-mingw.1
⬇ retrieved ocaml-config.3  (2 extra sources)
⬇ retrieved ocaml-config.3  (2 extra sources)
∗ installed mingw-w64-shims.0.2.0
⬇ retrieved ocaml-base-compiler.5.2.0  (https://opam.ocaml.org/cache)
∗ installed ocaml-base-compiler.5.2.0
∗ installed ocaml-config.3
∗ installed ocaml.5.2.0
∗ installed base-domains.base
∗ installed base-nnp.base
Done.
# Run for /f "tokens=*" %i in ('opam env --switch=default') do @%i to update the current shell environment
```

You can see that in this specific run of the command, opam chose `mingw` as
a C compiler but know that you can very well choose an alternative to it
instead, like `msvc` with the following command:

```shell-session
$ opam install system-msvc
```

Once your environment has been updated with the given hint, you will have a
fully functional OCaml compiler available to you:

```shell-session
> for /f "tokens=*" %i in ('opam env --switch=default') do @%i

> ocaml --version
The OCaml toplevel, version 5.2.0

> ocaml
OCaml version 5.2.0
Enter #help;; for help.

# print_endline "Hello OCamleers!!";;
Hello OCamleers!!
- : unit = ()
#
```

## DkML

There is also [DkML] Windows installer. However, while [DkML] has a modern OCaml 4.14.0 compiler,
it does not track the latest OCaml compilers. We will officially support Windows as a Tier 1
platform with a [major release of opam](#opam-22) in the coming months, and it will be compatible with
DkML installations.

[DkML]: https://gitlab.com/dkml/distributions/dkml#installing

Our guidance is when you want:

* **To only run, and not develop, applications**, use [Docker](#docker-images) or [WSL2](#wsl2)
* **To develop applications and have some familiarity with Unix**, use [opam-repository-mingw](#opam-repository-mingw)
* **To develop applications and care more about stability and ease-of-use than the latest compiler**, use [DkML](https://gitlab.com/dkml/distributions/dkml#installing)

The guidance is based on the availability table below:

* Tier 1 is fully supported with the latest compilers.
* Tier 2 is supported but maintained when possible.
* Tier 3 is user supported.

```
╭──────────────────────────────────────────────────────────────────────────────────────────╮
│ Tier   │ OCaml Version and Environment     │ Support and Availability                    │
│ ------ │ --------------------------------- │ ------------------------------------------- │
│ Tier 1 │ OCaml 5 with Opam 2.2             │ Full support. Coming in the next few months │
│ Tier 2 │ 4.14.0 with DkML                  │ Supported on select versions. Available now │
│ Tier 3 │ 4.14.0 with opam-repository-mingw │ Deprecated. Available now and mostly works  │
│ Tier 3 │ 4.14.2 with WSL2                  │ User supported. Available now               │
│ Tier 3 │ 4.14.1 with Docker                | User supported. Available now               │
╰──────────────────────────────────────────────────────────────────────────────────────────╯
```

## Installation Environments

### `opam-repository-mingw`

[opam-repository-mingw](https://github.com/fdopen/opam-repository-mingw) is an
[opam repository](https://opam.ocaml.org/doc/Manual.html#Repositories)
that contains patches for packages to build and install on Windows as well as
MinGW-w64 and MSVC compiler variants (in both 32- and 64-bit). For a long time, this has been
maintained by [@fdopen](https://fdopen.github.io/opam-repository-mingw/) along
with [installers](https://fdopen.github.io/opam-repository-mingw/installation/)
to create a custom Cygwin environment with opam and OCaml installed.

As of August 2021, [the repository will no longer be updated](https://fdopen.github.io/opam-repository-mingw/2021/02/26/repo-discontinued/). However, it is still useful as an overlay to
the [default opam repository](https://github.com/ocaml/opam-repository). This
means if a package exists in `opam-repository-mingw`, the opam client will use
that information, otherwise it will fall through to `opam-repository`. To add
`opam-repository` as an underlay to your opam setup (assuming you followed the
manual installation from the [OCaml for Windows](https://fdopen.github.io/opam-repository-mingw/installation/)
site), you can use:

```
opam repo add upstream https://opam.ocaml.org --rank 2 --all-switches --set-default
```

This assumes you only have the `opam-repository-mingw` repository for this switch set with
a priority of `1`.

### WSL2

If you only need to _run_ OCaml programs on a Windows machine, the simplest solution is to use the Windows Subsystem for Linux 2 (WSL2). WSL2 is a feature that allows Linux programs to run directly on Windows. WSL2 is substantially easier and faster to use than WSL1. Microsoft has comprehensive installation steps for [setting up WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

After you have installed WSL2 and chosen one Linux distribution (we suggest [Ubuntu LTS](https://apps.microsoft.com/store/detail/ubuntu/9PDXGNCFSCZV?hl=en-us&gl=US)), you can follow the
[Installing OCaml: Installation for Linux and macOS](/docs/installing-ocaml) steps.

### Docker Images

The [`ocaml/opam`](https://hub.docker.com/r/ocaml/opam) Docker Hub repository
now contains regularly-updated Windows images. This includes images using
`msvc` and `mingw`. If you are comfortable with Docker, this might be an
easier way to get a working Windows environment on your machine.

## Editor Support for OCaml on Windows

### Visual Studio Code on Windows

**If you use opam installation**, you will need to add opam switch prefix on your path that runs VSCode.

**If you use the recommended DkML installer**, you will need to:

1. Go to `File` > `Preferences` > `Settings` view (or press `Ctrl ,`).
2. Select `User` > `Extensions` > `OCaml Platform`.
3. **Uncheck** `OCaml: Use OCaml Env`.

**If you use WSL2**, you will remotely connect to your WSL2 instance from
Visual Studio Code. Microsoft has a [useful blog post](https://code.visualstudio.com/blogs/2019/09/03/wsl2)
covering getting WSL2 and Visual Studio Code connected.

### Vim and Emacs on Windows

**For Vim and Emacs** install the [Merlin](https://github.com/ocaml/merlin)
system using opam:

```console
$ opam install merlin
```

The installation procedure will print instructions on how to link Merlin with
your editor.

**If you use Vim**, the default Cygwin Vim will not work with
Merlin. You will need install Vim separately. In addition to the usual
instructions printed when installing Merlin, you may need to set the PATH in
Vim:

```vim
let $PATH .= ";".substitute(system('opam config var bin'),'\n$','','''')
```
