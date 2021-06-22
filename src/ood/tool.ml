
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
  { name = "Bun"
  ; slug = "bun"
  ; source = "https://github.com/yomimono/ocaml-bun"
  ; license = "MIT"
  ; synopsis = "Simple management of afl-fuzz processes"
  ; description = "<p>A wrapper for OCaml processes using afl-fuzz, intended for easy use in CI environments.</p>\n"
  ; lifecycle = `Incubate
  };
 
  { name = "Mdx"
  ; slug = "mdx"
  ; source = "https://github.com/realworldocaml/mdx"
  ; license = "ISC"
  ; synopsis = "Executable code blocks inside markdown files"
  ; description = "<p><code>ocaml-mdx</code> allows to execute code blocks inside markdown files. There are (currently) two sub-commands, corresponding to two modes of operations: pre-processing (<code>ocaml-mdx pp</code>) and tests (<code>ocaml-mdx test</code>).\nThe pre-processor mode allows to mix documentation and code, and to practice &quot;literate programming&quot; using markdown and OCaml.\nThe test mode allows to ensure that shell scripts and OCaml fragments in the documentation always stays up-to-date.\n<code>ocaml-mdx</code> is released as two binaries called <code>ocaml-mdx</code> and <code>mdx</code> which are the same, mdx being the deprecate name, kept for now for compatibility.</p>\n"
  ; lifecycle = `Incubate
  };
 
  { name = "OCamlFormat"
  ; slug = "ocamlformat"
  ; source = "https://github.com/ocaml-ppx/ocamlformat"
  ; license = "MIT"
  ; synopsis = "Auto-formatter for OCaml code"
  ; description = "<p>OCamlFormat is a tool to automatically format OCaml code in a uniform style.</p>\n"
  ; lifecycle = `Incubate
  };
 
  { name = "Dune-release"
  ; slug = "dune-release"
  ; source = "https://github.com/ocamllabs/dune-release"
  ; license = "ISC"
  ; synopsis = "Release dune packages in opam"
  ; description = "<p><code>dune-release</code> is a tool to streamline the release of Dune packages in <a href=\"https://opam.ocaml.org\">opam</a>. It supports projects built with <a href=\"https://github.com/ocaml/dune\">Dune</a> and hosted on <a href=\"https://github.com\">GitHub</a>.</p>\n"
  ; lifecycle = `Incubate
  };
 
  { name = "OCaml LSP"
  ; slug = "ocaml-lsp"
  ; source = "https://github.com/ocaml/ocaml-lsp"
  ; license = "ISC"
  ; synopsis = "LSP Server for OCaml"
  ; description = "<p>An LSP server for OCaml.</p>\n"
  ; lifecycle = `Incubate
  };
 
  { name = "Merlin"
  ; slug = "merlin"
  ; source = "https://github.com/ocaml/merlin"
  ; license = "MIT"
  ; synopsis = "Editor helper, provides completion, typing and source browsing in Vim and Emacs"
  ; description = "<p>Merlin is an assistant for editing OCaml code. It aims to provide the features available in modern IDEs: error reporting, auto completion, source browsing and much more.</p>\n"
  ; lifecycle = `Active
  };
 
  { name = "ppxlib"
  ; slug = "ppxlib"
  ; source = "https://github.com/ocaml-ppx/ppxlib"
  ; license = "MIT"
  ; synopsis = "Standard library for ppx rewriters"
  ; description = "<p>Ppxlib is the standard library for ppx rewriters and other programs that manipulate the in-memory reprensation of OCaml programs, a.k.a the &quot;Parsetree&quot;.\nIt also comes bundled with two ppx rewriters that are commonly used to write tools that manipulate and/or generate Parsetree values; <code>ppxlib.metaquot</code> which allows to construct Parsetree values using the OCaml syntax directly and <code>ppxlib.traverse</code> which provides various ways of automatically traversing values of a given type, in particular allowing to inject a complex structured value into generated code.</p>\n"
  ; lifecycle = `Active
  };
 
  { name = "opam-publish"
  ; slug = "opam-publish"
  ; source = "https://github.com/ocaml-opam/opam-publish"
  ; license = "LGPLv2"
  ; synopsis = "A tool to ease contributions to opam repositories"
  ; description = "<p>opam-publish automates publishing packages to package repositories: it checks that the opam file is complete using <code>opam lint</code>, verifies and adds the archive URL and its checksum and files a GitHub pull request for merging it.</p>\n"
  ; lifecycle = `Active
  };
 
  { name = "utop"
  ; slug = "utop"
  ; source = "https://github.com/ocaml-community/utop"
  ; license = "3 Clause BSD"
  ; synopsis = "Universal toplevel for OCaml"
  ; description = "<p>utop is an improved toplevel (i.e., Read-Eval-Print Loop or REPL) for OCaml.  It can run in a terminal or in Emacs. It supports line edition, history, real-time and context sensitive completion, colors, and more.  It integrates with the Tuareg mode in Emacs.</p>\n"
  ; lifecycle = `Active
  };
 
  { name = "Dune"
  ; slug = "dune"
  ; source = "https://github.com/ocaml/dune"
  ; license = "MIT"
  ; synopsis = "Fast, portable, and opinionated build system"
  ; description = "<p>dune is a build system that was designed to simplify the release of Jane Street packages. It reads metadata from &quot;dune&quot; files following a very simple s-expression syntax.\ndune is fast, has very low-overhead, and supports parallel builds on all platforms. It has no system dependencies; all you need to build dune or packages using dune is OCaml. You don't need make or bash as long as the packages themselves don't use bash explicitly.\ndune supports multi-package development by simply dropping multiple repositories into the same directory.\nIt also supports multi-context builds, such as building against several opam roots/switches simultaneously. This helps maintaining packages across several versions of OCaml and gives cross-compilation for free.</p>\n"
  ; lifecycle = `Active
  };
 
  { name = "omp"
  ; slug = "omp"
  ; source = "https://github.com/ocaml-ppx/ocaml-migrate-parsetree"
  ; license = "LGPLv2"
  ; synopsis = "Convert OCaml parsetrees between different versions"
  ; description = "<p>Convert OCaml parsetrees between different versions\nThis library converts parsetrees, outcometree and ast mappers between different OCaml versions.  High-level functions help making PPX rewriters independent of a compiler version.</p>\n"
  ; lifecycle = `Sustain
  };
 
  { name = "ocamlbuild"
  ; slug = "ocamlbuild"
  ; source = "https://github.com/ocaml/ocamlbuild"
  ; license = "LGPLv2"
  ; synopsis = "OCamlbuild is a build system with builtin rules to easily build most OCaml projects"
  ; description = ""
  ; lifecycle = `Sustain
  };
 
  { name = "ocamlfind"
  ; slug = "ocamlfind"
  ; source = "https://github.com/ocaml/ocamlfind"
  ; license = "MIT"
  ; synopsis = "A library manager for OCaml"
  ; description = "<p>Findlib is a library manager for OCaml. It provides a convention how to store libraries, and a file format (&quot;META&quot;) to describe the properties of libraries. There is also a tool (ocamlfind) for interpreting the META files, so that it is very easy to use libraries in programs and scripts.</p>\n"
  ; lifecycle = `Sustain
  };
 
  { name = "ocp-indent"
  ; slug = "ocp-indent"
  ; source = "https://github.com/OCamlPro/ocp-indent"
  ; license = "LGPLv2"
  ; synopsis = "A simple tool to indent OCaml programs"
  ; description = "<p>Ocp-indent is based on an approximate, tolerant OCaml parser and a simple stack machine ; this is much faster and more reliable than using regexps. Presets and configuration options available, with the possibility to set them project-wide. Supports most common syntax extensions, and extensible for others.\nIncludes: - An indentor program, callable from the command-line or from within editors - Bindings for popular editors - A library that can be directly used by editor writers, or just for\nfault-tolerant/approximate parsing.</p>\n"
  ; lifecycle = `Sustain
  };
 
  { name = "oasis"
  ; slug = "oasis"
  ; source = "https://github.com/ocaml/oasis"
  ; license = "LGPLv2"
  ; synopsis = "Tooling for building OCaml libraries and applications"
  ; description = "<p>OASIS generates a full configure, build and install system for your application. It starts with a simple _oasis file at the toplevel of your project and creates everything required.\nOASIS leverages existing OCaml tooling to perform most of it's work. In fact, it might be more appropriate to think of it as simply the glue that binds these other subsystems together and coordinates the work that they do. It should support the following tools:</p>\n<ul>\n<li>OCamlbuild - OMake - OCamlMakefile (todo), - ocaml-autoconf (todo)\nIt also features a do-it-yourself command line invocation and an internal configure/install scheme. Libraries are managed through findlib. It has been tested on GNU Linux and Windows.\nIt also allows to have standard entry points and description. It helps to integrates your libraries and software with third parties tools like OPAM.\n</li>\n</ul>\n"
  ; lifecycle = `Deprecate
  };
 
  { name = "camlp4"
  ; slug = "camlp4"
  ; source = "https://github.com/camlp4/camlp4"
  ; license = "LGPLv2"
  ; synopsis = "Camlp4 is a system for writing extensible parsers for programming languages"
  ; description = "<p>It provides a set of OCaml libraries that are used to define grammars as well as loadable syntax extensions of such grammars. Camlp4 stands for Caml Preprocessor and Pretty-Printer and one of its most important applications is the definition of domain-specific extensions of the syntax of OCaml.\nCamlp4 was part of the official OCaml distribution until its version 4.01.0. Since then it has been replaced by a simpler system which is easier to maintain and to learn: ppx rewriters and extension points.</p>\n"
  ; lifecycle = `Deprecate
  }]

