---
id: opam-switch-introduction
title: Introduction to opam Switches
description: |
  This page will give you a brief introduction to opam switches, what they're used for, and how to create them.
category: "Tooling"
---

OCaml's package manager, opam, introduces the concept of a _switch_, which is an isolated OCaml environment. These switches often cause confusion amongst OCaml newcomers, so this document aims to provide a better understanding of opam switches and their usage for managing dependencies and project-specific configurations. 

Opam is designed to manage multiple concurrent installation prefixes called "switches." Similar to Python's `virtualenv`, an opam switch is a tool that creates isolated environments. They are independent of each other and have their own set of installed packages, repositories, and configuration options. Switches also have their own OCaml compiler, libraries, and binaries. This enables you to have multiple compiler versions available at once.

## Listing Switches

The command below will display the opam switches that are configured on your system. After completing installation of OCaml, such as outlined in [Installing OCaml](/docs/installing-ocaml), a single switch called `default` will have been created. At that point, listing the switches will only show that switch.
```shell
$ opam switch list
#   switch   compiler      description
->  default  ocaml.4.13.1  default
```

## Creating a New Switch

To create a new opam switch, you can use the `opam switch` command followed by the desired switch name and an optional OCaml compiler version. For example, to create a switch named "my_project" with a specific OCaml compiler version, use:

```
opam switch create my_project <compiler-version>
```

Replace `<compiler-version>` with the version of the OCaml compiler you want to use. If you don't specify a compiler version, opam will choose the default version.

Next, **activate** your new switch. This will set it as the currently selected switch, so any OCaml-related operations will use this switch. You can activate it by running:

```
opam switch my_project
``` 

Replace `my_project` with the name of your new switch.

**Confirm** you've activated it by running:

```
opam switch
```
If the output is the name of your new switch, you've successfully activated it! Now you can use it for your OCaml projects and install OCaml packages, libraries, and dependencies specific to this switch without affecting other switches or the system-wide OCaml environment.

## Types of Switches

### Global Switches

Global switches are often used for system-wide OCaml installations and are not tied to a particular project or directory. A switch is created and configured at the system level and is typically used to manage OCaml and its ecosystem on a global scale. 

When creating an opam switch, it's global by default unless otherwise configured. You can also explicitly select a global switch by using the opam switch command with the `--global` flag.

Opam's **system switch** is a global switch that is associated with the OCaml installation on your operating system. The system switch is accessible across the entire system.

### Local Switches

A local opam switch, on the other hand, is tied to a specific project directory. It is created within the project's directory or subdirectory, so you can manage OCaml and its dependencies in the context of that particular project only.

In other words, local switches provide isolation for project-specific OCaml environments, allowing you to define and manage the specific compiler version and packages needed for a particular project.

They are particularly useful when you want to ensure that a project uses specific versions of OCaml and its packages without interfering with the system-wide or other project-specific OCaml installations.

Local switches are automatically selected based on the current working directory. When you navigate into a directory with an associated local switch, opam uses that switch for any OCaml-related operations within that directory.

## Selecting a Switch

Most package-related commands in opam operate within the context of a selected switch. You can select a switch in several ways:

**Global Selection**: Use the command `opam switch <switch>`. Opam will use this switch for all subsequent commands, unless overridden.

**Local Selection**: When working in a directory that contains a switch, it will be automatically selected. Local switches are external to the opam root.

**Environment Variable**: Set the `OPAMSWITCH=<switch>` environment variable to choose a switch within a single shell session. Use `eval $(opam env --switch <switch>)` to set the shell environment accordingly.

**Command-Line Flag**: Use the `--switch <switch>` command-line flag to specify a switch for a single command.

---

> Learn more details and uses of opam switches in the [opam manual's File Hierarchies page](https://opam.ocaml.org/doc/Manual.html) and its [page dedicated to switches](https://opam.ocaml.org/doc/man/opam-switch.html). 


