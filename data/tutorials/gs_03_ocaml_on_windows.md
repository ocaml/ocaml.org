---
id: ocaml-on-windows
title: OCaml on Windows
description: >
  Read about the state of OCaml on Windows and our roadmap to improve Windows support.
category: "getting-started"
date: 2021-05-27T21:07:30-00:00
---

# OCaml on Windows

There is a new [Diskuv OCaml][DKML] ("DKML") Windows
installer that we recommend for new users. However, while [Diskuv OCaml][DKML] has a modern OCaml 4.14.0 compiler,
it does not track the latest OCaml compilers. We will officially support Windows as a Tier 1
platform with a [major release of opam](#opam-22) in the coming months, and it will be compatible with
DKML installations.

[DKML]: https://github.com/diskuv/dkml-installer-ocaml#readme

Our guidance is when you want:

* **Only to run, not develop, applications**, use [Docker](#docker-images) or [WSL2](#wsl2)
* **To develop applications and have some familiarity with Unix**, use [opam-repository-mingw](#opam-repository-mingw)
* **To develop applications and care more about stability and ease-of-use than the latest compiler**, use [Diskuv OCaml](https://diskuv-ocaml.gitlab.io/distributions/dkml/)

The guidance is based on the availability table below:
* Tier 1 is fully supported with the latest compilers
* Tier 2 is supported but maintained when possible
* Tier 3 is user supported

```
╭──────────────────────────────────────────────────────────────────────────────────────────╮
│ Tier   │ OCaml Version and Environment     │ Support and Availability                    │
│ ------ │ --------------------------------- │ ------------------------------------------- │
│ Tier 1 │ OCaml 5 with Opam 2.2             │ Full support. Coming in the next few months │
│ Tier 2 │ 4.14.0 with Diskuv OCaml          │ Supported on select versions. Available now │
│ Tier 3 │ 4.14.0 with opam-repository-mingw │ Deprecated. Available now and mostly works  │
│ Tier 3 │ 4.14.1 with WSL2                  │ User supported. Available now               │
│ Tier 3 │ 4.14.1 with Docker                | User supported. Available now               │
╰──────────────────────────────────────────────────────────────────────────────────────────╯
```

## Opam 2.2

After the [successful release](https://github.com/ocaml/opam/releases/tag/2.1.0)
of opam 2.1.0, the [next version](https://github.com/ocaml/opam/projects/2) of
opam will focus on closing the gap to fully support Windows. This includes
supporting an external dependency installation for Windows and integrating it with the
Windows shell. From an `opam-repository` perspective, the `ocaml-base-compiler`
packages will support the Mingw-w64 and MSVC variants.

## Installation Environments

### `opam-repository-mingw`

[opam-repository-mingw](https://github.com/fdopen/opam-repository-mingw) is an
[opam repository](https://opam.ocaml.org/doc/Manual.html#Repositories)
that contains patches for packages to build and install on Windows as well as
Mingw-w64 and MSVC compiler variants (in both 32 and 64-bit). For a long time, this has been
maintained by [@fdopen](https://fdopen.github.io/opam-repository-mingw/) along
with [installers](https://fdopen.github.io/opam-repository-mingw/installation/)
to create a custom Cygwin environment with opam and OCaml installed.

As of August 2021, [the repository will no longer be updated](https://fdopen.github.io/opam-repository-mingw/2021/02/26/repo-discontinued/). It is still useful as an overlay to
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
[Get Up and Running With OCaml: Installation for Linux and macOS](/docs/up-and-running) steps.

### Docker Images

The [`ocaml/opam`](https://hub.docker.com/r/ocaml/opam) Docker Hub repository
now contains regularly-updated Windows images. This includes images using
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
