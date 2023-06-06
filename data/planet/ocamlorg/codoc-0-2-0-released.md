---
title: "Improving the OCaml documentation toolchain"
authors: [ "OCaml Platform Team" ]
date: "2015-02-20"
description: "Release announcement for codoc 0.2.0"
---

Last week, we
[published](https://lists.ocaml.org/pipermail/platform/2015-February/000539.html)
an *alpha* version of a new OCaml documentation generator,
[codoc 0.2.0](https://github.com/dsheets/codoc).
In the 2014 OCaml workshop presentation ([abstract][], [slides][], [video][]),
we mentioned the 'module wall' for documentation and this attempts to fix it.
To try it out, simply follow the directions in the README on that repository,
or [browse some samples](http://dsheets.github.io/codoc) of the current,
default output of the tool. Please do bear in mind codoc and its constituent
libraries are still under heavy development and are *not* feature complete.

[abstract]: https://ocaml.org/meetings/ocaml/2014/ocaml2014_7.pdf
[slides]: https://ocaml.org/meetings/ocaml/2014/ocl-platform-2014-slides.pdf
[video]: https://www.youtube.com/watch?v=jxhtpQ5nJHg&list=UUP9g4dLR7xt6KzCYntNqYcw

`codoc`'s aim is to provide a widely useful set of tools for generating OCaml
documentation. In particular, we are striving to:

1. Cover all of OCaml's language features
2. Provide accurate name resolution and linking
3. Support cross-linking between different packages
4. Expose interfaces to the components we've used to build `codoc`
5. Provide a magic-free command-line interface to the tool itself
6. Reduce external dependencies and default integration with other tools

We haven't yet achieved all of these at all levels of our tool stack but are
getting close. `codoc` 0.2.0 is usable today (if a little rough in some areas
like default CSS).  This post outlines the architecture of the new system to
make it easier to understand the design decisions that went into it.

## The five stages of documentation

There are five stages in generating documentation from OCaml source
code. Here we describe how each was handled in the *past* (using
OCamldoc), the *present* (using our current prototype), and the *future*
(using the final version of the tools we are developing).

### Associating comments with definitions

The first stage is to associate the various documentation comments in
an `.ml` or `.mli` file with the definitions that they correspond to.

#### Past

Associating comments with definitions is handled by the OCamldoc
tool, which does this in two steps. First it parses the file using the regular
OCaml parser or [camlp4](https://github.com/ocaml/camlp4), just as in
normal compilation. It uses the syntax tree from the first step and then
re-parses the file looking for comments. This second parse is guided by the
location information in the syntax tree; for example if there is a definition
which ends on line 5 then OCamldoc will look for comments to attach to that
definition starting at line 6.

The rules used for attaching comments are quite intricate and whitespace
dependent. This makes it difficult to parse the file and attach comments
using a single parser. In particular, it would be difficult to do so in
a way that doesn't cause a lot of problems for camlp4 extensions. This
is why OCamldoc does the process in two steps.

A disadvantage of this two-step approach is that it assumes that the
input to any preprocessor is something which could reasonably be read by
the compiler/tool creating documentation, which may not always be the
case.

#### Present

Our current prototype associates comments with definitions within the
compiler itself. This relies on a patch to the OCaml compiler
([pull request #51 on GitHub](https://github.com/ocaml/ocaml/pull/51)).
Comment association is activated by the `-doc` command-line flag. It
uses (a rewritten version of) the same two-step algorithm currently
used by OCamldoc. The comments are then attached to the appropriate node
in the syntax tree as an attribute. These attributes are passed through
the type-checker and appear in `.cmt`/`.cmti` files, where they can be
read by other tools.

#### Future

We intend to move away from the two-step approach taken by OCamldoc. To
do this we will need to simplify the rules for associating comments with
definitions. One suggestion was to use the same rules as attributes,
however that seems to be overly restrictive. So the approach we hope to
take is to keep quite close to what OCamldoc currently supports, but
disallow some of the more ambiguous cases. For example,

    val x : int
    (** Is this for x or y? *)
    val y : float

may well not be supported in our final version.
We will take care to understand the impact of such design decisions and we
hope to arrive at a robust solution for the future.
By avoiding the two-step
approach, it should be safe to always turn on comment association rather
than requiring a `-doc` command-line flag.

### Parsing the contents of comments

Once you have associated documentation comments with definitions, you must
parse the contents of these comments.

#### Past

OCamldoc parses the contents of comments.

#### Present

In our current prototype, the contents of comments are parsed in the
compiler, so that the documentation attributes available in
`.cmt`/`.cmti` files contain a structured representation of the
documentation.

#### Future

We intend to separate parsing the contents of documentation comments
from the compiler. This means that the documentation will be stored as
strings within the `.cmt`/`.cmti` files and parsed by external
tools. This will allow the documentation language (and its parser) to
evolve faster than the distribution cycle of the compiler.

### Representing compilation units with types and documentation

The typed syntax tree stored in `.cmt`/`.cmti` files is not a convenient
representation for generating documentation from, so the next stage is
to convert the syntax tree and comments into some suitable intermediate
form. In particular, this allows `.cmt` files and `.cmti` files to be
treated uniformly.

#### Past

OCamldoc generates an intermediate form from a syntax tree, a typed
syntax tree, and the comments that it found and parsed in the earlier
stages. The need for both an untyped and typed syntax tree is a
historical artefact that is no longer necessary.

#### Present

Our current prototype creates an intermediate form in the
[doc-ock](https://github.com/lpw25/doc-ock-lib) library. This form can be
currently be created from `.cmti` files or `.cmi` files. `.cmi` files do
not contain enough information for complete documentation, but you can
use them to produce partial documentation if the `.cmti` files are not
available to you.

This intermediate form can be serialised to XML using
[doc-ock-xml](https://github.com/lpw25/doc-ock-xml).

#### Future

In the final version, doc-ock will also support reading `.cmt` files.

### Resolving references

Once you have a representation for documentation, you need to resolve
all the paths and references so that links can point to the correct
locations. For example,

   (* This type is used by {!Foo} *)
   type t = Bar.t

The path `Bar.t` and the reference `Foo` must be resolved so that the
documentation can include links to the corresponding definitions.

If you are generating documentation for a large collection of packages, there
may be more than one module called `Foo`. So it is important to be able
to work out which one of these `Foo`s the reference is referring to.

Unlike most languages, resolving paths can be very difficult in
OCaml due to the powerful module system. For example, consider the
following code:

```ocaml
module Dep1 : sig
 module type S = sig
   class c : object
     method m : int
   end
 end
 module X : sig
   module Y : S
 end
end

module Dep2 :
 functor (Arg : sig module type S module X : sig module Y : S end end) ->
   sig
     module A : sig
       module Y : Arg.S
     end
     module B = A.Y
   end

type dep1 = Dep2(Dep1).B.c;;
```

Here it looks like, `Dep2(Dep1).B.c` would be defined by a type
definition `c` within the submodule `B` of the functor `Dep2`. However,
`Dep2.B`'s type is actually dependent on the type of `Dep2`'s `Arg`
parameter, so the actual definition is the class definition within the
module type `S` of the `Dep1` module.

#### Past

OCamldoc does resolution using a very simple string based lookup. This
is not designed to handle collections of projects, where module names
are not unique. It is also not sophisticated enough to handle advanced
uses of OCaml's module system (e.g. it fails to resolve the path
`Dep2(Dep1).B.c` in the above example).

#### Present

In our current prototype, path and reference resolution are performed by
the [doc-ock](https://github.com/lpw25/doc-ock-lib) library. The implementation
amounts to a reimplementation of OCaml's module system that tracks
additional information required to produce accurate paths and references
(it is also lazy to improve performance). The system uses the digests
provided by `.cmti`/`.cmi` files to resolve references to other modules,
rather than just relying on the module's name.

#### Future

There are still some paths handled incorrectly by doc-ock-lib, which
will be fixed, but mostly the final version will be the same as the
current prototype.

### Producing output

Finally, you are ready to produce some output from the tools.

#### Past

OCamldoc supports a variety of output formats, including HTML and
LaTeX. It also includes support for plugins called "custom generators"
which allow users to add support for additional formats.

#### Present

`codoc` only supports HTML and XML output at present, although extra output
formats such as JSON should be very easy to add once the interfaces settle
down.  `codoc` defines a documentation index XML format for tracking package
hierarchies, documentation issues, and hierarchically localized configuration.

`codoc` also defines a scriptable command-line interface giving users access
to its internal documentation phases: extraction, linking, and rendering. The
latest instructions on how to use the CLI can be found in the
[README](https://github.com/dsheets/codoc).  We provide an OPAM remote with
all the working versions of the new libraries and compiler patches required to
drive the new documentation engine.

#### Future

As previously mentioned, [codoc](https://github.com/dsheets/codoc) and its
constituent libraries [doc-ock-lib](https://github.com/lpw25/doc-ock-lib)
and [doc-ock-xml](https://github.com/dsheets/doc-ock-xml) are still under
heavy development and are not yet feature complete. Notably, there are some
important outstanding issues:

1. Class and class type documentation has no generated HTML. ([issue codoc#9](https://github.com/dsheets/codoc/issues/9))
2. CSS is subpar. ([issue codoc#27](https://github.com/dsheets/codoc/issues/22))
3. codoc HTML does not understand `--package`. ([issue codoc#42](https://github.com/dsheets/codoc/issues/42))
4. opam doc is too invasive (temporary for demonstration purposes; tracked by ([issue codoc#48](https://github.com/dsheets/codoc/issues/48)))
5. Documentation syntax errors are not reported in the correct phase or obviously enough. ([issue codoc#58](https://github.com/dsheets/codoc/issues/58))
6. Character sets are not handled correctly ([issue doc-ock-lib#43](https://github.com/lpw25/doc-ock-lib/issues/43))
7. -pack and cmt extraction are not supported ([issue doc-ock-lib#35](https://github.com/lpw25/doc-ock-lib/issues/35) and [issue doc-ock-lib#3](https://github.com/lpw25/doc-ock-lib/issues/3))
8. Inclusion/substitution is not supported ([issue doc-ock-lib#2](https://github.com/lpw25/doc-ock-lib/issues/2))

We are very happy to take bug reports and patches at
<https://github.com/dsheets/codoc/issues>. For wider suggestions, comments,
complaints and discussions, please join us on the
[Platform mailing list](https://lists.ocaml.org/listinfo/platform).
We do hope that you'll let us know what you think and help us build a next
generation documentation tool which will serve our community admirably.
