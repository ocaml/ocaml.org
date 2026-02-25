---
id: ocaml-on-windows
title: OCaml on Windows
description: >
  Read about the state of OCaml on Windows and our roadmap to improve Windows support.
category: "Resources"
---

We recommend installing [opam](https://opam.ocaml.org/) for new users. Opam, the OCaml package manager, has full Windows support since version 2.2 and provides the most up-to-date OCaml environment.

You can also use [Docker](#docker-images) or [WSL2](#wsl2).

The recommendations are based on the availability table below:

* Tier 1 is fully supported with the latest compilers.
* Tier 2 is supported but maintained when possible.
* Tier 3 is user supported.

```text
╭──────────────────────────────────────────────────────────────────────────╮
│ Tier   │ OCaml Version and Environment   │ Support                       │
│ ------ │ ------------------------------- │ ----------------------------- │
│ Tier 1 │ OCaml 5.x with Opam 2.2+        │ Full support.                 │
│ Tier 3 │ 5.x with WSL2                   │ User supported.               │
│ Tier 3 │ 5.x with Docker                 │ User supported.               │
╰──────────────────────────────────────────────────────────────────────────╯
```

## Installing Opam on Windows

Opam is distributed via winget for Windows. To install it, run the following command in your terminal:

```shell-session
> winget install Git.Git OCaml.opam
```

We recommend installing Git from `winget`; however, you can omit this step and install Git using your preferred method if needed.
Opam will look for a compatible Git, and if none is found, it will prompt you with a set of options to install one.

After installation, launch a new shell to access the opam binary.

```shell-session
$ opam --version
2.2.1
```

Once opam is installed, run the `opam init` command to set up your opam environment.

You will notice that the repository information fetching stage takes a while to
complete. This is normal (for the moment), so we advise our users to get
themselves their favourite hot beverage while it runs.

opam requires a Unix-like environment to function. By default,
opam relies on Cygwin and is also compatible with MSYS2.

At *init-time*, opam scans your machine for available Unix environments and
prompts you to choose your favourite option. We recommend
to let it create its own internal Cygwin installation that will remain managed
by opam. This cuts down possible interferences from other tools
that interact with such environments. Think of it as a
sandboxed environment.

Opam's default behavior when initialising is to install a fresh `switch` as
well as an OCaml compiler of version `> 4.05`. By default, opam chooses `mingw` as
a C compiler when creating switches, but know that you can choose to install an
alternative instead, like `msvc`, with the following command:

```sh
opam install system-msvc
```

After `opam init` completes, run the following command to update your environment:

On CMD:

```dosbatch
> for /f "tokens=*" %i in ('opam env --switch=default') do @%i
```

On PowerShell:

```powershell
> (& opam env --switch=default) -split '\\r?\\n' | ForEach-Object { Invoke-Expression $_ }
```

On [Nushell](https://www.nushell.sh/):

```nushell
> opam env --shell=powershell | parse "$env:{key} = '{val}'" | transpose -rd | load-env
```

Opam will display the shell update command each time it is needed.

You can verify your installation with

```text
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

You should now have a functioning OCaml environment ready for development. If you encounter any issues or need further assistance, don't hesitate to consult the [OCaml community](https://ocaml.org/community).

## Other Installation Environments

### WSL2

If you only need to *run* OCaml programs on a Windows machine, the simplest solution is to use the Windows Subsystem for Linux 2 (WSL2). WSL2 is a feature that allows Linux programs to run directly on Windows. WSL2 is substantially easier and faster to use than WSL1. Microsoft has comprehensive installation steps for [setting up WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

After you have installed WSL2 and chosen one Linux distribution (we suggest [Ubuntu LTS](https://apps.microsoft.com/store/detail/ubuntu/9PDXGNCFSCZV?hl=en-us&gl=US)), you can follow the
[Installing OCaml: Installation for Linux and macOS](/docs/installing-ocaml) steps.

### Docker Images

The [`ocaml/opam`](https://hub.docker.com/r/ocaml/opam) Docker Hub repository
now contains regularly-updated Windows images. This includes images using
`msvc` and `mingw`. If you are comfortable with Docker, this might be an
easier way to get a working Windows environment on your machine.

## Editor Support for OCaml on Windows

### Visual Studio Code (VSCode)

**If you use opam installation**, you will need to add opam switch prefix on your path that runs VSCode.

**If you use WSL2**, you will remotely connect to your WSL2 instance from
VSCode. Microsoft has a [useful blog post](https://code.visualstudio.com/blogs/2019/09/03/wsl2)
that covers getting WSL2 and Visual Studio Code connected.

### Vim and Emacs

**For Vim and Emacs** install the [Merlin](https://github.com/ocaml/merlin)
system using opam:

```console
opam install merlin
```

The installation procedure will print instructions on how to link Merlin with
your editor.

**If you use Vim**, the default Cygwin Vim will not work with
Merlin. You will need to install Vim separately. In addition to the usual
instructions printed when installing Merlin, you may need to set the PATH in
Vim:

```vim
let $PATH .= ";".substitute(system('opam config var bin'),'\n$','','''')
```
