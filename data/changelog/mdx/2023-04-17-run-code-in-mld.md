---
title: Execute Code Blocks in Mld Files
date: "2023-04-17-01"
tags: [mdx, platform]
---

The most significant change in the recent release of MDX 2.3.0 is the support for `.mld` files. This brings the number of supported input formats to four:

 * Markdown, the initial target of MDX
 * Cram tests (`.t`)
 * `.mli` files
 * `.mld` files

For an OCaml programmer, the first three are quite common, but what are `.mld` files? `.mld` files are text files similar to Markdown, but instead of using the Markdown markup language they use the Ocamldoc markdown language - as is used in `.mli` files.

These files can be used e.g. with [odoc](https://ocaml.github.io/odoc/) to generate standalone documentation like howto documents or tutorials, without having to use two different markup formats.

As an examle, `tutorial.mld`

```ocaml=
Here is some OCaml code that is wrong

{|
  # List.map (fun x -> x * x) [(1 + 9); 2; 3; 4];;
  - : int list = [1; 2; 3; 4]
|}
```

When `(using mdx 0.3)` via the [MDX support in Dune](https://dune.readthedocs.io/en/stable/dune-files.html#mdx) it only picks up `.md` files by default, but you can this to your `dune` file:

```scheme=
(mdx
  (files tutorial.mld))
```

So when you will run `dune runtest` it will run the file, run the code and detect that the output is wrong. You can then use `dune promote` to update your `.mld` file with the corrected file.
