---
name: MDX
slug: mdx
source: https://github.com/realworldocaml/mdx
license: ISC
synopsis: Executable Codeblocks Inside Markdown Files
lifecycle: incubate
---

`ocaml-mdx` allows to execute code blocks inside markdown files.
There are (currently) two sub-commands, corresponding
to two modes of operations: pre-processing (`ocaml-mdx pp`)
and tests (`ocaml-mdx test`).

The preprocessor mode allows to mix documentation and code,
and to practice "literate programming" using markdown and OCaml.

The test mode allows to ensure that shell scripts and OCaml fragments
in the documentation always stays up-to-date.

`ocaml-mdx` is released as two binaries called `ocaml-mdx` and `mdx` which are
the same, `mdx` being the deprecate name, kept for now for compatibility.
