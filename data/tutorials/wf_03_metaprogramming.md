---
id: metaprogramming
title: Preprocessors and PPXes
description: >
  An introduction to metaprogramming in OCaml, including preprocessors, ppx extensions and the ppxlib library.
category: "guides"
date: 2022-07-25T21:07:30-00:00
---


# Preprocessors and PPXes

Preprocessors are programs meant to be called at compile-time, so that they
alter the program's source code before the actual compilation. They can be very
useful for several things, such as the inclusion of a file, conditional
compilation, or use of macros.

To start with an example, taking inspiration from the syntax from the C
preprocessor, we could write something like that:


``` ocaml
let compiler_system = #SYSTEM

let f =
#if STDLIB > 2
  Stdlib.new_function
#else
  Stdlib.old_function
#endif
```

A preprocessor could, at compile time, replace the `#SYSTEM` macro by a string
with the information of the system on which it has been compiled, and only
include the line using the right function, which depends on the current version
of the `Stdlib`.

In OCaml, there are many preprocessors that are written by the community. OCaml
supports the execution of two kinds of preprocessors: one that work on the
source level, and the other that work on the [AST
level](#ocamls-parsetree-the-first-ocamls-ast). The latter is called "PPX", an
acronym for Pre-Processor eXtension.

While both types of preprocessing have their use-cases, in OCaml it is
recommended to use PPXes whenever possible, for several reasons:
- They integrate very nicely nicely with `merlin` and `dune`, so you will still
be able to get features such as error reporting in editor, jump to definition,
in the case of preprocessing.
- They are fast and compose well.
- They are especially [adapted to
  OCaml](#why-are-ppxes-especially-useful-in-ocaml).

This guide presents the state of the two kinds of preprocessors in OCaml, but
with an emphasis on PPXes.

## Preprocessors on the source file

As mentionned in the introduction, preprocessing the source file can be useful
for things that can be solved by string manipulation, such as file inclusion,
conditional compilation or macro expansion. Any preprocessor can be used, such
as the [C Preprocessor](https://gcc.gnu.org/onlinedocs/cpp/Invocation.html) or a
general preprocessor such as [`m4`](https://www.gnu.org/software/m4/m4.html).
However, some preprocessors such as
[`cppo`](https://github.com/ocaml-community/cppo) or
[`cinaps`](https://github.com/ocaml-ppx/cinaps) have been made especially to
integrate well with OCaml.


Preprocessing text files do not need specific support from the language, it is
more the role of the build system to drive the preprocessing. So, applying
preprocessors will boil down to telling `dune` about it. Only for educational
purpose, we show in the next section how to preprocess a file using OCaml's
compiler, the more relevant part being [Preprocessing with
dune](#preprocessing-with-dune).

### Preprocessing with `ocamlc` and `ocamlopt`

OCaml's compiler `ocamlc` and `ocamlopt` offer the `-pp` option to preprocess a
file in the compilation phase (but remember that you are encourage to use `dune`
to drive the preprocessing). Consider the following simple preprocessor which
replaces the string "World" by the string "Universe", here in the form of a
shell script:

``` shell
$ cat preprocessor.sh
#!/bin/sh

sed 's/World/Universe/g' $1
```

Compiling a classic "Hello, World!" program with this option
would alter the compilation:

``` shell
$ cat hello.ml
print_endline "Hello, World!";;

$ ocamlopt -pp preprocessor.sh hello.ml
$ ./a.out
Hello, Universe!
```

### Preprocessing with `dune`

The `dune` build system has a specific stanza to apply preprocessing to files.
The full documentation can be found
[here](https://dune.readthedocs.io/en/stable/concepts.html#preprocessing-specification),
and should serve as a reference. In this section, we only give a few examples.

The stanza to apply preprocessing on the source file is `(preprocess (action
(<action>)))`. The `<action>` part can be any user defined action, such as the
call to an external program, as specified by `(system <program>)`.

Putting all together, the following `dune` file would make the corresponding
module files be rewritten using our previously written `preprocessor.sh`:

``` dune
(executable
 (name main)
 (preprocess
  (action
   (system "./preprocessor.sh %{input-file}"))))
```

### The limits of manipulating text file

The complexities of a programming language syntax makes it very hard to
manipulate text in a way that is tied to the syntax. Suppose for instance that,
similarly to the previous example, you want to rewrite all occurences of "World"
by "Universe", but _inside the OCaml strings of the program_ only. It is quite
involved and requires a good knowledge of the OCaml syntax to do so, as there
are several delimiters for strings (such as `{| ...|}`), and linebreaks or
comments could get in the way...

Consider another example. Suppose you have defined a type, and you want to
generate at compile-time a serializer from this specific type, to an encoding of
it in a `json` format, such as `Yojson` (see
[here](#why-are-ppxes-especially-useful-in-ocaml) why it has to be generated at
compile-time). This serialization code could be written by a preprocessor, which
would look for the type in the file, and serialize it differently depending on
the structure of the type, that is whether it is a variants type, a record type,
the structure of its subtypes...

But, to understand the structure of the type, the preprocessor need to parse
those information. Given that parsing OCaml syntax is complex, it is not
something that we want to do do again and again whenever we write a new
preprocessor.

The solution to this is to use PPXes, preprocessors that run on the result of
the parsing of the file.

## PPXes

PPxes are a different kind of preprocessors, that do not run on the textual
source code, but on the result of the parsing: the Abstract Syntax Tree (AST),
or more precisely in OCaml, the parsetree. In order to understand PPXes well, we
need to understand what is this parsetree.

### OCaml's parsetree, the first OCaml's AST

During the compilation phase, OCaml's compiler will parse the input file into an
internal representation of it, called the parsetree. The program is represented
as a tree, with a very complicated OCaml type, that you can find in the
[`Parsetree` module](https://v2.ocaml.org/api/compilerlibref/Parsetree.html).

Let us give already a few properties of this tree:
- Each node in the AST has a type corresponding to a different role, such as
  "let definitions", "expressions", "patterns", ...
- The root of the tree is a list of `structure_item`s
- A `structure_item` can either represent a toplevel expression, a type
  definition, a let definition, ... This is determined using a variant type.

There are two complementary ways of getting a grasp on the parsetree type. One
is to read the API documentation, which include examples of what each type and
value represent. The other is to make OCaml dump the parsetree value of crafted
OCaml code. This is possible thanks to the option `-dparsetree`, available in
the `ocaml` toplevel (as well as in `utop`):

```shell

$ ocaml -dparsetree
[Omitted output]
# let x = 1 + 2 ;;

Ptop_def
  [
    structure_item (//toplevel//[1,0+0]..[1,0+13])
      Pstr_value Nonrec
      [
        <def>
          pattern (//toplevel//[1,0+4]..[1,0+5])
            Ppat_var "x" (//toplevel//[1,0+4]..[1,0+5])
          expression (//toplevel//[1,0+8]..[1,0+13])
            Pexp_apply
            expression (//toplevel//[1,0+10]..[1,0+11])
              Pexp_ident "+" (//toplevel//[1,0+10]..[1,0+11])
            [
              <arg>
              Nolabel
                expression (//toplevel//[1,0+8]..[1,0+9])
                  Pexp_constant PConst_int (1,None)
              <arg>
              Nolabel
                expression (//toplevel//[1,0+12]..[1,0+13])
                  Pexp_constant PConst_int (2,None)
            ]
      ]
  ]

val x : int = 3
```

Note that the parsetree is an internal representation of the code that happens
before typing the program, so an ill-typed program can be rewritten. The
internal representation after the typing is called the `Typedtree`, and can be
inspected using the `-dtypedtree` option of `ocaml` and `utop`. In what follows,
we will use AST to refer to the parsetree.

### PPX rewriters

In its core, a PPX rewriter is just a transformation that takes a parsetree, and
returns a possibly modified parsetree. But, there are subtleties. First, because
PPXes work on the internal representation parsetree, that is the result of
parsing, the source file need to be of valid OCaml syntax. So, we cannot
introduce custom syntax such as the `#if` from the C preprocessor. Instead, we
will use two special syntaxes that were introduced in OCaml 4.02: Extension
nodes, and attributes.

Secondly, a transformation that takes the full parsetree is not acceptable in
many cases, as rewriters are third party programs (in contrast with the C
compiler). To address this, we consider two kinds of restrictions to the general
PPX rewriters: derivers and extenders. They respectively correspond to the two
new syntax of OCaml 4.02.

#### Attributes and derivers

Attributes are additional information that can be attached to any node of the
AST. Those information can either be used by the compiler itself, for instance
to enable or disable warnings, add a "deprecated" warning, force or check that a
function is inlined... The full list of attributes used by the compiler is
available in the [manual](https://v2.ocaml.org/manual/attributes.html#ss:builtin-attributes).

The syntax of attributes is to suffix the node with `[@attribute_name payload]`,
where `payload` is itself an OCaml AST. The number of `@` determines to which
node the attribute is attached: `@` is for the closest node (expression,
patterns, ...), `@@` is for the closest block (type declaration, class fields,
...) and `@@@` is a floating attribute. More information for the syntax can be
found in the [manual](https://v2.ocaml.org/manual/attributes.html).

```ocaml
module X = struct
  [@@@warning "+9"]  (* locally enable warning 9 in this structure *)
  …
end
[@@deprecated "Please use module 'Y' instead."]
```

The previous example uses attributes reserved for the compiler, but any
attribute name can be put in a source code and used by a PPX for its
preprocessing.

```ocaml
type int_pair = (int * int) [@@deriving yojson]
```

A specific kind of PPX is associated with attributes: derivers. A deriver is a
PPX that will generate (or _derive_) some code from a structure or signature
item, such as a type definition. It is applied using the syntax above, where
multiple derivers are separated by commas. Note that the generated code is added
after the input code, which is left unmodified.

Derivers are great for generating functions that depend on the structure of a
defined type (this was the [example](#the-limits-of-manipulating-text-file)
given in the limitation of preprocessor on text files). Indeed, exactly the
right amount of information is passed to the PPX, and we also know that the PPX
won't modify any part of the source.

Example of derivers are:
- [`ppx_show`](https://github.com/thierry-martinez/ppx_show), which generate
  from a type a pretty printer for values of this type.
- Derivers that derives serializers from OCaml types to other formats, such as
  `json` with
  [`ppx_yojson_conv`](https://github.com/janestreet/ppx_yojson_conv), yaml with
  [`ppx_deriving_yaml`](https://github.com/patricoferris/ppx_deriving_yaml),
  `sexp` with [`ppx_sexp_conv`](https://github.com/janestreet/ppx_sexp_conv)...
- [`ppx_accessor`](https://github.com/janestreet/ppx_accessor/) to generate
  accessors for the fields of a given record type.

#### Extension nodes and extenders

Extension nodes are "holes" in the parsetree. They are accepted by the parser in
any place (in patterns, expression, identifiers, ...) but they are rejected
later by the compiler. As a result, they _have_ to be rewritten by a ppx for the
compilation to proceed.

The syntax for extension nodes is `[%extension_name payload]` where again the
number of `%` determines the kind of extension node: `%` is for "inside nodes"
such as expressions and patterns, and `%%` is for "toplevel nodes" such as
structure/signature items, or class fields, see the [formal
syntax](https://v2.ocaml.org/manual/extensionnodes.html).

``` ocaml
let v = [%html "<a href='ocaml.org'>OCaml!</a>"]
```

Sometimes a shorter infix syntax can be used, where the extension node name is
appended to a `let`, `begin`, `module` or `val`. A formal definition of the
syntax can be found in the OCaml
[manual](https://v2.ocaml.org/manual/extensionnodes.html).

```ocaml
let%html other_syntax = "<a href='ocaml.org'>OCaml!</a>"
```

Extension nodes are meant to be rewritten by a PPX, and in this regards
corresponds to a specific kind of PPX: extenders. An extender is a PPX rewriter
which will replace all occurences of extension nodes with a matching name, by
some generated code that depend only on the payload, without information on the
context of the extension node (that is, without access to the rest of the code)
and without modifying anything else.

Example of extenders includes:
- Extenders which allows to write OCaml values representing another language,
  directly in such language, such as:
      - `ppx_yojson` to generate `Yojson` values by writing `json` code,
      - `tyxml-ppx` to generate `Tyxml.Html` values by writing `html` code,
      - `ppx_mysql` to generate `ocaml-mysql` queries by writing `Mysql`
        queries...
- `ppx_expect` to generate cram tests from the payload of the extension node.

### Using PPXes

Similarly to preprocessors for the text source code, OCaml's compiler provide
the `-ppx` option to run a PPX during the compilation phase. The PPX will read
the parsetree from a file where the marshalled value has been dumped, and output
the rewritten parsetree the same way.

But again, the tool responsible for driving the compilation being `dune`, using
PPXes is just a matter of writing dune files. The same `preprocess` stanza
should be used, this time with `pps`:

```dune
  (preprocess (pps ppx1 ppx2))
```

And that's all you need to use PPXes! Although these instructions will work for
most PPXes, note that the first source of information will be the package
documentation, as some PPXes might need some special care to integrate with
dune.

### Why are PPXes especially useful in OCaml

Now that we know what is a PPX, and have seen example of such, let us see why it
is particularly useful in OCaml.

For one, the types are lost at execution time. That means that the structure of
a type cannot be deconstructed at execution time to control the flow. This is
why no general `to_string : 'a -> string` or `print : 'a -> ()` function can
exist in compiled binaries (in the toplevel, types are kept).

So any general function that depends on the structure of a type _must_ be
written at compile time, when types are still available.

For two, one of the strong features of OCaml is its type system, which can be
used to check sanity of many things. An example of this is the [`Tyxml`
library](https://github.com/ocsigen/tyxml), which uses the type system to ensure
that the resulting HTML value satisfies most of the W3C standards. However,
writing `Tyxml` values can be cumbersome compared to writing html syntax.
Transforming HTML code into OCaml values at compile time allows to keep both the
type-checker on the produced value and the familiarity of writing HTML code.

Other rewriters such as `ppx_expect` show that being able to enrich the syntax
via PPX rewriters is very useful, even outside of the specificity of OCaml.

## The need for controlling the PPX ecosystem: Ppxlib

Although PPXes are great for generating code at compile time, they raise a few
questions, especially in the presence of multiple PPX rewriters:
- What is the semantics of the composition of multiple PPXes? The order might
  matter.
- How can I trust that some part of my code are not modified, when using
  third-party PPXes?
- How can I keep short compilation time when using many rewriters?
- How can I write a PPX easily if I have to deal with parsing or demarshalling
  an AST, and deal with such a [long and complex
  type](https://v2.ocaml.org/api/compilerlibref/Parsetree.html) as in parsetree?
- How can I solve the problem that the OCaml syntax and the parsetree types
  change with OCaml version?

The good answer to these questions is a platform tool to write PPXes:
[ppxlib](https://github.com/ocaml-ppx/ppxlib/). It takes care of easing the
process of writing a PPX, ensure that composition is not too much of a problem,
and factors as much as possible the work in case of multiple rewriters applied
to a file.

The idea of ppxlib is that PPX authors can concentrate on their own part, the
rewriting logic. Then, they can register their transformation, and ppxlib will
be responsible for the rest of the work that all PPXes have to do: getting the
parsetree, giving it back to the compiler, creating an executable with a good
CLI. Multiple transformations can be registered to generate a single binary.

### One PPX for multiple OCaml version

One of the challenge in writing a PPX is the types of the `Parsetree` module,
and the OCaml syntax can change on version bump. To keep a PPX compatible with a
new version, it would have to update the transformation from the old
syntax or parsetree type, to the new syntax or parsetree type. But, by doing so
it would lose compatibility with the old OCaml version.

Ppxlib deals with this issue by converting parsetree types to and from the
latest version. A PPX author then only need to provide a transformation for the
latest version of OCaml and get a PPX that works on any version of OCaml. For
instance, when applying a PPX written for OCaml `5.0`, during a compilation with
ocaml `4.08`, ppxlib would get the `4.08` parsetree, transform it into a `5.00`
parsetree, use the registered PPX to transform the parsetree, and convert it
back to a `4.08` parsetree to continue the compilation.

### Restricting PPXes for composition, speed and security

Ppxlib explicitely support registering the restricted transformations that
corresponds to extenders and derivers. Writing those restricted PPXes has a lot
of advantages:
- Extenders and derivers won't modify your existing code, apart from the
  extension node. This is less error-prone, bugs have less critical effects and
  a user can be confident that no sensible part of their code is changed.
- As extenders and derivers are "context-free", in the sense that they run only
  with a limited part of the AST as input, they can all be run in a single pass
  of the AST. Moreover, they are not run "one after the other" but all at the
  same time, so their composition semantics do not depend on the order of
  execution.
- This single pass also means faster rewriting and thus faster compilation time
  for the projects using multiple PPXes.

Compared to this, rewriters that work on the whole AST can also be registered in
ppxlib, and they will be run in the alphabetical order of their name, after the
context-free pass.

Note that `dune` combines all PPXes written using ppxlib in a single
preprocessor binary, even if the PPXes come from different packages.

### Writing a PPX

If you want to write your own PPX, the place to start is [ppxlib's
documentation](https://ocaml.org/p/ppxlib/0.27.0/doc/index.html).
