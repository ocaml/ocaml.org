---
id: ocaml-on-windows
title: OCaml on Windows
description: >
  Read about the state of OCaml on Windows and our roadmap to improve Windows support.
category: "getting-started"
date: 2021-05-27T21:07:30-00:00
---

# OCaml on Windows

We recommend installing opam 2.2 for new users; it comes with full Windows support.

There are a couple scenarios when other OCaml installers may be useful:

* when you want **to develop applications and either are unfamiliar with Unix or care more about stability and ease-of-use than the latest compiler**, you can use [Diskuv OCaml](#diskuv-ocaml)
* when you want **only to run, not develop, applications**, you can use [Docker](#docker-images) or [WSL2](#wsl2)

The recommendations are based on the availability table below:
* Tier 1 is fully supported with the latest compilers
* Tier 2 is supported but maintained when possible
* Tier 3 is user supported

```
╭──────────────────────────────────────────────────────────────────────────╮
│ Tier   │ OCaml Version and Environment   │ Support                       │
│ ------ │ ------------------------------- │ ----------------------------- │
│ Tier 1 │ OCaml 5 with Opam 2.2           │ Full support.                 │
│ Tier 2 │ 4.12.1 with Diskuv OCaml        │ Supported on select versions. │
│ Tier 3 │ 5 with WSL2                     │ User supported.               │
│ Tier 3 │ 5 with Docker                   | User supported.               │
╰──────────────────────────────────────────────────────────────────────────╯
```

## Installation Environments

### Diskuv OCaml

Diskuv OCaml ("DKML") is a distribution of OCaml that supports software development in pure OCaml.
The distribution is unique in its:
* full compatibility with OCaml standards like opam, Dune, and OCamlfind.
* focus on "native" development (desktop software, mobile apps, and embedded software) through support for the standard native compilers,
  like Visual Studio and Xcode.
* ease-of-use through simplified installers and simple productivity commands. High school, college, and university students should be
  able to use it
* security through reproducibility, versioning, and from-source builds.

To install DKML, briefly review the following:

* You need to **stay at your computer** and press "Yes" for any Windows security popups. After the DKML installer finishes installing two programs (`Visual Studio Installer`
  and `Git for Windows`), you can leave your computer for the remaining one (1) hour.

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

Then download and run:

* OCaml 4.12.1 with Git and Visual Studio compiler: [setup-diskuv-ocaml-windows_x86_64-1.0.0.exe](https://github.com/diskuv/dkml-installer-ocaml/releases/download/v1.0.0/setup-diskuv-ocaml-windows_x86_64-1.0.0.exe)

Check that OCaml is installed properly with the following commands in your shell (PowerShell or Command Prompt).
The line beneath the $ command shows the desired output for both the OCaml version and the toplevel version:

```console
$ where.exe ocaml
C:\Users\frank\AppData\Local\Programs\DiskuvOCaml\0\usr\bin\ocaml.exe

$ ocaml -version
The OCaml toplevel, version 4.12.1
```

To learn more about Diskuv OCaml, see the [official
Diskuv OCaml documentation](https://diskuv.gitlab.io/diskuv-ocaml/#introduction).

### opam-repository-mingw

[opam-repository-mingw](https://github.com/fdopen/opam-repository-mingw) is an
[opam repository](https://opam.ocaml.org/doc/Manual.html#Repositories)
containing patches for packages to build and install on Windows as well as
mingw-w64 and MSVC compiler variants (in both 32 and 64-bit). For a long time this has been
maintained by [@fdopen](https://fdopen.github.io/opam-repository-mingw/) along
with [installers](https://fdopen.github.io/opam-repository-mingw/installation/)
to create a custom Cygwin environment with opam and OCaml installed.

As of August 2021, [the repository will no longer be updated](https://fdopen.github.io/opam-repository-mingw/2021/02/26/repo-discontinued/). It is still useful as an overlay to
the [default opam repository](https://github.com/ocaml/opam-repository). This
means if a package exists in `opam-repository-mingw` the opam client will use
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

If you only need to _run_ OCaml programs on a Windows machine, then the simplest solution is to use the Windows Subsystem for Linux 2 (WSL2). WSL2 is a feature that allows Linux programs to run directly on Windows. WSL2 is substantially easier and faster to use than WSL1. Microsoft has comprehensive installation steps for [setting up WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

After you have installed WSL2 and chosen one Linux distribution (we suggest [Ubuntu LTS](https://apps.microsoft.com/store/detail/ubuntu/9PDXGNCFSCZV?hl=en-us&gl=US)), you can follow the
[Get Up and Running With OCaml: Installation for Linux and macOS](/docs/up-and-running) steps.

### Docker Images

The [`ocaml/opam`](https://hub.docker.com/r/ocaml/opam) Docker Hub repository
now contains regularly updated Windows images. This includes images using
`msvc` and `mingw`. If you are comfortable with Docker, this might be an
easier way to get a working Windows environment on your machine.

## Editor Support for OCaml on Windows

### Visual Studio Code on Windows

**If you use the recommended DKML installer**, you will need to:
1. Go to `File` > `Preferences` > `Settings` view (or press `Ctrl ,`)
2. Select `User` > `Extensions` > `OCaml Platform`
3. **Uncheck** `OCaml: Use OCaml Env`

**If you use WSL2**, you will remotely connect to your WSL2 instance from
Visual Studio Code. Microsoft has a [useful blog post](https://code.visualstudio.com/blogs/2019/09/03/wsl2)
that covers getting WSL2 and Visual Studio Code connected.

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
