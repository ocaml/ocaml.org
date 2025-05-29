---
title: "Dune Developer Preview: Installing Developer Tools with Dune"
tags: [dune, developer-preview]
---

_Discuss this post on [Discuss](https://discuss.ocaml.org/t/installing-developer-tools-with-dune/15612)!_

Dune can install and run developer tools in the context of a project. This
feature is available in the [Dune Developer
Preview](https://preview.dune.build/) and in the upcoming release of Dune 3.17.
As with all of Dune's package management features, consider this feature to be unstable as
its UI and semantics may change without notice.

The currently supported tools are `ocamllsp` and `ocamlformat`. Dune has a new
command `dune tools exec <TOOL> -- [ARGS]...` which downloads and installs the
given tool, and then runs it with the given arguments (note the `--` which
separates arguments to `dune` from arguments to the tool). Tools are installed
locally to the project, in its `_build` directory, which makes it easy to use
different versions of a tool in different projects. An unfortunate consequence
of installing tools into `_build` is that for the time being all tools are
uninstalled whenever `dune clean` is run.

Let's see it in action:
```
$ dune tools exec ocamlformat -- --version
Solution for dev-tools.locks/ocamlformat:
- ocamlformat.0.26.2+binary-ocaml-5.2.0-built-2024-11-07.0-x86_64-unknown-linux-musl
    Building ocamlformat.0.26.2+binary-ocaml-5.2.0-built-2024-11-07.0-x86_64-unknown-linux-musl
     Running 'ocamlformat --version'
0.26.2
```

## Precompiled Binaries

Note that in the example above, Dune's package solver chose to install version `0.26.2+binary-ocaml-5.2.0-built-2024-11-07.0-x86_64-unknown-linux-musl`
of `ocamlformat`. This packages comes from a new [repository of binary packages](https://github.com/ocaml-dune/ocaml-binary-packages)
containing pre-built executables for a select few Opam packages. Dune will search this
repository in addition to the default repositories when solving packages for
tools only (if a project has `ocamlformat` in its dependencies, the binary
repository won't be searched while solving the project's dependencies).

The goal of the binary repository is to reduce the time it takes to get started
working on a new project. Without it, Dune would need to build `ocamlformat`
from source along with all of its dependencies, which can take several minutes.

For now only a small number of package versions are contained in the binary
repository. To demonstrate, here's what happens if we run `dune tools exec ocamlformat` in a project
with `version=0.26.1` in its `.ocamlformat` file:
```
 $ dune tools exec ocamlformat -- --version
Solution for dev-tools.locks/ocamlformat:
- astring.0.8.5
- base.v0.17.1
- base-bytes.base
- base-unix.base
- camlp-streams.5.0.1
- cmdliner.1.3.0
...
- ocamlformat.0.26.1
...
    Building base-unix.base
    Building ocaml-base-compiler.5.1.1
    Building ocaml-config.3
    Building ocaml.5.1.1
    Building seq.base
    Building cmdliner.1.3.0
...
    Building ocamlformat.0.26.1
     Running 'ocamlformat --version'
0.26.1
```

Dune parses `.ocamlformat` to determine which version of `ocamlformat` to
install, and `0.26.1` is not in the binary repo so it needed to be built from
source.

If your project requires a version of a package not available in the binary
repository, or you're on an operating system or architecture for which no binary
version of a package exists, the package will be built from source instead.
Currently the binary repository contains binaries of `ocamlformat.0.26.2`,
`ocaml-lsp-server.1.18.0` and `ocaml-lsp-server.1.19.0` for
`x86_64-unknown-linux-musl`, `x86_64-apple-darwin` and `aarch64-apple-darwin`.

Note that Linux binaries are statically linked with muslc so they should work on
all distros regardless of dynamic linker.

## Running `ocamllsp`

The program `ocamllsp` from the package `ocaml-lsp-server` analyzes OCaml code
and sends information to text editors using the [Language Server
Protocol](https://microsoft.github.io/language-server-protocol/). The tool is crucial
to OCaml's editor integration and it has a couple of quirks that are worth
mentioning here.

TL;DR: Install Dune with the install script on the [Developer Preview
page](https://preview.dune.build/) and you'll get an [`ocamllsp` shell
script](https://github.com/ocaml-dune/binary-distribution/blob/main/tool-wrappers/ocamllsp)
that will install and run the correct version of `ocamllsp` for your project.

Firstly the `ocamllsp` executable can only analyze code that has been compiled
with the same version of the OCaml compiler as was used to compile the
`ocamllsp` executable itself. Different versions of the `ocaml-lsp-server`
package are incompatible with some versions of the OCaml compiler (e.g.
`ocaml-lsp-server.1.19.0` must be built with at least `5.2.0` of the compiler).
This means that when Dune is choosing which version of `ocaml-lsp-server` to
install it needs to know which version of the compiler your project is using.
This is only known after the project has been locked (by running `dune pkg
lock`), so Dune will refuse to install `ocamllsp` in a project that doesn't
have a lock directory or for a project that doesn't depend on the OCaml compiler.

```
$ dune tools exec ocamllsp
Error: Unable to load the lockdir for the default build context.
Hint: Try running 'dune pkg lock'
```

The `ocaml-lsp-server` packages in the [binary
repository](https://github.com/ocaml-dune/ocaml-binary-packages) contain
metadata to ensure that the `ocamllsp` executable that gets installed was built
with the same version of the compiler as your project. For example the
`ocaml-lsp-server` package built with `ocaml.5.2.0` contains this line:

```
conflicts: "ocaml" {!= "5.2.0"}
```

This prevents it from being chosen if the project depends on any version of the
compiler other than `5.2.0`.

Another quirk is that `ocamllsp` will try to invoke the binaries `ocamlformat`
and `ocamlformat-rpc`, both found in the `ocamlformat` package. The
`ocaml-lsp-server` package doesn't depend on `ocamlformat` as the specific
version of `ocamlformat` needed by a project is implied by the project's `.ocamlformat`
file, which package managers don't consider when solving dependencies. This
means that in general (whether using Dune or Opam for package management) it's
up to the user to make sure that the correct version of `ocamlformat` is
installed in order to use the formatting features of `ocamllsp`.

Otherwise expect this error in your editor:
```
Unable to find 'ocamlformat-rpc' binary. Types on hover may not be well-formatted. You need to install either 'ocamlformat' of version > 0.21.0 or, otherwise, 'ocamlformat-rpc' package.
```

Even if `ocamllsp` and `ocamlformat` are both installed by Dune, if you run
`dune tools exec ocamllsp` you will find that `ocamllsp` still can't find the
`ocamlformat` or `ocamlformat-rpc` executables. This is because unlike Opam,
Dune does not install tools into your `$PATH`, and for the sake of simplicity,
the `dune tools exec <TOOL>` command does not modify the environment of the tool
it launches. This can be fixed by adding
`_build/_private/default/.dev-tool/ocamlformat/ocamlformat/target/bin` (the
directory containing `ocamlformat` and `ocamlformat-rpc` when `ocamlformat` is
installed by dune) to the start of your `$PATH` variable before running
`dune tools exec ocamllsp`. For example starting `ocamllsp` with the following shell script:

```bash
OCAMLFORMAT_TARGET="_build/_private/default/.dev-tool/ocamlformat/ocamlformat/target"

if [ ! -f $OCAMLFORMAT_TARGET/cookie ]; then
    # Make sure that the ocamlformat dev tool is installed as it's needed by
    # ocamllsp. There's currently no command that just installs ocamlformat so
    # we need to run it and ignore the result.
    dune tools exec ocamlformat -- --help > /dev/null
fi

# Add ocamlformat to the environment in which ocamllsp runs so ocamllsp can invoke ocamlformat.
export PATH="$PWD/$OCAMLFORMAT_TARGET/bin:$PATH"

# Build and run ocamllsp.
dune tools exec ocamllsp -- "$@"
```

Of course, it's rare to manually start `ocamllsp` directly from your terminal.
It's normally launched by text editors. It would be impractical to configure your text
editor to modify `$PATH` and run a custom command to start `ocamllsp` via Dune,
and doing so would make it impossible to edit any project that _doesn't_ use
Dune for package management. Instead, the Dune Developer Preview ships with
[a shell script](https://github.com/ocaml-dune/binary-distribution/blob/main/tool-wrappers/ocamllsp)
which installs `ocamlformat` and adds its `bin` directory to `$PATH` before
launching `dune tools exec ocamllsp`. The script is simply named `ocamllsp`, and
the Dune Developer Preview install script adds it to `~/.dune/bin` which should
already be in your `$PATH` if you're using the Developer Preview. The `ocamllsp`
script also attempts to fall back to an Opam-managed installation of `ocamllsp`
if it doesn't detect a Dune lockdir so the same script should work for non-Dune
projects. Because the script is named the same as the `ocamllsp` executable,
most editors don't require special configuration to run it. See the "Editor
Configuration" section of the [Dune Developer
Preview page](https://preview.dune.build/) for more information about setting up
your editor.


Some parts of the `ocamllsp` shell script may eventually make their way into
Dune itself, but for the time being the shell script is the recommended way to
launch `ocamllsp` for users of the Dune Developer Preview. The net result is
that as long as your project has a lockfile, the first time you edit some OCaml
code in the project Dune will download and run the appropriate version of
`ocamllsp`.
