---
id: "formatting-your-code"
title: "Formatting Your Code"
short_title: "Formatting Your Code"
description: |
  How to set up formatting of your code
category: "Editor Support"
---

## Using OCamlFormat

Automatic formatting with OCamlFormat requires an `.ocamlformat` configuration
file at the root of the project.

An empty file is accepted, but since different versions of OCamlFormat will
vary in formatting, it is good practice to specify the version you're using.
Running

```shell
echo "version = `ocamlformat --version`" > .ocamlformat
```

creates a configuration file for the currently installed version of
OCamlFormat.

In addition to editor plugins that use OCamlFormat for automatic code
formatting, Dune also offers a command to run OCamlFormat to automatically
format all files from your codebase:

```shell
opam exec -- dune fmt
```

## Using Topiary

[Topiary](https://topiary.tweag.io) is a Tree-sitter-based code formatter
supporting multiple languages, including OCaml & OCamllex. It can be invoked
with

<!-- markdownlint-disable commands-show-output -->
```shell-session
$ topiary format source.ml
```
<!-- markdownlint-restore -->

Topiary does not require an empty configuration file to operate & has its own
set of defaults, however, it can be
[configured](https://topiary.tweag.io/book/cli/configuration.html).

### Example configuration setup

This example configuration will override the default configuration to use 1 tab
character for indentation by creating a `.topiary.ncl` Nickel configuration
file.

<!-- markdownlint-disable commands-show-output -->
```shell-session
$ touch .topiary.ncl
$ $EDITOR .topiary.ncl
```
<!-- markdownlint-restore -->

<!-- markdownlint-disable no-hard-tabs -->
```nickel
{
	languages = {
		nickel.indent | priority 1 = "\t",
		ocaml.indent | priority 1 = "\t",
		ocaml_interface.indent | priority 1 = "\t",
		ocamllex.indent | priority 1 = "\t",
	},
}
```
<!-- markdownlint-restore -->

Then this file needs to be exported to the environment such as `export
TOPIARY_CONFIG_FILE=".topiary.ncl"` in Bash/ZSH or `set -x TOPIARY_CONFIG_FILE
".topiary.ncl"` in Fish.

TIP: If using Direnv, the environment variable can also be added to the user’s
personal `.envrc` so it is exported on switching to the project directory by
appending with `echo 'export TOPIARY_CONFIG_FILE=".topiary.ncl"' >> .envrc`.

Afterwards, `--merge-configuration` will always merge in the example
configuration. Invoke Topiary’s formatting with

<!-- markdownlint-disable commands-show-output -->
```shell-session
$ topiary format --merge-configuration source.ml
```
<!-- markdownlint-restore -->

and/or configure your editor to run this command on saving the file.
