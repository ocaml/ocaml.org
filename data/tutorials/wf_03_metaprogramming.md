---
id: metaprogramming
title: Preprocessors and PPXs
description: |
  An introduction to metaprogramming in OCaml, including preprocessors, PPX
  extensions and the `ppxlib` library.
category: "guides"
date: 2022-07-25T21:07:30-00:00
---


# Preprocessors

Preprocessors are programs meant to be called at compile time, so that they
alter the program before the actual compilation. They can be very
useful for several things, such as the inclusion of a file, conditional
compilation, boilerplate generation or extending the language.

To start with an example, here is how the following source code would be altered
by [this
preprocessor](https://github.com/ocaml-ppx/ppxlib/tree/main/examples/simple-extension-rewriter):


```ocaml
Printf.printf "This program has been compiled on %s" [%get_env "OSTYPE"]
```

would become:

```ocaml
Printf.printf "This program has been compiled on %s" "linux-gnu"
```


At compile time, the preprocessor would replace `[%get_env "OSTYPE"]` by a
string with the content of the `OSTYPE` environment variable. Note that this
happens at _compile time_, so at _run time_ the value of the `OSTYPE` variable
would have no effect.

## Source Preprocessors and PPXs

In OCaml, the preprocessors are written by the community, so there is no single
general-purpose preprocessor officially supported, like there is in C, for example.

OCaml supports the execution of two kinds of preprocessors: one that works on the
source level, and the other that works on the [AST
level](#ocamls-parsetree-the-first-ocamls-ast). The latter is called "PPX," an
acronym for Pre-Processor eXtension.

While both types of preprocessing have their use cases, in OCaml it is
recommended to use PPXs whenever possible for several reasons:
- They integrate very nicely with Merlin and Dune, and they won't interfere
  with features such as error reporting in an editor and Merlin's "jump to definition."
- They are fast and compose well, when [adequately written](#the-need-for-controlling-the-ppx-ecosystem-ppxlib).
- They are especially [adapted to
  OCaml](#why-are-ppxes-especially-useful-in-ocaml).

This guide presents the state of the two kinds of preprocessors in OCaml, but
with an emphasis on PPXs. Although the latter is the recommended way of writing
preprocessors, we start with source preprocessing in order to better understand
why PPXs are necessary in OCaml.

## Source Preprocessors

As mentionned in the introduction, preprocessing the source file can be useful
for things that can be solved by string manipulation, such as file inclusion,
conditional compilation, or macro expansion. Any preprocessor can be used, such
as the [C Preprocessor](https://gcc.gnu.org/onlinedocs/cpp/Invocation.html) or a
general preprocessor such as [`m4`](https://www.gnu.org/software/m4/m4.html).
However, some preprocessors such as
[`cppo`](https://github.com/ocaml-community/cppo) or
[`cinaps`](https://github.com/ocaml-ppx/cinaps) have been made especially to
integrate well with OCaml.


Preprocessing text files do not need specific support from the language. It is
more the build system's role to drive the preprocessing. So, applying
preprocessors will boil down to telling Dune about it. Only for educational
purposes, in the next section we show how to preprocess a file using OCaml's
compiler, the more relevant part being [Preprocessing with
Dune](#preprocessing-with-dune).

### Preprocessing with `ocamlc` and `ocamlopt`

OCaml's compiler `ocamlc` and `ocamlopt` offer the `-pp` option to preprocess a
file in the compilation phase (but remember that you are encourage to use Dune
to drive the preprocessing). Consider the following simple preprocessor which
replaces the string `"World"` by the string `"Universe"`, here in the form of a
shell script:

```shell
$ cat preprocessor.sh
#!/bin/sh

sed 's/World/Universe/g' $1
```

Compiling a classic "Hello, World!" program with this option
would alter the compilation:

```shell
$ cat hello.ml
print_endline "Hello, World!";;

$ ocamlopt -pp preprocessor.sh hello.ml
$ ./a.out
Hello, Universe!
```

### Preprocessing with Dune

Dune's build system has a specific stanza to apply preprocessing to files.
The full documentation can be found
[here](https://dune.readthedocs.io/en/stable/concepts.html#preprocessing-specification),
and should serve as a reference. In this section, we only give a few examples.

The stanza to apply preprocessing on the source file is `(preprocess (action
(<action>)))`. The `<action>` part can be any user-defined action, such as the
call to an external program, as specified by `(system <program>)`.

Putting it all together, the following `dune` file would rewrite the corresponding
module files using our previously written `preprocessor.sh`:

```dune
(executable
 (name main)
 (preprocess
  (action
   (system "./preprocessor.sh %{input-file}"))))
```

### The Limits of Manipulating Text Files

The complexities of a programming language syntax makes it very hard to
manipulate text in a way that is tied to the syntax. Suppose for instance that,
similarly to the previous example, you want to rewrite all occurences of "World"
by "Universe," but _inside the OCaml strings of the program_ only. It is quite
involved and requires a good knowledge of the OCaml syntax to do so, as there
are several delimiters for strings (such as `{| ...|}`) and line breaks, or
comments could get in the way...

Consider another example. Suppose you have defined a type, and you want to
generate a serializer at compile time from this specific type to an encoding of
it in a `json` format, such as `Yojson` (see
[here](#why-are-ppxes-especially-useful-in-ocaml) for the reasons it has to be
generated at compile-time). This serialization code could be written by a
preprocessor, which would look for the type in the file and serialize it
differently depending on the type structure; that is, whether it is a variants
type, a record type, the structure of its subtypes...

All these difficulties comes from the fact that we want to generate a program,
but we are manipulating a flat representation of it, as plain text. The lack of
structure of this representation has several disadvantages:
- It is difficult to read parts of the program, such as the type to generate a
serializer for in the example above
- It is error-prone to write programs as plain text, as there is no guarantee
  that the generate code always respects the syntax of the programming language.
  Such errors in code generation can be hard to debug!

The solution to both the reading and writing issues are to work on a much more
structured representation of a program, the result of the parsing, which is
precisely what are PPXs!

## PPXs

PPxs are a different kind of preprocessors—one that do not run on the textual
source code, but rather on the parsing result: the Abstract Syntax Tree (AST),
which in the OCaml compiler is called Parsetree. In order to understand PPXs well, we
need to understand what is this Parsetree.

### OCaml's Parsetree, the OCaml AST

During the compilation phase, OCaml's compiler will parse the input file into an
internal representation of it, called the Parsetree. The program is represented
as a tree, whose OCaml type can be found in the [`Parsetree`
module](https://v2.ocaml.org/api/compilerlibref/Parsetree.html).

Let's look at a few properties of this tree:
- Each node in the AST has a type corresponding to a different role, such as
  "let definitions," "expressions," "patterns," ...
- The tree's root is a list of `structure_item`s
- A `structure_item` can either represent a toplevel expression, a type
  definition, a let definition, ... This is determined using a variant type.

There are several complementary ways of getting a grasp on the Parsetree type.
One is to read the [API
documentation](https://v2.ocaml.org/api/compilerlibref/Parsetree.html)., which
includes examples of what each type and value represent. Another is to make
examine the Parsetree value of crafted OCaml code. This can be achieved using
external tools such as [astexplorer](https://astexplorer.net/), the OCaml
[VSCode
extension](https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform),
or even directly with the `ocaml` toplevel using the option `-dparsetree` (also
available in `utop`):

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

Note that the Parsetree is an internal representation of the code that happens
before typing the program, so an ill-typed program can be rewritten. The
internal representation after the typing is called the `Typedtree`, and it can be
inspected using the `-dtypedtree` option of `ocaml` and `utop`. In what follows,
we will use AST to refer to the parsetree.

### PPX Rewriters

At its core, a PPX rewriter is just a transformation that takes a Parsetree, and
returns a possibly modified Parsetree, but there are subtleties. First, PPXs
work on the parsetree, which is the result of parsing done by OCaml, so the
source file needs to be of valid OCaml syntax. Thus, we cannot introduce custom
syntax such as the `#if` from the C preprocessor. Instead, we will use two
special syntaxes that were introduced in OCaml 4.02: Extension nodes, and
attributes.

Secondly, most of the code transformation that PPXs do do not need to be given
the full AST, they can work locally in subparts of it. There are two kinds of
such local restrictions to the general PPX rewriters that cover most of the
usecases: derivers and extenders. They respectively correspond to the two new
syntaxes of OCaml 4.02.

#### Attributes and Derivers

Attributes are additional information that can be attached to any AST node. 
That information can either be used by the compiler itself (e.g., 
to enable or disable warnings), add a "deprecated" warning, or force/check that a
function is inlined. The full list of attributes that the compiler uses is
available in the [manual](https://v2.ocaml.org/manual/attributes.html#ss:builtin-attributes).

The attributes' syntax is to suffix the node with `[@attribute_name payload]`,
where `payload` is itself an OCaml AST. The number of `@` determines to which
node the attribute is attached: `@` is for the closest node (expression,
patterns, etc.), `@@` is for the closest block (type declaration, class fields, etc.), 
and `@@@` is a floating attribute. More information for the syntax can be
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

A specific kind of PPX is associated with attributes: derivers, a
PPX that will generate (or _derive_) some code from a structure or signature
item, such as a type definition. It is applied using the syntax above, where
multiple derivers are separated by commas. Note that the generated code is added
after the input code, which is left unmodified.

Derivers are great for generating functions that depend on the structure of a
defined type (this was the example given in the [limits of manipulating text
files](#the-limits-of-manipulating-text-file)). Indeed, exactly the right amount
of information is passed to the PPX, and we also know that the PPX won't modify
any part of the source.

Example of derivers are:
- [`ppx_show`](https://github.com/thierry-martinez/ppx_show), which generates
  from a type a pretty printer for values of this type.
- Derivers that derive serializers from OCaml types to other formats, such as
  JSON with
  [`ppx_yojson_conv`](https://github.com/janestreet/ppx_yojson_conv), YAML with
  [`ppx_deriving_yaml`](https://github.com/patricoferris/ppx_deriving_yaml), or
  SEXP with [`ppx_sexp_conv`](https://github.com/janestreet/ppx_sexp_conv)...
- [`ppx_accessor`](https://github.com/janestreet/ppx_accessor/) to generate
  accessors for the fields of a given record type.

#### Extension Nodes and Extenders

Extension nodes are "holes" in the Parsetree. They are accepted by the parser in
any place (patterns, expression, identifiers, etc.), but they are rejected
later by the compiler. As a result, they _have_ to be rewritten by a PPX for the
compilation to proceed.

The syntax for extension nodes is `[%extension_name payload]` where, again, the
number of `%` determines the kind of extension node: `%` is for "inside nodes,"
such as expressions and patterns, and `%%` is for "toplevel nodes," such as
structure/signature items or class fields. See the [formal
syntax](https://v2.ocaml.org/manual/extensionnodes.html).

```ocaml
let v = [%html "<a href='ocaml.org'>OCaml!</a>"]
```

Sometimes a shorter infix syntax can be used, where the extension node's name is
appended to a `let`, `begin`, `module`, `val` or similar. A formal definition of the
syntax can be found in the OCaml
[manual](https://v2.ocaml.org/manual/extensionnodes.html).

```ocaml
let%html other_syntax = "<a href='ocaml.org'>OCaml!</a>"
```

Extension nodes are meant to be rewritten by a PPX and, in this regard,
correspond to a specific kind of PPX: extenders. An extender is a PPX rewriter
which will replace all occurrences of extension nodes with a matching name. It does this with 
some generated code that depends only on the payload, without information on the
context of the extension node (that is, without access to the rest of the code)
and without modifying anything else.

Examples of extenders include:
- Extenders which allow users to write OCaml values representing another language 
  directly in such language. For example:
      - `ppx_yojson` to generate `Yojson` values by writing JSON code
      - `tyxml-ppx` to generate `Tyxml.Html` values by writing HTML code
      - `ppx_mysql` to generate `ocaml-mysql` queries by writing MySQL
        queries
- `ppx_expect` to generate CRAM tests from the extension node's payload.

### Using PPXs

Similarly to preprocessors for the text source code, OCaml's compiler provides
the `-ppx` option to run a PPX during the compilation phase. The PPX will read
the Parsetree from a file, where the marshalled value has been dumped, and output
the rewritten Parsetree the same way.

But again, since the tool responsible for driving the compilation is Dune, using
PPXs is just a matter of writing `dune` files. The same `preprocess` stanza
should be used, this time with `pps`:

```dune
  (preprocess (pps ppx1 ppx2))
```

And that's all you need to use PPXs! Although these instructions will work for
most PPXs, note that the first source of information will be the package
documentation, as some PPXs might need some special care to integrate with
Dune.

### Why PPXs Are Especially Useful in OCaml

Now that we know what a PPX is, and have seen examples of such, let's see why it
is particularly useful in OCaml.

For one, the types are lost at execution time. That means that the type's structure
cannot be deconstructed at execution time to control the flow. This is
why no general `to_string : 'a -> string` or `print : 'a -> ()` function can
exist in compiled binaries (in the toplevel, types are kept).

So any general function that depends on the type's structure _must_ be
written at compile time, when types are still available.

Secondly, one of the strong features of OCaml is its type system, which can be
used to check the sanity of many things. An example of this is the [`Tyxml`
library](https://github.com/ocsigen/tyxml), which uses the type system to ensure
that the resulting HTML value satisfies most of the W3C standards. However,
writing `Tyxml` values can be cumbersome compared to writing HTML syntax.
Transforming HTML code into OCaml values at compile time allows users to keep both the
type-checker on the produced value and the familiarity of writing HTML code.

Other rewriters, such as `ppx_expect`, show that being able to enrich the syntax
via PPX rewriters is very useful, even outside of the specificity of OCaml.

## The Need for Controlling the PPX Ecosystem: `ppxlib`

Although PPXs are great for generating code at compile time, they raise a few
questions, especially in the presence of multiple PPX rewriters.
- What is the semantics of the composition of multiple PPXs? The order might
  matter.
- How can I trust that some part of my code is not modified when using
  third-party PPXs?
- How can I keep compilation time short when using many rewriters?
- How can I write a PPX easily if I have to deal with parsing or demarshalling
  an AST?
- How can I deal with such a [long and complex
  type](https://v2.ocaml.org/api/compilerlibref/Parsetree.html) as in Parsetree?
- How can I solve the problem that new OCaml versions tend to add new features to the language and therefore need to enrich and break the Parsetree types?

The answer to these issues from the OCaml community is a platform tool to write
PPXes: [ppxlib](https://github.com/ocaml-ppx/ppxlib/). It takes care of easing
the process of writing a PPX, ensures that composition is not too much of a
problem, and factors the work in case of multiple rewriters applied to a file as
much as possible.

The idea of `ppxlib` is that PPX authors can concentrate on their own part—the
rewriting logic. Then, they can register their transformation, and `ppxlib` will
be responsible for the rest of the work that all PPXs have to do: getting the
Parsetree, giving it back to the compiler, and creating an executable with a
good CLI. Multiple transformations can be registered to generate a single
binary.

### One PPX for Multiple OCaml Versions

One subtlety in writing a PPX is the the fact that the types of the Parsetree
module might change when a new feature is added to the language. To keep a PPX
compatible with a new version, it would have to update the transformation from
the old types to the new ones. But, by doing so, it would lose compatibility
with the old OCaml version. Ideally, a single version of a PPX could preprocess
different OCaml version.

`ppxlib` deals with this issue by converting Parsetree types to and from the
latest version. A PPX author then only needs to maintain his transformation for
OCaml's latest version and get a PPX that works on any version of OCaml. For
instance, when applying a PPX written for OCaml 5.0 during a compilation with
OCaml 4.08, `ppxlib` would get the 4.08 Parsetree, transform it into a 5.00
Parsetree, use the registered PPX to transform the Parsetree, and convert it
back to a 4.08 Parsetree to continue the compilation.

### Restricting PPXs for Composition, Speed, and Security

`ppxlib` explictely supports registering the restricted transformations that
correspond to extenders and derivers. Writing those restricted PPXs has a lot
of advantages:
- Extenders and derivers won't modify your existing code, apart from the
  extension node. This is less error-prone, bugs have less critical effects, and
  a user can be confident that no sensible part of their code is changed.
- As extenders and derivers are "context-free," in the sense that they run only
  with a limited part of the AST as input, they can all be run in a single pass
  of the AST. Moreover, they are not run "one after the other" but all at the
  same time, so their composition semantics do not depend on the order of
  execution.
- This single pass also means faster rewriting and thus faster compilation time
  for the projects using multiple PPXs.

Compared to this, rewriters that work on the whole AST can also be registered in
`ppxlib`, and they will be run in alphabetical order by their name, after the
context-free pass.

Note that Dune combines all PPXs written using `ppxlib` in a single
preprocessor binary, even if the PPXs come from different packages.

### Writing a PPX

If you want to write your own PPX, the place to start is [ppxlib's
documentation](https://ocaml.org/p/ppxlib/0.27.0/doc/index.html).
