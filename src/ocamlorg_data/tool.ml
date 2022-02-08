
type lifecycle =
  [ `Incubate
  | `Active
  | `Sustain
  | `Deprecate
  ]

type t =
  { name : string
  ; slug : string
  ; source : string
  ; license : string
  ; synopsis : string
  ; description : string
  ; lifecycle : lifecycle
  }
  
let all = 
[
  { name = {js|odoc|js}
  ; slug = {js|odoc|js}
  ; source = {js|https://github.com/ocaml/odoc|js}
  ; license = {js|ISC|js}
  ; synopsis = {js|Documentation generator for OCaml|js}
  ; description = {js|<p>Documentation generator for OCaml</p>
|js}
  ; lifecycle = `Incubate
  };
 
  { name = {js|mdx|js}
  ; slug = {js|mdx|js}
  ; source = {js|https://github.com/realworldocaml/mdx|js}
  ; license = {js|ISC|js}
  ; synopsis = {js|Executable code blocks inside markdown files|js}
  ; description = {js|<p><code>ocaml-mdx</code> allows to execute code blocks inside markdown files. There are (currently) two sub-commands, corresponding to two modes of operations: pre-processing (<code>ocaml-mdx pp</code>) and tests (<code>ocaml-mdx test</code>).
The pre-processor mode allows to mix documentation and code, and to practice &quot;literate programming&quot; using markdown and OCaml.
The test mode allows to ensure that shell scripts and OCaml fragments in the documentation always stays up-to-date.
<code>ocaml-mdx</code> is released as two binaries called <code>ocaml-mdx</code> and <code>mdx</code> which are the same, mdx being the deprecate name, kept for now for compatibility.</p>
|js}
  ; lifecycle = `Incubate
  };
 
  { name = {js|ocamlformat|js}
  ; slug = {js|ocamlformat|js}
  ; source = {js|https://github.com/ocaml-ppx/ocamlformat|js}
  ; license = {js|MIT|js}
  ; synopsis = {js|Auto-formatter for OCaml code|js}
  ; description = {js|<p>OCamlFormat is a tool to automatically format OCaml code in a uniform style.</p>
|js}
  ; lifecycle = `Incubate
  };
 
  { name = {js|dune-release|js}
  ; slug = {js|dune-release|js}
  ; source = {js|https://github.com/ocamllabs/dune-release|js}
  ; license = {js|ISC|js}
  ; synopsis = {js|Release dune packages in opam|js}
  ; description = {js|<p><code>dune-release</code> is a tool to streamline the release of Dune packages in <a href="https://opam.ocaml.org">opam</a>. It supports projects built with <a href="https://github.com/ocaml/dune">Dune</a> and hosted on <a href="https://github.com">GitHub</a>.</p>
|js}
  ; lifecycle = `Incubate
  };
 
  { name = {js|ocaml-lsp|js}
  ; slug = {js|ocaml-lsp|js}
  ; source = {js|https://github.com/ocaml/ocaml-lsp|js}
  ; license = {js|ISC|js}
  ; synopsis = {js|LSP Server for OCaml|js}
  ; description = {js|<p>An LSP server for OCaml.</p>
|js}
  ; lifecycle = `Incubate
  };
 
  { name = {js|bun|js}
  ; slug = {js|bun|js}
  ; source = {js|https://github.com/yomimono/ocaml-bun|js}
  ; license = {js|MIT|js}
  ; synopsis = {js|Simple management of afl-fuzz processes|js}
  ; description = {js|<p>A wrapper for OCaml processes using afl-fuzz, intended for easy use in CI environments.</p>
|js}
  ; lifecycle = `Incubate
  };
 
  { name = {js|opam|js}
  ; slug = {js|opam|js}
  ; source = {js|https://github.com/ocaml/opam|js}
  ; license = {js|LGPLv2|js}
  ; synopsis = {js|A source-based OCaml package manager|js}
  ; description = {js|<p>A source-based OCaml package manager</p>
|js}
  ; lifecycle = `Active
  };
 
  { name = {js|dune|js}
  ; slug = {js|dune|js}
  ; source = {js|https://github.com/ocaml/dune|js}
  ; license = {js|MIT|js}
  ; synopsis = {js|Fast, portable, and opinionated build system|js}
  ; description = {js|<p>dune is a build system that was designed to simplify the release of Jane Street packages. It reads metadata from &quot;dune&quot; files following a very simple s-expression syntax.
dune is fast, has very low-overhead, and supports parallel builds on all platforms. It has no system dependencies; all you need to build dune or packages using dune is OCaml. You don't need make or bash as long as the packages themselves don't use bash explicitly.
dune supports multi-package development by simply dropping multiple repositories into the same directory.
It also supports multi-context builds, such as building against several opam roots/switches simultaneously. This helps maintaining packages across several versions of OCaml and gives cross-compilation for free.</p>
|js}
  ; lifecycle = `Active
  };
 
  { name = {js|merlin|js}
  ; slug = {js|merlin|js}
  ; source = {js|https://github.com/ocaml/merlin|js}
  ; license = {js|MIT|js}
  ; synopsis = {js|Editor helper, provides completion, typing and source browsing in Vim and Emacs|js}
  ; description = {js|<p>Merlin is an assistant for editing OCaml code. It aims to provide the features available in modern IDEs: error reporting, auto completion, source browsing and much more.</p>
|js}
  ; lifecycle = `Active
  };
 
  { name = {js|ppxlib|js}
  ; slug = {js|ppxlib|js}
  ; source = {js|https://github.com/ocaml-ppx/ppxlib|js}
  ; license = {js|MIT|js}
  ; synopsis = {js|Standard library for ppx rewriters|js}
  ; description = {js|<p>Ppxlib is the standard library for ppx rewriters and other programs that manipulate the in-memory reprensation of OCaml programs, a.k.a the &quot;Parsetree&quot;.
It also comes bundled with two ppx rewriters that are commonly used to write tools that manipulate and/or generate Parsetree values; <code>ppxlib.metaquot</code> which allows to construct Parsetree values using the OCaml syntax directly and <code>ppxlib.traverse</code> which provides various ways of automatically traversing values of a given type, in particular allowing to inject a complex structured value into generated code.</p>
|js}
  ; lifecycle = `Active
  };
 
  { name = {js|opam-publish|js}
  ; slug = {js|opam-publish|js}
  ; source = {js|https://github.com/ocaml-opam/opam-publish|js}
  ; license = {js|LGPLv2|js}
  ; synopsis = {js|A tool to ease contributions to opam repositories|js}
  ; description = {js|<p>opam-publish automates publishing packages to package repositories: it checks that the opam file is complete using <code>opam lint</code>, verifies and adds the archive URL and its checksum and files a GitHub pull request for merging it.</p>
|js}
  ; lifecycle = `Active
  };
 
  { name = {js|utop|js}
  ; slug = {js|utop|js}
  ; source = {js|https://github.com/ocaml-community/utop|js}
  ; license = {js|3 Clause BSD|js}
  ; synopsis = {js|Universal toplevel for OCaml|js}
  ; description = {js|<p>utop is an improved toplevel (i.e., Read-Eval-Print Loop or REPL) for OCaml.  It can run in a terminal or in Emacs. It supports line edition, history, real-time and context sensitive completion, colors, and more.  It integrates with the Tuareg mode in Emacs.</p>
|js}
  ; lifecycle = `Active
  };
 
  { name = {js|omp|js}
  ; slug = {js|omp|js}
  ; source = {js|https://github.com/ocaml-ppx/ocaml-migrate-parsetree|js}
  ; license = {js|LGPLv2|js}
  ; synopsis = {js|Convert OCaml parsetrees between different versions|js}
  ; description = {js|<p>Convert OCaml parsetrees between different versions
This library converts parsetrees, outcometree and ast mappers between different OCaml versions.  High-level functions help making PPX rewriters independent of a compiler version.</p>
|js}
  ; lifecycle = `Sustain
  };
 
  { name = {js|ocamlbuild|js}
  ; slug = {js|ocamlbuild|js}
  ; source = {js|https://github.com/ocaml/ocamlbuild|js}
  ; license = {js|LGPLv2|js}
  ; synopsis = {js|OCamlbuild is a build system with builtin rules to easily build most OCaml projects|js}
  ; description = {js||js}
  ; lifecycle = `Sustain
  };
 
  { name = {js|ocamlfind|js}
  ; slug = {js|ocamlfind|js}
  ; source = {js|https://github.com/ocaml/ocamlfind|js}
  ; license = {js|MIT|js}
  ; synopsis = {js|A library manager for OCaml|js}
  ; description = {js|<p>Findlib is a library manager for OCaml. It provides a convention how to store libraries, and a file format (&quot;META&quot;) to describe the properties of libraries. There is also a tool (ocamlfind) for interpreting the META files, so that it is very easy to use libraries in programs and scripts.</p>
|js}
  ; lifecycle = `Sustain
  };
 
  { name = {js|ocp-indent|js}
  ; slug = {js|ocp-indent|js}
  ; source = {js|https://github.com/OCamlPro/ocp-indent|js}
  ; license = {js|LGPLv2|js}
  ; synopsis = {js|A simple tool to indent OCaml programs|js}
  ; description = {js|<p>Ocp-indent is based on an approximate, tolerant OCaml parser and a simple stack machine ; this is much faster and more reliable than using regexps. Presets and configuration options available, with the possibility to set them project-wide. Supports most common syntax extensions, and extensible for others.
Includes: - An indentor program, callable from the command-line or from within editors - Bindings for popular editors - A library that can be directly used by editor writers, or just for
fault-tolerant/approximate parsing.</p>
|js}
  ; lifecycle = `Sustain
  };
 
  { name = {js|oasis|js}
  ; slug = {js|oasis|js}
  ; source = {js|https://github.com/ocaml/oasis|js}
  ; license = {js|LGPLv2|js}
  ; synopsis = {js|Tooling for building OCaml libraries and applications|js}
  ; description = {js|<p>OASIS generates a full configure, build and install system for your application. It starts with a simple _oasis file at the toplevel of your project and creates everything required.
OASIS leverages existing OCaml tooling to perform most of it's work. In fact, it might be more appropriate to think of it as simply the glue that binds these other subsystems together and coordinates the work that they do. It should support the following tools:</p>
<ul>
<li>OCamlbuild - OMake - OCamlMakefile (todo), - ocaml-autoconf (todo)
It also features a do-it-yourself command line invocation and an internal configure/install scheme. Libraries are managed through findlib. It has been tested on GNU Linux and Windows.
It also allows to have standard entry points and description. It helps to integrates your libraries and software with third parties tools like OPAM.
</li>
</ul>
|js}
  ; lifecycle = `Deprecate
  };
 
  { name = {js|camlp4|js}
  ; slug = {js|camlp4|js}
  ; source = {js|https://github.com/camlp4/camlp4|js}
  ; license = {js|LGPLv2|js}
  ; synopsis = {js|Camlp4 is a system for writing extensible parsers for programming languages|js}
  ; description = {js|<p>It provides a set of OCaml libraries that are used to define grammars as well as loadable syntax extensions of such grammars. Camlp4 stands for Caml Preprocessor and Pretty-Printer and one of its most important applications is the definition of domain-specific extensions of the syntax of OCaml.
Camlp4 was part of the official OCaml distribution until its version 4.01.0. Since then it has been replaced by a simpler system which is easier to maintain and to learn: ppx rewriters and extension points.</p>
|js}
  ; lifecycle = `Deprecate
  }]

