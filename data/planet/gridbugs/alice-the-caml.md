---
title: Alice the Caml
description: "Alice is an experimental OCaml build system emphasizing accessibility.
  It\u2019s still very much a work in progress and nowhere near ready for regular
  use. Currently it can build multi-file OCaml projects to executables and libraries.
  Its UI is inspired by cargo. I\u2019m one of the core Dune developers for my day
  job."
url: https://www.gridbugs.org/alice-the-caml/
date: 2025-08-26T00:00:00-00:00
preview_image: https://www.gridbugs.org/logo.png
authors:
- Gridbugs
source:
ignore:
keywords:
- alice
- build
- compiler
- deviates
- dune
- hello
- opam
- packaging
- precompiled
- x86_64
---

<p><a href="https://github.com/alicecaml/alice">Alice</a> is an experimental OCaml build
system emphasizing accessibility. It’s still very much a work in progress and
nowhere near ready for regular use. Currently it can build multi-file OCaml
projects to executables and libraries. Its UI is inspired by cargo.</p>
<p>I’m one of the core Dune developers for my day job. Dune is a mature and widely
used OCaml build system which it difficult to make large structural changes to
its UI and packaging philosophy. Alice is an experiment exploring the design
space of OCaml build systems when these constraints are lifted.</p>
<p>Here’s a tiny demo:</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>$ alice new hello
</span><span>$ cd hello
</span><span>$ cat src/main.ml
</span><span>let () = print_endline "Hello, World!"
</span><span>$ alice run
</span><span>Hello, World!
</span></code></pre>
<p>It has incremental builds though they are currently sequential. It generates a
build graph which could be executed in parallel but this is future work. Running
<code>alice dot</code> prints a graphviz file representing the build graph.</p>
<p>It uses my <a href="https://github.com/gridbugs/climate">climate</a> library for its CLI
and so contains an inbuilt mechanism for generating bash completion scripts.</p>
<p>It doesn’t assume anything about your OCaml compiler setup. You can install the
compiler with opam or nix or your system package manager or manually build it from
source if you like. However it does come with a mechanism for downloading a
precompiled OCaml toolchain and some other tools (an LSP server and code
formatter), avoiding the need for users to build the compiler from source which
can be time-consuming. Precompiled toolchains are available for Linux x86_64,
MacOS x86_64/aarch64 and Windows x86_64, though I haven’t yet ported Alice to
Windows. Alice deviates from opam in that the compiler and development tools are
not considered to be packages.</p>
<p>There’s currently no packaging story and packages cannot yet depend on one
another. It would be nice to one day support depending on opam packages but this
is not going to be the default package format and opam compatibility isn’t a
major priority for the project. Instead I’ll design a packaging system
prioritizing ease of publishing and maintenance with as low cognitive load as
possible, and then see how opam compatibility can fit into that picture.</p>
<p>The name comes from an <a href="https://www.youtube.com/watch?v=XM7Jnetdf0I">Australian children’s
song</a>.</p>
<p>My next two goals for the project are Windows support and basic package
management.</p>
<pre style="background-color:#ffffff;color:#323232;"><code><span>$ alice --help
</span><span>Alice is a build system for OCaml projects.
</span><span>
</span><span>Usage: alice [COMMAND]
</span><span>       alice [OPTION]…
</span><span>
</span><span>Options:
</span><span>  -h, --help  Show this help message.
</span><span>
</span><span>Commands:
</span><span>  build, b  Build a project.
</span><span>  clean, c  Delete all generated build artifacts.
</span><span>  dot       Print graphviz source describing build artifact dependencies.
</span><span>  new       Create a new alice project.
</span><span>  tools     Manage tools for building and developing OCaml projects.
</span><span>  run, r    Build a project and run its executable.
</span><span>  help      Print documentation for a subcommand.
</span><span>  internal  Internal commands.
</span></code></pre>
<p>Read more on <a href="https://www.alicecaml.org">Alice’s website</a>!</p>
